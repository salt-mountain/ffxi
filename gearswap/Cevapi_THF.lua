--[[
          Custom commands:

          Toggle Function:
          gs c toggle idlemode            Toggles between TP, DT, TH, and MOVE idle modes
          gs c toggle tpmode              Toggles TP mode on / off
          gs c toggle dtmode              Toggles DT (Damage Taken) mode on / off
          gs c toggle thmode              Toggles TH (Treasure Hunter) mode on / off
          gs c toggle movemode            Toggles MOVE mode on / off

          HUD Functions:
          gs c hud hide                   Toggles the Hud entirely on or off
          gs c hud hidemode               Toggles the Modes section of the HUD on or off
          gs c hud hidejob                Toggles the job section of the HUD on or off
          gs c hud hidebattle             Toggles the Battle section of the HUD on or off
          gs c hud lite                   Toggles the HUD in lightweight style for less screen estate usage
          gs c hud keybinds               Toggles Display of the HUD keybindings
  --]] -------------------------------------------------------------
--
--      ,---.     |    o
--      |   |,---.|--- .,---.,---.,---.
--      |   ||   ||    ||   ||   |`---.
--      `---'|---'`---'``---'`   '`---'
--           |
-------------------------------------------------------------
res = require('resources')
texts = require('texts')
include('Modes.lua')

-- Define your modes:
-- You can add or remove modes in the table below, they will get picked up in the cycle automatically.
idleModes = M('tp', 'dt', 'th', 'move')

-- Setting this to true will stop the text spam, and instead display modes in a UI.
use_UI = true
hud_x_pos = 1400 -- important to update these if you have a smaller screen
hud_y_pos = 200 -- important to update these if you have a smaller screen
hud_draggable = true
hud_font_size = 10
hud_transparency = 200 -- a value of 0 (invisible) to 255 (no transparency at all)
hud_font = 'Impact'

-- Setup your Key Bindings here:
windower.send_command('bind f9 gs c toggle idlemode') -- F9 to change Idle Mode
windower.send_command('bind f10 gs c toggle tpmode') -- F10 to toggle TP mode
windower.send_command('bind f11 gs c toggle dtmode') -- F11 to toggle DT mode
windower.send_command('bind f12 gs c toggle thmode') -- F12 to toggle TH mode
windower.send_command('bind !f9 gs c toggle movemode') -- Alt-F9 to toggle MOVE mode

--[[
      This gets passed in when the Keybinds is turned on.
      Each one matches to a given variable within the text object
      IF you changed the Default Keybind above, Edit the ones below so it can be reflected in the hud using "//gs c
  hud keybinds" command
  ]]
keybinds_on = {}
keybinds_on['key_bind_idle'] = '(F9)'
keybinds_on['key_bind_tp'] = '(F10)'
keybinds_on['key_bind_dt'] = '(F11)'
keybinds_on['key_bind_th'] = '(F12)'
keybinds_on['key_bind_move'] = '(ALT-F9)'

-- Remember to unbind your keybinds on job change.
function user_unload()
    send_command('unbind f9')
    send_command('unbind f10')
    send_command('unbind f11')
    send_command('unbind f12')
    send_command('unbind !f9')
end

