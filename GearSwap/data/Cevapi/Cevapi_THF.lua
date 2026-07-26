--[[
          Custom commands:

          Toggle Function:
          gs c toggle idlemode            Toggles between TP, DT, TH, MOVE, and SKILL idle modes
          gs c toggle tpmode              Toggles TP mode on / off
          gs c toggle dtmode              Toggles DT (Damage Taken) mode on / off
          gs c toggle thmode              Toggles TH (Treasure Hunter) mode on / off
          gs c toggle th2mode             Toggles TH2 (max Treasure Hunter + Shneddick mobility) mode on / off
          gs c toggle movemode            Toggles MOVE mode on / off
          gs c toggle skillmode           Toggles SKILL mode (Marksmanship training: Temachtiani + Musketoon/Bronze Bullet)

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
idleModes = M('tp', 'dt', 'th', 'th2', 'move', 'skill')

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
windower.send_command('bind !f10 gs c toggle skillmode') -- Alt-F10 to toggle SKILL (marksmanship training) mode
windower.send_command('bind !f11 gs c toggle th2mode') -- Alt-F11 to toggle TH2 (max TH + mobility) mode

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
keybinds_on['key_bind_skill'] = '(ALT-F10)'

-- Remember to unbind your keybinds on job change.
function user_unload()
    send_command('unbind f9')
    send_command('unbind f10')
    send_command('unbind f11')
    send_command('unbind f12')
    send_command('unbind !f9')
    send_command('unbind !f10')
    send_command('unbind !f11')
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
        -- Add TP-specific gear here
        -- Focus on: Store TP, Haste, Triple Attack, Double Attack, Multi-Attack
        main = "Tauret",
        --sub = "Ternion Dagger +1",
        sub = {
            name = "Shijo",
            augments = {'DEX+15', '"Dual Wield"+5', '"Triple Atk."+2'}
        },
        ammo = "Aurgelmir Orb",
        head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
        body = "Pillager's Vest +3",
        hands = "Adhemar wristbands +1",
        legs = "Pillager's culottes +3",
        feet = "Mummu Gamash. +2",
        neck = "Assassin's gorget +1",
        waist = "Patentia Sash",
        left_ear = "Odr Earring",
        right_ear = "Mache Earring +1",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
        -- Add your movement speed gear here
        -- This set should maximize movement speed
        left_ring = "Shneddick ring",
        right_ring = "Warp ring",
        
    }

    -- Base Weapon Skill Set - Foundation for all weapon skills
    sets.me.weaponskill_base = {
        -- Add your base weapon skill gear here
        -- This should have general WS stats (STR, DEX, Attack, etc)
        body = "Pillager's Vest +3",
        hands = "Mummu wrists +2",
        legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
        left_ear = "Odr Earring",
        right_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
        right_ring="Mummu Ring",
    }

    -----------------------------------------------------------------------------
    -- MODE SETS - These combine base sets with mode-specific augmentations
    -----------------------------------------------------------------------------

    -- TP Mode - Focuses on building TP and melee performance
    sets.me.idle.tp = set_combine(sets.me.idle.base, {
        -- Add TP-specific gear here
        -- Focus on: Store TP, Haste, Triple Attack, Double Attack, Multi-Attack
        main = "Tauret",
        --sub = "Ternion Dagger +1",
        sub = {
            name = "Shijo",
            augments = {'DEX+15', '"Dual Wield"+5', '"Triple Atk."+2'}
        },
        ammo = "Aurgelmir Orb",
        head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
        body = "Pillager's Vest +3",
        hands = "Adhemar wristbands +1",
        legs = "Pillager's culottes +3",
        feet = "Pillager's poulaines +3",
        neck = "Assassin's gorget +1",
        waist = "Patentia Sash",
        left_ear = "Odr Earring",
        right_ear = "Sherida earring",
        left_ring = "Petrov Ring",
        right_ring = "Chirich Ring +1",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
    })

    -- DT Mode - Combines base idle with damage taken reduction
    sets.me.idle.dt = set_combine(sets.me.idle.tp, sets.me.idle.damagetaken, {
        -- Add any additional DT-specific overrides here
        feet = "Skulker's poulaines +2",
        right_ring = "Murky Ring",
    })

    -- TH Mode - Combines base idle with treasure hunter gear
    -- Original
    -- sets.me.idle.th = set_combine(sets.me.idle.tp, sets.me.idle.treasurehunter, {
    --     -- Add any additional TH-specific overrides here
    --     --main = "Naegling",
    --     sub="Sandung",
    --     --hands = "Plunderer's armlets +1",
    --     feet = "Skulker's poulaines +2",
    --     right_ring = "Murky Ring",
    -- })
    sets.me.idle.th = set_combine(sets.me.idle.tp, sets.me.idle.treasurehunter, {
        main="Tauret",
        sub={ name="Shijo", augments={'DEX+15','"Dual Wield"+5','"Triple Atk."+2',}},
        --sub = "Sandung",
        ammo="Aurgelmir Orb",
        head="Nyame Helm",
        body="Malignance Tabard",   -- was Nyame Mail. DT-9% identical to Nyame; gains Haste+1%, Store TP+11, Acc+10, DEX+25, PDL+6% (2026-05-31)
        hands="Malignance Gloves",  -- was Nyame Gauntlets. DT-5% (was -7%, costs 2% DT); gains Haste+1%, Store TP+12, Acc+10, DEX+14, PDL+4%. Generic DT now -36% (still under -50% cap) (2026-05-31)
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck={ name="Asn. Gorget +1", augments={'Path: A',}},
        waist="Patentia Sash",
        left_ear="Mache Earring +1",
        right_ear="Sherida Earring",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
    })

    -- TH2 Mode - High Treasure Hunter without tanking stats. Separate from `th` (DT-prioritized for Lilith).
    -- Built on the th set, overlaying the high-TH pieces that keep real stats (BGWiki-verified):
    --   Plun. Armlets +3 (hands) TH+4 | Skulk. Poulaines +2 (feet) TH+4 | Sandung (sub) TH+1 = TH+9
    -- Head intentionally LEFT as th's Nyame Helm: Wh. Rarab Cap +1 is only TH+1 for a big stat loss.
    sets.me.idle.th2 = set_combine(sets.me.idle.th, {
        sub  = "Sandung",                 -- TH+1 (replaces Shijo; note: drops Dual Wield/Triple Atk)
        hands = "Plun. Armlets +3",       -- TH+4
        feet = "Skulk. Poulaines +2",     -- TH+4
        left_ring  = "Chirich Ring +1",   -- keep one Chirich
        right_ring = "Shneddick Ring",    -- movement speed +18% (drops the 2nd Chirich for mobility)
    })

    -- MOVE Mode - Combines base idle with movement gear
    sets.me.idle.move = set_combine(sets.me.idle.tp, sets.me.idle.movement, {
        -- Add any additional movement-specific overrides here
    })

    -- SKILL Mode - Marksmanship skill-up. Temachtiani set boosts skill-up rate;
    -- Musketoon (gun) in the ranged slot + Bronze Bullet ammo so you can /ra to gain skill.
    -- This is a standalone set (not built on the TP set) so nothing overrides the skill-up gear.
    -- Toggle with Alt-F10 (or cycle via F9); stays on because choose_set re-applies the
    -- current idleMode after every shot/aftercast.
    sets.me.idle.skill = {
        main  = "Tauret",
        sub   = { name="Shijo", augments={'DEX+15','"Dual Wield"+5','"Triple Atk."+2',}},
        range = "Flagellant's crossbow",
        ammo  = "Blind Bolt",
        head  = "Guide Beret",
        body  = "Malignance Tabard",
        hands = "Pill. Armlets +3",
        legs  = "Temachtiani Pants",
        feet  = "Temachtiani Boots",
        neck  = "Null Loop",
        waist = "Null Belt",
        left_ear  = "Skulk. Earring +1",
        right_ear = "Skulker's Earring",
        left_ring  = "Shneddick Ring",
        right_ring = "Jubilee Ring",
        back  = "Null Shawl",
    }

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

    -- Engaged TH2 Set - mirror idle.th2 so the high-TH + mobility gear persists in melee.
    sets.me.engaged.th2 = sets.me.idle.th2

    -- Engaged MOVE Set
    sets.me.engaged.move = set_combine(sets.me.idle.movement, {
        -- Add engaged movement gear here if different
    })

    -- Engaged SKILL Set - mirror idle.skill so the skill-up gear persists even if you get engaged.
    sets.me.engaged.skill = sets.me.idle.skill

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
        ammo = "Yetshila +1",
        head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
        neck = "Fotia Gorget",
        feet={ name="Adhemar gamashes +1", augments={'STR+12','DEX+12','Attack+20',}},
        waist = "Fotia Belt",
    })
    sets.me["Savage Blade"] = set_combine(sets.me.weaponskill_base, {
        ammo = "Seeth. Bomblet +1",
        head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
        neck = "Fotia Gorget",
        feet={ name="Adhemar gamashes +1", augments={'STR+12','DEX+12','Attack+20',}},
        waist = "Fotia Belt",
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
    local set
    if player.status == 'Engaged' then
        set = sets.me.engaged[idleModes.current]
    else
        set = sets.me.idle[idleModes.current]
    end
    equip(set)
    -- Work around GearSwap's duplicate-ring quirk: when a set requests the SAME ring
    -- in both slots, GearSwap won't seat the 2nd copy if an identical one is already
    -- worn (e.g. after a WS that left Mummu Ring in the right slot + Chirich in the
    -- left). Clearing both ring slots then re-applying forces both copies to seat.
    if set and set.left_ring and set.right_ring and set.left_ring == set.right_ring then
        equip({left_ring = empty, right_ring = empty})
        equip({left_ring = set.left_ring, right_ring = set.right_ring})
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
    elseif command == 'toggle th2mode' then
        idleModes:set('th2')
        add_to_chat(123, 'TH2 Mode: ON (max TH + mobility)')
        choose_set()
    elseif command == 'toggle thmode' then
        idleModes:set('th')
        add_to_chat(123, 'TH Mode: ON')
        choose_set()
    elseif command == 'toggle movemode' then
        idleModes:set('move')
        add_to_chat(123, 'MOVE Mode: ON')
        choose_set()
    elseif command == 'toggle skillmode' then
        idleModes:set('skill')
        add_to_chat(123, 'SKILL Mode: ON (Marksmanship training)')
        choose_set()
    end
end
