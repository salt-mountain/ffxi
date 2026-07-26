-------------------------------------------------------------------------------------------------------------------
-- Cevapi_WAR.lua — Warrior (sword + board: Naegling / Blurred Shield +1)
--
-- Framework: Mote-Include (already in libs/), same structure as Cevapi_GEO.lua / Cevapi_PUP.lua.
--   get_sets() -> job_setup() -> user_setup() -> init_gear_sets() -> hooks.
--   Mote auto-switches engaged<->idle on status change and handles WS/JA precast, so there is no
--   hand-written precast/aftercast/idle logic (that was the source of breakage in the old file).
--
-- Gear carried over from the previous hand-written file (already verified by use). Sets are now
-- organized into modes; Acc/PDT variants are scaffolded from owned gear with TODO markers where a
-- dedicated piece would improve them.
--
-- Keybinds (set in user_setup, cleared in user_unload):
--   F9        cycle OffenseMode   (Normal / Acc)      — TP accuracy bias
--   F10       cycle HybridMode    (Normal / PDT)      — engaged damage-taken stance
--   F11       cycle IdleMode      (Normal / PDT)      — idle damage-taken stance
--   Ctrl+F11  toggle Kiting       — movement-speed overlay (Shneddick Ring +18%)
--   Win+F11   force re-equip      (gs c update)
-------------------------------------------------------------------------------------------------------------------


-- Mote auto-runs init_include() on include; it then calls job_setup, user_setup, init_gear_sets.
function get_sets()
    mote_include_version = 2
    include('Mote-Include.lua')
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific setup (runs before user_setup).
-------------------------------------------------------------------------------------------------------------------
function job_setup()
    -- Buffs Mote will track on state.Buff[...] (available for buff-aware set logic later).
    state.Buff['Berserk']     = buffactive['Berserk']     or false
    state.Buff['Aggressor']   = buffactive['Aggressor']   or false
    state.Buff['Warcry']      = buffactive['Warcry']      or false
    state.Buff['Blood Rage']  = buffactive['Blood Rage']  or false
    state.Buff['Retaliation'] = buffactive['Retaliation'] or false
end


-------------------------------------------------------------------------------------------------------------------
-- User-specific setup (state vars, keybinds, macros).
-------------------------------------------------------------------------------------------------------------------
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'PDT')
    state.IdleMode:options('Normal', 'PDT')
    state.WeaponskillMode:options('Normal', 'Acc')

    -- Macro setup — adjust book/sheet to your in-game WAR macros.
    set_macro_page(1, 2)    -- Sheet 1, Book 2 (WAR macro book)

    -- Keybinds
    send_command('bind F9 gs c cycle OffenseMode')
    send_command('bind F10 gs c cycle HybridMode')
    send_command('bind F11 gs c cycle IdleMode')
    send_command('bind ^F11 gs c toggle Kiting')   -- Ctrl+F11: movement overlay (Mote handles state.Kiting)
    send_command('bind @F11 gs c update')          -- Win+F11: force re-equip
end


-- Called from Mote's file_unload — clean up our binds.
function user_unload()
    send_command('unbind F9; unbind F10; unbind F11; unbind ^F11; unbind @F11')
end


