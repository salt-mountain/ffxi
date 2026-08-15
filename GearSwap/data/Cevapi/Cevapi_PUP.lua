-------------------------------------------------------------------------------------------------------------------
-- Cevapi_PUP.lua — Puppetmaster (sub flexible: /DNC, /WAR, /NIN)
--
-- Framework: Mote-Include (already in libs/), same structure as Cevapi_GEO.lua.
--   get_sets() → job_setup() → user_setup() → init_gear_sets() → hooks.
--
-- STATUS (built 2026-06-22): This is an INTERIM file. Your inventory at build time showed a
--   freshly-started PUP — you own the Animator + Xhifhut Head and starter H2H weapons, but
--   little dedicated PUP master/pet gear. So:
--     • MASTER sets are built on shared DD/DT gear you already own (Nyame set, Malignance pieces,
--       Brutal/Moonshade/Mache earrings, Chirich Ring +1 x2, Fotia Belt, Mecisto. Mantle).
--     • PET (automaton) sets are SCAFFOLDED with owned gear + clearly marked TODO slots. They are
--       NOT optimized for a specific frame yet (per your "just placeholders" choice). Tune them
--       once you pick a frame (Valoredge melee / Sharpshot ranged / Stormwaker mage).
--   Every TODO is a real PUP BiS-ish target to look up on BGWiki later. No stats are asserted here
--   that weren't verifiable — follow the same rule we used for GEO: WebFetch BGWiki before trusting
--   any PUP-gear stat.
--
-- SLOTTING RULES specific to PUP (important, don't "fix" these):
--   • H2H weapons occupy main; the sub slot stays empty for H2H. Do NOT put a shield/grip in sub
--     while using Hand-to-Hand — GearSwap will fight it.
--   • The Animator (pet command device) lives in the RANGE slot. Keep it equipped in every set
--     so automaton commands (Deploy/Retrieve/Maneuvers) work. ammo slot is left free.
--
-- Keybinds (set in user_setup, cleared in user_unload):
--   F9   cycle PlayMode       — switches between 'TP' (normal TP/idle sets) and 'Travel'
--                               (sets.Travel: Shneddick Ring move speed +18% + Warp Ring escape).
--                               Holds while idle and while engaged.
--   ^F9  cycle OffenseMode    (Normal / Acc)   — moved off plain F9 to make room for Travel
--   F10  cycle HybridMode     (Normal / PDT)   — master damage-taken stance
--   F11  cycle IdleMode       (Normal / PDT)
--   F12  cycle PetMode        (Normal / Acc)   — automaton offense bias (placeholder use)
--   ^F11 toggle Kiting        — overlays sets.Kiting (Shneddick Ring, move speed +18%)
--   ^F12 gs c update          (force re-equip)
--
-- //gs c commands:
--   gs c cycle PlayMode     — same as F9 (TP <-> Travel)
--   gs c lockstyle          — re-apply lockstyle set 20 (auto-applied on file load)
--   gs c update      — re-equip current sets
-------------------------------------------------------------------------------------------------------------------


-- Mote auto-runs init_include() on include; it then calls job_setup, user_setup, init_gear_sets in that order.
function get_sets()
    mote_include_version = 2
    include('Mote-Include.lua')
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific setup (runs before user_setup).
-------------------------------------------------------------------------------------------------------------------
function job_setup()
    -- Register buffs Mote should auto-track on state.Buff[...]
    state.Buff['Overdrive']      = buffactive['Overdrive']      or false
    state.Buff['Activate']       = buffactive['Activate']       or false

    -- PUP automaton awareness: Mote's pet_change handler swaps idle → sets.idle.Pet when the
    -- automaton is out (same mechanic GEO used for the luopan). No extra hook needed for that.
end


-------------------------------------------------------------------------------------------------------------------
-- User-specific setup (state vars, keybinds, macros).
-------------------------------------------------------------------------------------------------------------------
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'PDT')
    state.IdleMode:options('Normal', 'PDT')
    state.WeaponskillMode:options('Normal', 'Acc')

    -- Automaton offense bias. Placeholder mode — pet sets currently don't branch on it, but it's
    -- here so you can build sets.engaged.Pet.Acc / sets.idle.Pet.Acc later without re-plumbing.
    state.PetMode = M('Normal', 'Acc')

    -- PlayMode (F9) — a two-position switch between your TP set and Travel:
    --   'TP'     → normal TP / idle sets, untouched
    --   'Travel' → sets.Travel over the top (Shneddick Ring move speed + Warp Ring escape)
    -- F9 cycles TP → Travel → TP. Applied in customize_idle_set / customize_melee_set below, so
    -- it holds whether you're standing or engaged.
    state.PlayMode = M{['description'] = 'Play Mode', 'TP', 'Travel'}

    -- Macro setup — adjust book/sheet to your in-game PUP macros.
    set_macro_page(1, 6)    -- Sheet 1, Book 6 (CHANGE to your PUP macro book)

    -- Lockstyle. The `wait 3` matters: on a job change the game rejects /lockstyleset for a few
    -- seconds while the job swap settles, and an early command silently does nothing. If it ever
    -- misses (zoning, heavy lag), `gs c lockstyle` re-fires it.
    send_command('wait 3; input /lockstyleset 20')

    -- Keybinds
    send_command('bind F9 gs c cycle PlayMode')      -- switch TP set <-> Travel (movement + Warp Ring)
    send_command('bind ^F9 gs c cycle OffenseMode')  -- OffenseMode moved here off plain F9
    send_command('bind F10 gs c cycle HybridMode')
    send_command('bind F11 gs c cycle IdleMode')
    send_command('bind F12 gs c cycle PetMode')
    send_command('bind ^F11 gs c toggle Kiting')   -- Ctrl+F11: movement overlay (Mote handles state.Kiting natively)
    send_command('bind ^F12 gs c update')
