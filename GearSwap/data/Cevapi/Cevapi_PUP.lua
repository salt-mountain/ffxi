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
--   F9   cycle OffenseMode    (Normal / Acc)
--   F10  cycle HybridMode     (Normal / PDT)   — master damage-taken stance
--   F11  cycle IdleMode       (Normal / PDT)
--   F12  cycle PetMode        (Normal / Acc)   — automaton offense bias (placeholder use)
--   ^F11 toggle Kiting        — overlays sets.Kiting (Shneddick Ring, move speed +18%)
--   ^F12 gs c update          (force re-equip)
--
-- //gs c commands:
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

    -- Macro setup — adjust book/sheet to your in-game PUP macros.
    set_macro_page(1, 6)    -- Sheet 1, Book 6 (CHANGE to your PUP macro book)

    -- Keybinds
    send_command('bind F9 gs c cycle OffenseMode')
    send_command('bind F10 gs c cycle HybridMode')
    send_command('bind F11 gs c cycle IdleMode')
    send_command('bind F12 gs c cycle PetMode')
    send_command('bind ^F11 gs c toggle Kiting')   -- Ctrl+F11: movement overlay (Mote handles state.Kiting natively)
    send_command('bind ^F12 gs c update')
end


-- Called from Mote's file_unload — clean up our binds.
function user_unload()
    send_command('unbind F9; unbind F10; unbind F11; unbind F12; unbind ^F11; unbind ^F12')
end


-------------------------------------------------------------------------------------------------------------------
-- Gear sets.
-------------------------------------------------------------------------------------------------------------------
function init_gear_sets()
    -- Mecisto. Mantle (CP cape) — from your current working TP export. TODO: Visucius's Mantle (PUP JSE).
    local Mecisto_CP = { name="Mecisto. Mantle", augments={
        'Cap. Point+30%', 'HP+25', 'Rng.Acc.+1', 'DEF+8',
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
    -- This is your CURRENT WORKING TP SET (gs export 2026-06-22). It's a solo/no-automaton melee
    -- set, not pet-focused — exactly what you've been playing. Tune from here.
    --   Note: no Animator in range here because you're playing solo. When you start running the
    --   automaton, swap range → "Animator" (or build sets.engaged.Pet) so pet commands work.
    -- =============================================================================
    sets.engaged = {
        main  = "Karambit",          -- has — starter H2H. TODO: real H2H (Kenkonken / Verethragna / Godhands)
        range = "Animator P II +1",  -- pet command device (keep equipped so automaton commands work)
        -- ammo: with the Animator in range, only PUP ammo (Automaton Oil / Repair Kit) is allowed here
        head  = "Malignance Chapeau", -- has (acquired 2026-06-26) — Haste+6, STP+8, Acc+50, DEX+40, PDL+3%, DT-6%
        body  = "Malignance Tabard", -- has — Haste+4, STP+11, DT-9%
        hands = "Malignance Gloves", -- has — Haste+4, STP+12, DT-5%
        legs  = "Malignance Tights", -- has (acquired 2026-07-21) — Haste+9, STP+10, Acc+50, PDL+5%, DT-7%
        feet  = "Malignance Boots",  -- has (acquired 2026-07-26) — Haste+3, STP+9, Acc+50, PDL+2%, DT-4%
        neck  = "Null Loop",         -- placeholder; TODO Acc/STP neck
        waist = "Null Belt",         -- placeholder; TODO DA/STP waist
        left_ear  = "Mache Earring +1",
        right_ear = "Brutal Earring",
        left_ring  = "Chirich Ring +1", -- has
        right_ring = "Chirich Ring +1", -- has
        back  = Mecisto_CP,          -- TODO: Visucius's Mantle (PUP JSE)
    }

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
    -- =============================================================================
    sets.idle = {
        main  = "Karambit",
        range = "Animator P II +1",  -- pet command device (keep equipped)
        -- ammo: with the Animator in range, only PUP ammo (Automaton Oil / Repair Kit) is allowed here
        head  = "Nyame Helm",
        body  = "Malignance Tabard",
        hands = "Nyame Gauntlets",   -- swap to a DT/Haste body of Nyame for idle survivability
        legs  = "Nyame Flanchard",
        feet  = "Nyame Sollerets",
        neck  = "Null Loop",         -- placeholder; TODO DT neck
        waist = "Null Belt",         -- placeholder; TODO DT/HP waist
        left_ear  = "Brutal Earring",
        right_ear = "Mache Earring +1",
        left_ring  = "Chirich Ring +1",
        right_ring = "Chirich Ring +1",
        back  = Mecisto_CP,
    }

    -- PDT idle — full Nyame DT shell.
    sets.idle.PDT = set_combine(sets.idle, {
        body  = "Nyame Mail",
        hands = "Nyame Gauntlets",
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
end


-------------------------------------------------------------------------------------------------------------------
-- Hook functions for job-specific events.
-------------------------------------------------------------------------------------------------------------------

-- Keep H2H sub slot empty (H2H occupies main+sub). Prevents a stray grip/shield from a shared
-- set leaking into PUP and breaking the H2H equip.
function job_post_precast(spell, action, spellMap, eventArgs)
    -- placeholder hook kept for parity / future use
end

-- Optional: if you later add pet-mode-aware swapping, branch here on pet.isvalid / pet.status.
function job_handle_equipping_gear(playerStatus, eventArgs)
    -- placeholder
end