-------------------------------------------------------------------------------------------------------------------
-- Gear sets.
-------------------------------------------------------------------------------------------------------------------
function init_gear_sets()
    -- Cichol's Mantle (WAR JSE) with your TP/DA augments. Reused across engaged/WS/JA.
    local Cichol_TP = { name="Cichol's Mantle", augments={
        'DEX+20', 'Accuracy+20 Attack+20', '"Dbl.Atk."+10',
    }}

    -- =============================================================================
    -- PRECAST: Fast Cast & Weapon Skills
    -- =============================================================================
    sets.precast = {}

    -- Fast Cast (only relevant if you cast anything, e.g. /RDM /SAM utility). Harmless empty.
    sets.precast.FC = {}

    -- Job Abilities — each overlays the engaged set with its JA-enhancing piece.
    sets.precast.JA = {}
    sets.precast.JA['Berserk']   = { body = "Pumm. Lorica +2" }   -- Enhances Berserk
    sets.precast.JA['Aggressor'] = { body = "Agoge Lorica +1" }   -- Enhances Aggressor
    sets.precast.JA['Warcry']    = { head = "Agoge Mask +3"   }   -- Enhances Warcry
    sets.precast.JA['Tomahawk']  = { ammo = "Thr. Tomahawk"   }   -- throwing ammo for the JA

    -- Weapon Skills — base set + per-WS overrides (Savage Blade / Requiescat from your gear).
    sets.precast.WS = {
        main  = "Naegling",
        sub   = "Blurred Shield +1",
        ammo  = "Coiste Bodhar",
        head  = "Agoge Mask +3",
        body  = "Pumm. Lorica +2",
        hands = "Sulev. Gauntlets +2",
        legs  = "Sulev. Cuisses +2",
        feet  = "Sulev. Leggings +2",
        neck  = { name="War. Beads +1", augments={'Path: A',}},
        waist = "Sailfi Belt +1",
        left_ear  = "Thrud Earring",
        right_ear = { name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
        left_ring  = "Rajas Ring",
        right_ring = "Flamma Ring",
        back  = Cichol_TP,
    }

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        ammo = { name="Seeth. Bomblet +1", augments={'Path: A',}},
    })

    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {
        right_ring = "Petrov Ring",
    })

    -- =============================================================================
    -- MIDCAST (minimal — WAR rarely casts)
    -- =============================================================================
    sets.midcast = {}
    sets.midcast.Cure = {}   -- placeholder; fill if you use cure items/spells

    -- =============================================================================
    -- IDLE — standing around. Leans a bit defensive; PDT variant maxes damage taken.
    -- =============================================================================
    sets.idle = {
        main  = "Naegling",
        sub   = "Blurred Shield +1",
        ammo  = "Coiste Bodhar",
        head  = "Flam. Zucchetto +2",
        body  = "Flamma Korazin +2",
        hands = "Sulev. Gauntlets +2",
        legs  = "Pumm. Cuisses +2",
        feet  = "Flam. Gambieras +2",
        neck  = { name="War. Beads +1", augments={'Path: A',}},
        waist = "Sailfi Belt +1",
        left_ear  = "Brutal Earring",
        right_ear = "Mache Earring +1",
        left_ring  = "Chirich Ring +1",
        right_ring = "Chirich Ring +1",
        back  = Cichol_TP,
    }

    -- PDT idle (IdleMode = PDT). TODO: slot owned DT gear here (e.g. Nyame set pieces) for a
    -- real damage-taken shell; currently clones idle so the mode is wired and never equips nil.
    sets.idle.PDT = set_combine(sets.idle, {
        -- TODO: head/body/hands/legs/feet DT pieces
    })

    -- =============================================================================
    -- ENGAGED (TP) — your melee stance. OffenseMode Acc + HybridMode PDT layer on top.
    -- =============================================================================
    sets.engaged = {
        main  = "Naegling",
        sub   = "Blurred Shield +1",
        ammo  = "Coiste Bodhar",
        head  = "Flam. Zucchetto +2",
        body  = "Flamma Korazin +2",
        hands = "Sulev. Gauntlets +2",
        legs  = "Pumm. Cuisses +2",
        feet  = "Flam. Gambieras +2",
        neck  = { name="War. Beads +1", augments={'Path: A',}},
        waist = "Sailfi Belt +1",
        left_ear  = "Brutal Earring",
        right_ear = "Mache Earring +1",
        left_ring  = "Chirich Ring +1",
        right_ring = "Chirich Ring +1",
        back  = Cichol_TP,
    }

    -- Accuracy variant (OffenseMode = Acc). TODO: swap in owned Acc pieces where you fall short;
    -- currently mirrors the TP set (Mache Earring +1 already gives some Acc).
    sets.engaged.Acc = set_combine(sets.engaged, {
        -- TODO: Acc rings / body / legs when accuracy is short
    })

    -- PDT variant (HybridMode = PDT). TODO: slot owned DT gear for a survivability stance.
    sets.engaged.PDT = set_combine(sets.engaged, {
        -- TODO: DT pieces (Nyame, etc.)
    })
    sets.engaged.Acc.PDT = sets.engaged.PDT

    -- =============================================================================
    -- KITING — movement overlay. Toggle Ctrl+F11 (gs c toggle Kiting). Mote applies
    -- sets.Kiting on top of whatever set is active and holds it until toggled off.
    -- =============================================================================
    sets.Kiting = {
        right_ring = "Shneddick Ring",   -- Movement speed +18% (All Jobs). Drops a Chirich while moving.
    }
end