--------------------------------------------------------------------------------------------------------------
-- Optional. Swap to your thf macro sheet / book
-- set_macros(1, 1) -- Sheet, Book
--------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------
--      ,---.                         |
--      |  _.,---.,---.,---.,---.,---.|--- ,---.
--      |   ||---',---||    `---.|---'|    `---.
--      `---'`---'`---^`    `---'`---'`---'`---'
-------------------------------------------------------------

-- Setup your Gear Sets below:
function get_sets()

    -- My formatting is very easy to follow. All sets that pertain to my character doing things are under 'me'.

    sets.me = {} -- leave this empty
    sets.buff = {} -- leave this empty
    sets.me.idle = {} -- leave this empty
    sets.precast = {} -- Leave this empty
    sets.midcast = {} -- Leave this empty
    sets.aftercast = {} -- Leave this empty

    -----------------------------------------------------------------------------
    -- BASE SETS - These are the foundation sets that modes will build upon
    -----------------------------------------------------------------------------

    -- Base Idle Set - Default idle set when not in combat
    sets.me.idle.base = {
        -- Add your base idle gear here
        -- This should focus on refresh, regen, and general survivability
    }

    -- Base Treasure Hunter Set - Core TH gear
    sets.me.idle.treasurehunter = {
        -- Add your Treasure Hunter gear here
        -- This set should maximize TH+ equipment
    }

    -- Base Damage Taken Set - Core DT gear
    sets.me.idle.damagetaken = {
        -- Add your damage reduction gear here
        -- Focus on PDT-, MDT-, and general damage reduction
    }

    -- Base Movement Set - Movement speed gear
    sets.me.idle.movement = {
        -- Add your movement speed gear here
        -- This set should maximize movement speed
        left_ring = "Shneddick ring",
        right_ring = "Warp ring",
        
    }

    -- Base Weapon Skill Set - Foundation for all weapon skills
    sets.me.weaponskill_base = {
        -- Add your base weapon skill gear here
        -- This should have general WS stats (STR, DEX, Attack, etc)
    }

    -----------------------------------------------------------------------------
    -- MODE SETS - These combine base sets with mode-specific augmentations
    -----------------------------------------------------------------------------

    -- TP Mode - Focuses on building TP and melee performance
    sets.me.idle.tp = set_combine(sets.me.idle.base, {
        -- Add TP-specific gear here
        -- Focus on: Store TP, Haste, Triple Attack, Double Attack, Multi-Attack
        main = "Tauret",
        sub = {
            name = "Shijo",
            augments = {'DEX+15', '"Dual Wield"+5', '"Triple Atk."+2'}
        },
        ammo = "Aurgelmir Orb",
        head = "Adhemar Bonnet +1",
        body = "Mummu Jacket +2",
        hands = "Mummu Wrists",
        legs = "Meg. Chausses +2",
        feet = "Mummu Gamash. +2",
        neck = "Chivalrous Chain",
        waist = "Patentia Sash",
        left_ear = "Brutal Earring",
        right_ear = "Mache Earring +1",
        left_ring = "Petrov Ring",
        right_ring = "Chirich Ring +1",
        back = {
            name = "Mecisto. Mantle",
            augments = {'Cap. Point+30%', 'HP+25', 'Rng.Acc.+1', 'DEF+8'}
        }
    })

    -- DT Mode - Combines base idle with damage taken reduction
    sets.me.idle.dt = set_combine(sets.me.idle.base, sets.me.idle.damagetaken, {
        -- Add any additional DT-specific overrides here
    })

    -- TH Mode - Combines base idle with treasure hunter gear
    sets.me.idle.th = set_combine(sets.me.idle.base, sets.me.idle.treasurehunter, {
        -- Add any additional TH-specific overrides here
    })

    -- MOVE Mode - Combines base idle with movement gear
    sets.me.idle.move = set_combine(sets.me.idle.base, sets.me.idle.movement, {
        -- Add any additional movement-specific overrides here
    })

    -----------------------------------------------------------------------------
    -- ENGAGED SETS - Melee combat sets that also use mode combinations
    -----------------------------------------------------------------------------

    -- Engaged TP Set
    sets.me.engaged = {}
    sets.me.engaged.tp = set_combine(sets.me.idle.tp, {
        -- Add engaged-specific TP gear here
        -- This is your main melee DPS set
    })

    -- Engaged DT Set
    sets.me.engaged.dt = set_combine(sets.me.idle.dt, {
        -- Add engaged DT gear here
        -- Balance damage reduction with melee performance
    })

    -- Engaged TH Set
    sets.me.engaged.th = set_combine(sets.me.idle.th, {
        -- Add engaged TH gear here
        -- Maintain TH while in melee
    })

    -- Engaged MOVE Set
    sets.me.engaged.move = set_combine(sets.me.idle.movement, {
        -- Add engaged movement gear here if different
    })

    -----------------------------------------------------------------------------
    -- WEAPON SKILL SETS
    -----------------------------------------------------------------------------

    -- Common Thief Weapon Skills - Each builds on the base WS set

    -- Exenterator - Multi-hit DEX-based WS
    sets.me["Exenterator"] = set_combine(sets.me.weaponskill_base, {
        -- Add Exenterator-specific gear
        -- Focus on: DEX, Attack, Multi-Attack
    })

    -- Dancing Edge - 5-hit DEX/CHR-based WS
    sets.me["Dancing Edge"] = set_combine(sets.me.weaponskill_base, {
        -- Add Dancing Edge-specific gear
        -- Focus on: DEX, CHR, Attack
    })

    -- Evisceration - Critical hit-based WS
    sets.me["Evisceration"] = set_combine(sets.me.weaponskill_base, {
        -- Add Evisceration-specific gear
        -- Focus on: DEX, Crit Rate, Crit Damage
    })

    -- Rudra's Storm - High damage DEX-based WS
    sets.me["Rudra's Storm"] = set_combine(sets.me.weaponskill_base, {
        -- Add Rudra's Storm-specific gear
        -- Focus on: DEX, WSD%, Attack
    })

    -- Aeolian Edge - Magical WS for AoE
    sets.me["Aeolian Edge"] = set_combine(sets.me.weaponskill_base, {
        -- Add Aeolian Edge-specific gear
        -- Focus on: INT, MAB, Magic Accuracy
    })

    -- Shark Bite - High damage single-hit WS
    sets.me["Shark Bite"] = set_combine(sets.me.weaponskill_base, {
        -- Add Shark Bite-specific gear
        -- Focus on: AGI, DEX, Attack, WSD%
    })

    -----------------------------------------------------------------------------
    -- JOB ABILITY SETS
    -----------------------------------------------------------------------------

    -- Perfect Dodge
    sets.precast["Perfect Dodge"] = {
        -- Add Perfect Dodge enhancement gear here
    }

    -- Steal
    sets.precast["Steal"] = {
        -- Add Steal enhancement gear here
    }

    -- Mug
    sets.precast["Mug"] = set_combine(sets.me.idle.treasurehunter, {
        -- Add Mug-specific gear here
    })

    -- Collaborator
    sets.precast["Collaborator"] = {
        -- Add Collaborator enhancement gear here
    }

    -- Accomplice
    sets.precast["Accomplice"] = {
        -- Add Accomplice enhancement gear here
    }

    -- Flee
    sets.precast["Flee"] = {
        -- Add Flee enhancement gear here
    }

    -- Hide
    sets.precast["Hide"] = {
        -- Add Hide enhancement gear here
    }

    -- Conspirator
    sets.precast["Conspirator"] = {
        -- Add Conspirator enhancement gear here
    }

    -- Despoil - Uses TH gear
    sets.precast["Despoil"] = set_combine(sets.me.idle.treasurehunter, {
        -- Add any additional Despoil-specific gear here
    })

    ------------
    -- Precast
    ------------

    -- Fast Cast set for spells (if using /RDM, /WHM, /BLM sub)
    sets.precast.casting = {
        -- Add fast cast gear here if using magic subjob
    }

    ------------
    -- Midcast
    ------------

    -- Utsusemi casting
    sets.midcast["Utsusemi: Ichi"] = {
        -- Add Utsusemi-specific gear here
    }

    sets.midcast["Utsusemi: Ni"] = {
        -- Add Utsusemi-specific gear here
    }

    -- Generic midcast for spells
    sets.midcast.casting = {
        -- Add generic spell midcast gear here
    }

end

-------------------------------------------------------------
-- Functions for handling mode changes and gear swaps
-------------------------------------------------------------

function precast(spell)
    -- Handle precast gear swapping
    if sets.precast[spell.english] then
        equip(sets.precast[spell.english])
    elseif spell.type == 'WeaponSkill' then
        if sets.me[spell.english] then
            equip(sets.me[spell.english])
        else
            equip(sets.me.weaponskill_base)
        end
    elseif spell.action_type == 'Magic' then
        equip(sets.precast.casting)
    end
end

function midcast(spell)
    -- Handle midcast gear swapping
    if sets.midcast[spell.english] then
        equip(sets.midcast[spell.english])
    elseif spell.action_type == 'Magic' then
        equip(sets.midcast.casting)
    end
end

function aftercast(spell)
    -- Return to appropriate idle or engaged set after action
    choose_set()
end

function status_change(new, old)
    -- Handle status changes (Idle, Engaged, Resting, etc)
    choose_set()
end

function choose_set()
    -- Determine which set to equip based on current status and mode
    if player.status == 'Engaged' then
        equip(sets.me.engaged[idleModes.current])
    else
        equip(sets.me.idle[idleModes.current])
    end
end

function self_command(command)
    -- Handle custom commands
    if command == 'toggle idlemode' then
        idleModes:cycle()
        add_to_chat(123, 'Idle Mode: ' .. idleModes.current)
        choose_set()
    elseif command == 'toggle tpmode' then
        idleModes:set('tp')
        add_to_chat(123, 'TP Mode: ON')
        choose_set()
    elseif command == 'toggle dtmode' then
        idleModes:set('dt')
        add_to_chat(123, 'DT Mode: ON')
        choose_set()
    elseif command == 'toggle thmode' then
        idleModes:set('th')
        add_to_chat(123, 'TH Mode: ON')
        choose_set()
    elseif command == 'toggle movemode' then
        idleModes:set('move')
        add_to_chat(123, 'MOVE Mode: ON')
        choose_set()
    end
end