end


-- Called from Mote's file_unload — clean up our binds.
function user_unload()
    send_command('unbind F9; unbind ^F9; unbind F10; unbind F11; unbind F12; unbind ^F11; unbind ^F12')
end


-------------------------------------------------------------------------------------------------------------------
-- Gear sets.
-------------------------------------------------------------------------------------------------------------------
function init_gear_sets()
    -- Mecisto. Mantle (CP cape) — currently UNUSED (idle wears Visucius's Mantle like the TP set).
    -- Kept here so a future CP toggle (see the GEO file's `gs c toggle CP`) can just reference it.
    local Mecisto_CP = { name="Mecisto. Mantle", augments={
        'Cap. Point+30%', 'HP+25', 'Rng.Acc.+1', 'DEF+8',
    }}

    -- Visucius's Mantle (PUP JSE cape) — acquired; TP augment path (STR/Acc/Att/DA).
    -- From gs export 2026-08-15. This replaces Mecisto_CP in the TP set.
    local Visucius_TP = { name="Visucius's Mantle", augments={
        'STR+20', 'Accuracy+20 Attack+20', 'STR+10', '"Dbl.Atk."+10',
    }}

    -- =============================================================================
    -- PRECAST: Job Abilities & Weapon Skills
    -- =============================================================================
    sets.precast = {}
    sets.precast.JA = {}

    -- Maneuvers — the core PUP JA. PUP maneuver-up gear (Karagoz/Pitre line, Foire pieces) goes
    -- here once owned; it raises pet stats per maneuver and reduces maneuver recast/overload risk.
    sets.precast.JA['Maneuver'] = {
        -- TODO: PUP body/hands with "Maneuver" augments (e.g. Karagoz Cappa, Foire pieces) — verify BGWiki
    }

    -- Pet-summon / control JAs. Animator MUST stay in range for these to fire.
    sets.precast.JA['Activate']        = { range = "Animator P II +1"}   -- TODO: Cirque/Sde gear that enhances Activate
    sets.precast.JA['Deploy']          = { range = "Animator P II +1"}
    sets.precast.JA['Retrieve']        = { range = "Animator P II +1"}
    sets.precast.JA['Deactivate']      = { range = "Animator P II +1"}
    sets.precast.JA['Repair']          = { range = "Animator P II +1"}   -- TODO: Repair-potency feet/legs
    sets.precast.JA['Ventriloquy']     = { range = "Animator P II +1"}
    sets.precast.JA['Role Reversal']   = { range = "Animator P II +1"}
    sets.precast.JA['Tactical Switch'] = { range = "Animator P II +1"}
    sets.precast.JA['Cooldown']        = { range = "Animator P II +1"}
    sets.precast.JA['Overdrive']       = { range = "Animator P II +1"}   -- SP1
    sets.precast.JA['Heady Artifice']  = { range = "Animator P II +1"}   -- SP2 (requires the automaton out)

    -- Fast Cast (only relevant if you /WHM /RDM etc.; harmless otherwise)
    sets.precast.FC = {
        -- TODO: PUP/master Fast Cast pieces if you sub a caster job
    }

    -- =============================================================================
    -- WEAPON SKILLS (all Hand-to-Hand). Modifiers BGWiki-verified 2026-06-22:
    --   Victory Smite   80% STR, 4 hits, crit% scales w/ TP   (needs Verethragna/Revenant Fists)
    --   Stringing Pummel 32% STR/32% VIT, 6 hits              (PUP exclusive)
    --   Shijin Spiral   73-85% DEX, 5 hits                    (lv93)
    --   Asuran Fists    15% STR/15% VIT, 8 hits               (Acc-hungry, low mod)
    --   Dragon Kick     50% STR/50% VIT, 2 hits
    --   Howling Fist    50% VIT/20% STR, 2 hits
    --   Spinning Attack 100% STR, 1 hit
    -- Base set is the generic STR/multi-attack stack on owned gear; per-WS sets override below.
    -- TODO upgrades to look up when acquired: STR/WSD body+hands (Mpaca's / Herculean), DEX legs
    -- for Shijin Spiral, Caro Necklace (WS neck), Epaminondas's/Ilabrat ring (WSD), Gere Ring (DA).
    -- =============================================================================
    sets.precast.WS = {
        ammo  = "Amar Cluster",
        head  = "Nyame Helm",
        body  = "Nyame Mail",
        hands = "Nyame Gauntlets",
        legs  = "Nyame Flanchard",
        feet  = "Nyame Sollerets",
        neck  = "Fotia Gorget",   -- +fTP to WS
        waist = "Fotia Belt",
        left_ear  = { name="Moonshade Earring", augments={'TP Bonus +250'} },
        right_ear = "Brutal Earring",
        left_ring  = "Chirich Ring +1",
        right_ring = "Chirich Ring +1",
        back  = Mecisto_CP,
    }

    -- Multi-hit WS (Asuran Fists 8, Stringing Pummel 6, Shijin Spiral 5, Victory Smite 4): each
    -- hit must land, so accuracy matters more than raw WSD.
    -- NOTE: deliberately does NOT swap in Mache Earring +1 here. You own only one Mache +1, and it
    -- lives in engaged's LEFT ear. Putting it in the WS RIGHT ear forces GearSwap to relocate a
    -- single-copy item between slots on aftercast, which it can't do — leaving you stuck on Moonshade
    -- after a WS instead of returning to Mache. Keeping Mache out of WS means it's equipped fresh
    -- into engaged-left every time, with no slot-move. (Same class of bug as the THF Chirich rings.)
    sets.precast.WS.MultiHit = set_combine(sets.precast.WS, {
        -- TODO: if you get a SECOND accuracy earring (not Mache/Moonshade), put it in right_ear here.
    })

    -- STR-modifier WS
    sets.precast.WS['Victory Smite']   = sets.precast.WS.MultiHit   -- 4 hits, crit scales w/ TP
    sets.precast.WS['Spinning Attack'] = sets.precast.WS            -- 1 hit, 100% STR → raw WSD
    sets.precast.WS['Raging Fists']    = sets.precast.WS.MultiHit   -- 5 hits, STR
    sets.precast.WS['Combo']           = sets.precast.WS.MultiHit   -- 3 hits, STR

    -- STR/VIT-modifier WS
    sets.precast.WS['Stringing Pummel'] = sets.precast.WS.MultiHit  -- 6 hits
    sets.precast.WS['Dragon Kick']      = sets.precast.WS           -- 2 hits
    sets.precast.WS['Asuran Fists']     = sets.precast.WS.MultiHit  -- 8 hits, very Acc-hungry
    sets.precast.WS['Howling Fist']     = sets.precast.WS           -- 2 hits, VIT-lean
    sets.precast.WS['Final Heaven']     = sets.precast.WS           -- 1 hit, VIT (needs relic H2H)

    -- DEX-modifier WS
    sets.precast.WS['Shijin Spiral'] = sets.precast.WS.MultiHit     -- 5 hits, 73-85% DEX
        -- TODO: DEX-WSD legs (e.g. Lustratio Subligar +1 — verify PUP) when meleeing DEX builds

    -- =============================================================================
    -- MASTER MELEE (TP) — your character's auto-attack stance
    -- Rebuilt from gs export 2026-08-15 — this is exactly what you're wearing in game.
    -- Full Malignance body set (Haste/STP/Acc/DT), Moonbow Belt +1, Visucius's Mantle.
    -- Solo/no-automaton melee set, not pet-focused. Tune from here.
    -- =============================================================================
    -- Held in a local so sets.idle can reuse the exact same gear without aliasing the table.
    -- (`sets.idle = sets.engaged` would make them ONE table — the later sets.idle.PDT assignment
    -- would then silently overwrite sets.engaged.PDT. set_combine copies, so they stay separate.)
    local TP_gear = {
        main  = "Karambit",          -- has — starter H2H. TODO: real H2H (Kenkonken / Verethragna / Godhands)
        range = "Animator P II +1",  -- pet command device (keep equipped so automaton commands work)
        -- ammo: with the Animator in range, only PUP ammo (Automaton Oil / Repair Kit) is allowed here
        head  = "Malignance Chapeau", -- has (acquired 2026-06-26) — Haste+6, STP+8, Acc+50, DEX+40, PDL+3%, DT-6%
        body  = "Malignance Tabard", -- has — Haste+4, STP+11, DT-9%
        hands = "Malignance Gloves", -- has — Haste+4, STP+12, DT-5%
        legs  = "Malignance Tights", -- has (acquired 2026-07-21) — Haste+9, STP+10, Acc+50, PDL+5%, DT-7%
        feet  = "Malignance Boots",  -- has (acquired 2026-07-26) — Haste+3, STP+9, Acc+50, PDL+2%, DT-4%
        neck  = "Null Loop",         -- placeholder; TODO Acc/STP neck
        waist = "Moonbow Belt +1",   -- has (export 2026-08-15) — replaces the Null Belt placeholder
        left_ear  = "Mache Earring +1",
        right_ear = "Brutal Earring",
        left_ring  = "Chirich Ring +1", -- has
        right_ring = "Chirich Ring +1", -- has
        back  = Visucius_TP,         -- has (export 2026-08-15) — PUP JSE cape, STR/Acc/Att/DA augments
    }

    sets.engaged = set_combine(TP_gear, {})

    sets.engaged.Acc = set_combine(sets.engaged, {
        -- Already accuracy-leaning (Mache Earring +1). Add more Acc here if you're still missing.
    })

    -- PDT melee (HybridMode = PDT): trade offense for the Nyame DT shell.
    sets.engaged.PDT = set_combine(sets.engaged, {
        head  = "Nyame Helm",        -- DT-7%
        body  = "Nyame Mail",        -- DT-9% (over Malignance Tabard's -9%; Nyame for the full set DT)
        hands = "Nyame Gauntlets",   -- DT-7% (over Malignance Gloves' -5%)
        legs  = "Nyame Flanchard",   -- DT-8%
        feet  = "Nyame Sollerets",   -- DT-7%
    })
    sets.engaged.Acc.PDT = sets.engaged.PDT

    -- =============================================================================
    -- IDLE (master, no pet or pet-agnostic)
    -- Same gear as the TP set (your choice 2026-08-15). Malignance is already DT-heavy
    -- (-9/-7/-6/-5/-4 across the set), so idling in it keeps real mitigation while your gear stays
    -- consistent whether you're standing, running, or fighting. This is also why "my belt and cape
    -- aren't equipping" — the old idle set had the Null Belt / Mecisto placeholders and Mote uses
    -- idle whenever you're NOT engaged.
    --   • Nyame DT shell now lives only in sets.idle.PDT — cycle to it with F11 (IdleMode).
    --   • Mecisto. Mantle (CP cape) is no longer worn while idle. If you want CP banking back,
    --     re-add a CP toggle like the GEO file's (gs c toggle CP → sets.CP overlay).
    -- =============================================================================
    sets.idle = set_combine(TP_gear, {})

    -- PDT idle — full Nyame DT shell. F11 cycles IdleMode Normal → PDT.
    sets.idle.PDT = set_combine(sets.idle, {
        head  = "Nyame Helm",        -- DT-7%
        body  = "Nyame Mail",        -- DT-9%
        hands = "Nyame Gauntlets",   -- DT-7%
        legs  = "Nyame Flanchard",   -- DT-8%
        feet  = "Nyame Sollerets",   -- DT-7%
    })

    -- =============================================================================
    -- PET (AUTOMATON) SETS — PLACEHOLDERS (per "just placeholders" choice)
    --
    -- These auto-apply when the automaton is out (Mote swaps idle → sets.idle.Pet, and engaged
    -- → sets.engaged.Pet if defined). Right now they just inherit master gear + keep Animator in
    -- range. Tune for your chosen frame later:
    --   • Valoredge (melee/tank): stack Pet: Acc / Atk / DT / Haste, Regen
    --   • Sharpshot (ranged):     stack Pet: Rng Acc / Rng Atk
    --   • Stormwaker (mage):      stack Pet: Mag Acc / Mag Atk / MAB
    -- PUP pet gear to look up on BGWiki when ready: Karagoz set, Foire set, Cirque set, Mpaca's
    -- set, Sapient Pebble, Empath Necklace, Builder's/Marsois pieces, Buffoon's Collar.
    -- =============================================================================
    sets.idle.Pet = set_combine(sets.idle, {
        -- TODO: Pet: Regen / Pet: DT pieces (e.g. Foire body, Cirque feet) — verify BGWiki
    })

    sets.engaged.Pet = set_combine(sets.engaged, {
        -- TODO: Pet: Accuracy / Attack / Haste pieces for an active automaton — verify BGWiki
    })
    sets.engaged.Pet.Acc = sets.engaged.Pet

    -- Pet-DT idle (when the automaton is taking damage in tough content)
    sets.idle.Pet.PDT = set_combine(sets.idle.Pet, {
        -- TODO: Pet: Damage Taken pieces
    })

    -- =============================================================================
    -- KITING — movement overlay. Toggle with Ctrl+F11 (gs c toggle Kiting). Mote applies
    -- sets.Kiting on top of whatever set is active when state.Kiting is on, and keeps it until
    -- toggled off. Same setup as the GEO file.
    -- =============================================================================
    sets.Kiting = {
        right_ring = "Shneddick Ring",   -- Movement speed +18% (All Jobs). ring2 so it won't clash
                                          -- with a TP/WS ring1; both engaged rings are Chirich +1,
                                          -- so this overlay drops one Chirich while moving.
    }

    -- =============================================================================
    -- TRAVEL — the 'Travel' half of PlayMode (F9). Applied over idle AND engaged via
    -- customize_idle_set / customize_melee_set. Drops both Chirich Ring +1 for the run.
    -- This is a superset of sets.Kiting (which is movement only); Kiting on ^F11 still works,
    -- and if both are active, Travel wins because customize_* runs after Mote's apply_kiting.
    -- =============================================================================
    sets.Travel = {
        left_ring  = "Shneddick Ring",   -- Movement speed +18% (All Jobs), Resist Petrify/Bind/Gravity +15
        right_ring = "Warp Ring",        -- no passive stats; the Warp enchantment is the escape button
    }
end


-------------------------------------------------------------------------------------------------------------------
-- Hook functions for job-specific events.
-------------------------------------------------------------------------------------------------------------------

-- `gs c lockstyle` — manually re-apply lockstyle set 20 if the automatic one on load was
-- rejected (job change still settling, zoning, lag).
function job_self_command(cmdParams, eventArgs)
    if (cmdParams[1] or ''):lower() == 'lockstyle' then
        send_command('input /lockstyleset 20')
        add_to_chat(122, '[PUP] Re-applying lockstyle set 20.')
        eventArgs.handled = true
    end
end


-- Keep H2H sub slot empty (H2H occupies main+sub). Prevents a stray grip/shield from a shared
-- set leaking into PUP and breaking the H2H equip.
function job_post_precast(spell, action, spellMap, eventArgs)
    -- placeholder hook kept for parity / future use
end

-- Optional: if you later add pet-mode-aware swapping, branch here on pet.isvalid / pet.status.
function job_handle_equipping_gear(playerStatus, eventArgs)
    -- placeholder
end


-- Travel Mode overlay (F9). Mote calls these at the end of get_idle_set / get_melee_set, so the
-- rings go on over whatever idle/TP set was resolved, and come straight back off when toggled.
function customize_idle_set(idleSet)
    if state.PlayMode.value == 'Travel' then
        idleSet = set_combine(idleSet, sets.Travel)
    end
    return idleSet
end


function customize_melee_set(meleeSet)
    if state.PlayMode.value == 'Travel' then
        meleeSet = set_combine(meleeSet, sets.Travel)
    end
    return meleeSet
end
