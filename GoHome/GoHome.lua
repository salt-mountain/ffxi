--[[
Copyright © 2026, salt-mountain (Cevapi)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of GoHome nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL salt-mountain (Cevapi) BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]

_addon.name    = 'GoHome'
_addon.author  = 'Cevapi'
_addon.version = '1.1.0'
_addon.commands = {'gohome', 'gh'}

local packets = require('packets')
local res     = require('resources')
local config  = require('config')

-------------------------------------------------------------------------------
-- Default settings. These are used the first time the addon runs; after that,
-- the persisted values in data/settings.xml take over. Edit here to change the
-- baseline, or use the //gh commands (which save automatically).
-------------------------------------------------------------------------------
local defaults = {
    -- Who is allowed to trigger any rule. Case-insensitive. Add more names freely.
    allowed_senders = { 'Aurievaryn' },

    -- Anti-spam cooldown (seconds). Repeated triggers inside this window are
    -- ignored silently, so triggers can't be spammed. Tracked per (sender, phrase).
    cooldown_seconds = 30,

    -- Human-like delay before acting, randomized between these two (seconds).
    jitter_min = 1.5,
    jitter_max = 4.0,

    -- Reply back to the sender via /tell when an item action can't run (no item)?
    reply_on_missing = true,
}

-- Load persisted per-value settings (falls back to defaults on first run).
-- //gh commands call settings:save() so senders/phrase survive reloads.
local settings = config.load(defaults)

-------------------------------------------------------------------------------
-- RULES — phrase -> action mapping. This is the extension point: to add a new
-- behavior later, just append a rule here. No other code needs to change.
--
-- Each rule = { phrase = <trigger text>, action = <type>, ... }. Supported
-- action types (see run_action() below) and their required fields:
--   action = 'item'    → item  = "<item name>"   (uses the item if held; else
--                                                  optionally /tells the sender)
--   action = 'reply'   → text  = "<message>"     (/tells the message back)
--   action = 'command' → command = "<input>"     (runs a raw game command,
--                                                  e.g. '/ma "Warp" <me>')
-- Matching is case-insensitive and trimmed. Rules are kept in code (not the
-- persisted XML) because nested tables don't serialize cleanly there, and rule
-- behavior is something you'd edit in-file anyway.
-------------------------------------------------------------------------------
local rules = {
    { phrase = 'go home', action = 'item', item = 'Instant Warp' },

    -- Future examples (delete or edit freely):
    -- { phrase = 'status',  action = 'reply',   text = 'All good here.' },
    -- { phrase = 'warp me', action = 'command', command = '/ma "Warp" <me>' },
}

-------------------------------------------------------------------------------

-- Is a given 0x017 Mode byte a /tell? The raw Mode byte is the res.chat *id*
-- (tell = 3), not the 'incoming' value (12), so we resolve it by lookup rather
-- than depending on a magic number.
local function mode_is_tell(mode)
    local entry = res.chat[mode]
    return entry and entry.en == 'tell'
end

-- Cooldown state: last-fire timestamp per lowercased sender name.
local last_fire = {}

-- Fast lookup set of allowed senders (lowercased), rebuilt whenever the list changes.
local allowed = {}
local function rebuild_allowed()
    allowed = {}
    for _, name in ipairs(settings.allowed_senders) do
        allowed[name:lower()] = true
    end
end
rebuild_allowed()

local function trim(s)
    return (s:gsub('^%s*(.-)%s*$', '%1'))
end

local function log(msg)
    windower.add_to_chat(207, '[GoHome] ' .. msg)
end

-- Do we currently hold at least one of the named item in the main inventory?
-- Matched by resource id so a rename/short-name can't fool it. Scrolls like
-- Instant Warp are used from bag 0; get_items(0) returns that array directly.
local function have_item(item_name)
    local item_res = res.items:with('en', item_name)
             or res.items:with('name', item_name)
    if not item_res then return false end
    local target_id = item_res.id

    local inv = windower.ffxi.get_items(0)
    if not inv then return false end

    for i = 1, #inv do
        local it = inv[i]
        if it and it.id == target_id and it.count and it.count > 0 then
            return true
        end
    end
    return false
end

-- Dispatch a matched rule's action. Add a new 'elseif' branch here to support a
-- new action type; the rule table above declares which fields it carries.
local function run_action(rule, sender_display)
    if rule.action == 'item' then
        if have_item(rule.item) then
            log('Using ' .. rule.item .. ' at request of ' .. sender_display .. '.')
            windower.chat.input('/item "' .. rule.item .. '" <me>')
        else
            log('No ' .. rule.item .. ' - telling ' .. sender_display .. '.')
            if settings.reply_on_missing then
                windower.chat.input('/tell ' .. sender_display
                    .. " I don't have a " .. rule.item .. ", so I can't use it.")
            end
        end

    elseif rule.action == 'reply' then
        log('Replying to ' .. sender_display .. '.')
        windower.chat.input('/tell ' .. sender_display .. ' ' .. rule.text)

    elseif rule.action == 'command' then
        log('Running command for ' .. sender_display .. '.')
        windower.chat.input(rule.command)

    else
        log('Rule for "' .. tostring(rule.phrase) .. '" has unknown action "'
            .. tostring(rule.action) .. '".')
    end
end

-- Find the first rule whose phrase matches the (already trimmed/lowercased) text.
local function match_rule(message_lc)
    for _, rule in ipairs(rules) do
        if rule.phrase:lower() == message_lc then return rule end
    end
    return nil
end

windower.register_event('incoming chunk', function(id, data)
    if id ~= 0x017 then return end

    local packet = packets.parse('incoming', data)
    if not packet then return end
    if not mode_is_tell(packet['Mode']) then return end

    -- Sender Name is a fixed char[0xF]; strip trailing null padding.
    local sender = packet['Sender Name']
    if not sender then return end
    sender = trim(sender:gsub('%z', ''))
    if sender == '' then return end

    if not allowed[sender:lower()] then return end

    local message = trim((packet['Message'] or ''):gsub('%z', '')):lower()
    local rule = match_rule(message)
    if not rule then return end

    -- Cooldown gate runs BEFORE the jitter so a spammer can't queue up actions.
    -- Keyed per (sender, phrase) so different rules don't block each other.
    local cd_key = sender:lower() .. '|' .. message
    local now = os.clock()
    local last = last_fire[cd_key]
    if last and (now - last) < settings.cooldown_seconds then return end
    last_fire[cd_key] = now

    -- Randomized delay so the response isn't instant, then act.
    local jitter = settings.jitter_min
        + (settings.jitter_max - settings.jitter_min) * math.random()
    log(sender .. ' triggered "' .. rule.phrase .. '" - responding in '
        .. string.format('%.1f', jitter) .. 's.')
    coroutine.schedule(function()
        run_action(rule, sender)
    end, jitter)
end)

-------------------------------------------------------------------------------
-- Commands: //gh add <name> | remove <name> | list | phrase <text> | test
-- Changes to the allowed list / phrase are saved to data/settings.xml.
-------------------------------------------------------------------------------
windower.register_event('addon command', function(cmd, ...)
    cmd = (cmd or 'list'):lower()
    local args = {...}

    if cmd == 'add' then
        local name = table.concat(args, ' ')
        if name == '' then log('Usage: //gh add <name>') return end
        table.insert(settings.allowed_senders, name)
        rebuild_allowed()
        settings:save()
        log('Added allowed sender: ' .. name)

    elseif cmd == 'remove' or cmd == 'del' then
        local name = table.concat(args, ' '):lower()
        local removed = false
        for i = #settings.allowed_senders, 1, -1 do
            if settings.allowed_senders[i]:lower() == name then
                log('Removed allowed sender: ' .. settings.allowed_senders[i])
                table.remove(settings.allowed_senders, i)
                removed = true
            end
        end
        if removed then
            rebuild_allowed()
            settings:save()
        else
            log('No allowed sender matching: ' .. name)
        end

    elseif cmd == 'test' then
        -- Run a rule's action now (no cooldown). //gh test [phrase]; defaults to
        -- the first rule. WARNING: this really performs the action (item/command).
        local phrase = table.concat(args, ' ')
        local rule = phrase ~= '' and match_rule(phrase:lower()) or rules[1]
        if not rule then log('No rule to test.') return end
        log('LIVE test of "' .. rule.phrase .. '" - this WILL perform the action.')
        run_action(rule, windower.ffxi.get_player().name)

    else -- list / help
        log('Allowed senders (' .. #settings.allowed_senders .. '):')
        for _, name in ipairs(settings.allowed_senders) do
            log('  - ' .. name)
        end
        log('Rules (' .. #rules .. '):')
        for _, rule in ipairs(rules) do
            local detail = rule.item or rule.text or rule.command or '?'
            log(('  - "%s" -> %s: %s'):format(rule.phrase, rule.action, detail))
        end
        log('Cooldown: ' .. settings.cooldown_seconds .. 's')
        log('Commands: //gh add <name> | remove <name> | list | test [phrase]')
    end
end)

log('loaded. //gh list to view config.')
