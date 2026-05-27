-------------------------------------------------------------------------------------------------------------------
-- Cevapi_GEO.lua — Geomancer 99 (sub /RDM)
--
-- Framework: Mote-Include (already in libs/), Mirdain-inspired structure & GEO patterns.
-- Practical automations baked in:
--   • Indi-active idle overlay via classes.CustomIdleGroups (auto-applies sets.idle.*.Indi while Indi up)
--   • Auto-Full-Circle when recasting a Geo-* with an existing luopan (toggle via //gs c afc)
--   • Bolster guard: blocks BoG / Ecliptic Attrition while Bolster is up (wasted under Bolster cap)
--   • Day/weather waist swap (Hachirin-no-Obi) on Cures and matching-element nukes
--   • Last-Indi / Last-Geo tracking + timer notifications (requires Windower 'timers' addon)
--   • CP toggle (gs c toggle CP) overlays Mecisto. Mantle
--
-- Keybinds (set in user_setup, cleared in user_unload):
--   F9       cycle OffenseMode   (Normal / Acc)
--   F10      cycle CastingMode   (Normal / Resistant / Burst) — Resistant = MAcc-leaning nuke for high-MEva mobs
--   F11      cycle IdleMode      (Normal / PDT)
--   F12      cycle HybridMode    (Normal / PDT)
--   Ctrl+F11 toggle Kiting       — overlays sets.Kiting (Geomancy Sandals move speed +12%)
--   Ctrl+F8  toggle CP mode      — overlays sets.CP (Mecisto. Mantle)
--                                  (moved off Ctrl+F12 — F12 had 4 modifier variants bound and Windower's
--                                  matcher dropped ^F12 → fell through to plain F12 = HybridMode cycle)
--   Alt+F12  toggle AutoFullCircle — auto Full Circle before re-casting Geo-*
--   Win+F12  force re-equip      (gs c update)
--
-- When you add or change a keybind: update this block, update user_setup() to bind it, and update
-- user_unload() to unbind it. Keep all three in sync — losing a bind on file_unload leaves it stuck
-- across job swaps.
--
-- //gs c commands added by this file:
--   gs c toggle CP                  — CP cape overlay on idle/engaged
--   gs c toggle Kiting              — movement-speed overlay (Mote-Include handles state.Kiting natively)
--   gs c toggle AutoFullCircle      — auto Full Circle before re-casting Geo-*
--   gs c afc                        — alias for AutoFullCircle toggle
--   gs c hud [show|hide|toggle]     — control the on-screen state HUD (default: toggle)
--   gs c hud pos <x> <y>            — move HUD to absolute pixel coordinates AND persist across logins
--   gs c hud where                  — print HUD's current rendered position (reflects mouse drags)
--   gs c hud save                   — persist HUD's current position (after dragging with mouse)
--                                       persistence file: data/Cevapi/Cevapi_GEO_hud.lua
--
-- Pet-aware idle switching:
--   GearSwap fires `pet_change(pet, gain)` when the luopan is summoned or dismissed (this is built into
--   GearSwap, not Mote). Mote-Include's `pet_change` handler calls `handle_equipping_gear(player.status)`,
--   which eventually calls `get_idle_set()`. Inside get_idle_set, Mote checks `pet.isvalid` and walks the
--   idle table down into `sets.idle.Pet` if it exists; otherwise stays on base `sets.idle`. So:
--     - Luopan summoned → equips sets.idle.Pet (or sets.idle.PDT.Pet if IdleMode=PDT)
--     - Luopan dismissed / dies → reverts to sets.idle (or sets.idle.PDT)
--   No job_pet_change override is needed for that switch — it happens automatically via Mote. Our
--   job_pet_change hook only cleans up the Luopan timer when the pet goes away.
--
-- ============================================================================================================
-- AT-99 UPGRADE ROADMAP — sources are EITHER verified OR marked "(source: TODO verify on BGWiki)".
-- I previously had wrong sources for almost every item — those have been corrected or struck.
--
-- VERIFIED UPGRADES (stats + source confirmed against BGWiki):
--   • Genmei Shield        — Genbu (Escha Ru'Aun Geas Fete);  PDT-10% sub at lvl 99. Mandatory mage shield long-term.
--                             — Currently using **Genbu's Shield** (lvl 74, also PDT-10%) as the interim placeholder
--                               in every sub slot. Genbu's is synergy-augmentable (Cure pot 1-5%, Cure cast 1-8%,
--                               MAcc 1-6, HP 6-25, MP 4-32) — worth augmenting via Tatter/Scrap Synergy if you can.
--   • Loricate Torque +1   — Sovereign Behemoth (Behemoth's Dominion) / Unity NPC upgrade;  Damage Taken -6%.
--   • Witful Belt          — Voidwatch (East Sarutabaruta);  Enhances FC + Haste+3% + Occ. quickens spellcasting +3%.
--   • Etiolation Earring   — Vagary (Perfidien in Outer Ra'Kaznar [U]);  FC+1%, MDT-3%, Resist Silence+15.
--   • Voltsurge Torque     — Cloister of Storms (Avatar Prime II);  FC+4%, MAcc+7, MP+20.
--   • Kishar Ring          — Reisenjima Henge Omen (Glassy Gorger);  FC+4%, MAcc+5, Enf.dur+10%.
--   • Defending Ring       — Sovereign Behemoth (Behemoth's Dominion);  Damage Taken -10%.
--   • Carmine Greaves +1   — Shinryu Abjuration trade;  Haste+4%, FAST CAST +8%, DA+4%, Store TP+8, Conserve MP+8.
--                             — NOT a movement speed piece (correction from earlier claim). It's a top-tier FC feet.
--   • Mujin Band           — Dynamis Windurst (Naa Yixo the Stillrage);  Skillchain Bonus+5, MBD II +5%.
--                             — NOT a RoE reward (correction from earlier claim).
--   • Friomisi Earring     — Wildskeeper Reive (Kumhau);  MAB+10, Enmity+2.
--   • Sors Shield          — Brothers D'Aurphe II BC (Macrocosmic Orb);  Cure potency +3%, Cure cast time -5%.
--
-- ITEMS REMOVED FROM ROADMAP (verified to NOT do what I claimed OR GEO can't equip):
--   ✗ Sanare Earring       — has NO cure cast time reduction. (Actual: MEva+6, MDB+4, Club skill+5)
--   ✗ Sanctity Necklace    — has NO Refresh, NO Cure potency, NO MND. (Actual: HP/MP+35, MAcc/MAB/Acc/RAcc+10, Regen+2)
--   ✗ Sacro Gorget         — PLD/RUN ONLY. GEO cannot equip.
--   ✗ Bishop's Sash        — has NO Cure potency. (Actual: Divine/Healing skill +5 only)
--   ✗ Beatific Earring     — has NO Cure potency. (Actual: Divine/Healing skill +4 only)
--   ✗ Lugalbanda Earring   — has NO Refresh. (Actual: MEva+10, MAcc+15, Avatar/RAcc+15, BP dmg+10)
--   ✗ Hermes' Sandals      — WAR/MNK/COR/PUP/RUN only. GEO cannot equip. Find other movement-speed feet.
--   ✗ Atrophy Tights +3    — RDM ONLY. GEO cannot equip. (It does have Cure pot +12% but inaccessible)
--
-- VERIFIED CURE / FC / STONESKIN UPGRADES (GEO-equippable):
--   • Amalric Coif         — Venerian Abjuration trade;  FC+10%, Refresh potency+1, Aquaveil+1, Haste+6%. GEO can equip.
--                             — Huge FC/Refresh head; replaces Vanya Hood Path D in FC set if acquired.
--   • Lebeche Ring         — Avatar Prime II (Cloister of Gales);  Cure potency +3%, Quick Magic +2%, MP+40.
--                             — Cure set ring, not FC ring (correction from earlier claim).
--   • Stone Gorget         — Quest "Empty Memories";  Stoneskin +30 HP absorbed.
--   • Umuthi Hat           — Wopket in Yorcia Weald [U] Delve;  Stoneskin cast time -15%. GEO can equip.
--   • Eidolon Pendant      — Walk of Echoes (Second Walk Non-Surged);  MP recovered while healing +4 (niche utility).
--   • Geomancy Sandals (base AF) — Wescolina craft (Bloodline of Zacariah quest);  Movement speed +12% + Haste+3% (GEO-only).
--                             — Your actual move-speed feet (already own); Hermes' Sandals is job-blocked.
--   • Herald's Gaiters     — Kupon AW-Mis / The Savage II / Bonanza;  Movement speed +12%. (Geomancy Sandals base wins.)
--   • Witching Robe        — Sinister Reign (Arciela);  MAB+25, Refresh+2, Haste+3%, Conserve MP+5.
--                             — Alternative Refresh idle body (Shamash Robe is still better at Refresh+3 + PDT-10%).
--   • Anhur Robe           — Emporox 25k Potpourri / Celaeno VW;  FC+10% body, NO Refresh.
--                             — FC body upgrade (no Refresh as community lore often claims).
--   • Psycloth Lappas (Path D) — Kupon AW-GF or Vidala (Escha-Zi'Tah Geas Fete) → Oboro augment;
--                                Path D = MP+80, MAcc+15, "Fast Cast"+7%. Equippable by GEO (verified BGWiki 2026-05-25).
--                                — PRIMARY FC legs upgrade. Replaces unaugmented Vanya Slops (0% FC) in
--                                  sets.precast.FC. Takes gear-side FC from 39% → 46%.
--                                — Note: this is +2% better than Lengo Pants' FC+5% below. If pursuing
--                                  only one FC legs upgrade, choose Psycloth Path D over Lengo.
--   • Lengo Pants          — Sinister Reign (Arciela/Ygnas);  FC+5%, Haste+5%, SIR-10%, MAB+20.
--                             — FC legs upgrade (replaces Vanya Slops placeholder in FC set).
--                             — INFERIOR to Psycloth Lappas Path D for pure FC (+5% vs +7%). Lengo's
--                               edge is Haste+5% and SIR-10%; Psycloth has neither. For an FC-focused
--                               set Psycloth wins; for a Haste/anti-interrupt blend Lengo is preferable.
--   • Phalaina Locket      — Bismarck Voidwatch / Bibiki Bay Pyxis;  MND+3, Cure potency +4%, Cure received +4%.
--                             — Tiny cure neck (better than Bagua Charm +2 for cure midcast); GEO-legal.
--   • Locus Ring           — Forri-Porri (Plasm) / Tax'et Delve;  Magic Critical Hit Rate +5%, MB bonus dmg.
--                             — Generic burst ring (not Wind/Earth-restricted as I incorrectly claimed earlier).
--   • Magnetic Earring     — Apocalypse Nigh quest;  MP+20, Conserve MP+5, SIR-8%, MP recovered while healing+1.
--                             — You own this; useful in a future SIRD set.
--
-- ITEMS REMOVED FROM ROADMAP (additional verifications):
--   ✗ Hermes' Sandals       — WAR/MNK/COR/PUP/RUN only. GEO blocked.
--   ✗ Atrophy Tights +3     — RDM only. GEO blocked.
--   ✗ Carmine Cuisses +1    — RDM/PLD/DRK/RNG/DRG/BLU/COR/RUN only. GEO blocked (no move-speed legs).
--   ✗ Skadi's Jambeaux +1   — THF/BST/RNG/COR/DNC/RUN only. GEO blocked.
--   ✗ Tandava Crackows      — DNC only. GEO blocked.
--   ✗ Leyline Gloves        — Not on GEO equip list. GEO blocked.
--   ✗ Roundel Earring       — WHM/BLM/RDM/DRG/SMN/PUP/DNC/RUN only. GEO blocked.
--   ✗ Phillemot             — DOES NOT EXIST on BGWiki (I made up the name).
--   ✗ Hesychast's Roundel   — DOES NOT EXIST (Hesychast is MNK AF, no Roundel piece).
--   ✗ Yamabuki-no-Obi       — has NO Cure potency. (Actual: MP+35, INT+6, MAB+5 — nuke waist, not cure)
--
-- VERIFIED HIGH-END BURST UPGRADES (Ea +1 set — Smithing 115-120 + Clothcraft; argentum tome required):
--   • Ea Hat +1            — MAB+38, Haste+6%, MBD I+7, MBD II+7, MAcc+50. GEO can equip.
--   • Ea Houppe. +1        — MAB+44, Haste+3%, MBD I+9, MBD II+9, MAcc+52.  BiS burst body for GEO long-term.
--   • Ea Cuffs +1          — MAB+35, Haste+3%, MBD I+6, MBD II+6, MAcc+49.
--   • Ea Slops +1          — MAB+41, Haste+5%, MBD I+8, MBD II+8, MAcc+51.  BiS burst legs for GEO long-term.
--   • Ea Pigaches +1       — MAB+32, Haste+3%, MBD I+5, MBD II+5, MAcc+48.
--     (NOT "Ea Espadrilles" — Espadrilles is the SCH/RDM/SMN reforged feet, different set.)
--     Each Ea piece carries BOTH MBD tiers; full set is the only GEO gear that fills MBD II from armor.
--
-- VERIFIED SORTIE BCNM MAGE UPGRADES:
--   • Ammurapi Shield      — Kei (Reisenjima Omen);  MAB+38, MAcc+38, Shield skill+107, Enh.Mag.Dur+10%. GEO can equip.
--                             — Top mage sub by a wide margin (no MBD but +38/+38 raw is huge).
--   • Acuity Belt +1       — Sheol A "Joyous Green" NM (after Unity accolades);  Base MP+35/INT+6; R15 Unity adds MAcc+15/INT+10.
--   • Crep. Earring        — Wyrm God II / Bonanza;  Acc+10, RAcc+10, MAcc+10, Store TP+5. All jobs.
--                             — Generic MAcc earring; usable in Resistant midcast and engaged.
--   • Crepuscular Ring     — (All Jobs);  RAcc+10, MAcc+10, Snapshot+3, Store TP+6.
--                             — Generic MAcc ring for GEO Resistant set.
--   • Sapience Orb         — Quest reward;  Enmity+2, FC+2%. All jobs. Low-impact FC filler.
--
-- ITEMS BLOCKED FOR GEO (additional):
--   ✗ Inyanga +3 set       — WHM/BRD/SMN only. Despite community lore — NOT a GEO upgrade path.
--   ✗ Bunzi set            — WHM/RDM/BRD/SMN only. Bunzi's Robe has Cure pot+15% but GEO can't equip.
--   ✗ Crepuscular Pebble   — Neck slot with PDL/DT/STR/VIT (DD stats, not mage). Skip for GEO.
--
-- STILL UNVERIFIED (lower-priority items I have NOT confirmed against BGWiki — verify before recommending):
--   • Telchine set augment values (each piece) — claimed +Enh.Mag.Dur per piece
--   • Merlinic Dastanas augments — claimed TH+2 augment available
--   • Bagua +3, Azimuth +2 / +3, Geomancy +1 stats — your RP-upgrade paths
--   • Idris (Mythic) — long-term comparison vs Solstice Path D
--
-- NOTE about Nantosuelta's Capes (TWO acquired as of 2026-05-23):
--   Cape A "Pet"  — VIT+20 / Eva+20/MEva+20 / Evasion+10 / Pet:Regen+10 / Pet:Regen+5  (=15 HP/tick pet regen)
--   Cape B "Solo" — VIT+20 / Eva+20/MEva+20 / Evasion+10 / Pet:Regen+10 / Phys.dmg.taken-10%
-- Wiring rule (encoded in init_gear_sets via Nantosuelta_Pet / Nantosuelta_Solo locals):
--   • luopan out  → Pet cape  (sets.idle.Pet, sets.idle.PDT.Pet, precast.JA["Life Cycle"])
--   • luopan not out → Solo cape (all other sets — base idle, PDT idle, cures, nukes, enfeebs, precast, WS)
--   • Solo cape STILL gives the luopan Pet:Regen+10, just not the extra +5 from Cape A's 5th slot.
--
-- 3rd-cape upgrade path: cure cape (HP+60 / Eva+20/MEva+20 / "Cure" potency+10% / Pet:Magic Eva+10 / Phys.dmg.taken-10%).
-- Would slot into sets.midcast.Cure / Curaga, replacing Nantosuelta_Solo there for cure-potency stacking.
-------------------------------------------------------------------------------------------------------------------


-- Mote auto-runs init_include() on include; it then calls job_setup, user_setup, init_gear_sets in that order.
function get_sets()
    mote_include_version = 2
    include('Mote-Include.lua')
end


-------------------------------------------------------------------------------------------------------------------
-- HUD overlay using Windower's `texts` library. Lives at file scope so init_hud/update_hud/destroy_hud all
-- reference the same object. Default position is bottom-left of a 1080p game window; drag to relocate
-- (the text is set draggable below). //gs c hud show/hide/toggle to control visibility.
-------------------------------------------------------------------------------------------------------------------
local texts = require('texts')

local hud_format = 'GEO  Off:${off|?}  Cast:${cast|?}  Idle:${idle|?}  Hyb:${hyb|?}  Def:${def|None}  CP:${cp|off}  Kit:${kit|off}  AFC:${afc|off}  Indi:${indi|--}'

local hud_settings = {
    pos = { x = 8, y = 1052 },            -- bottom-left, just below default chat window at 1080p
    bg  = { red = 0, green = 0, blue = 0, alpha = 180, visible = true },
    text = {
        font = 'Grammara', size = 10,        -- matches xivparty's font (FFXIV-style, Windower-bundled)
        fonts = { 'Consolas', 'Arial' },     -- fallbacks if Grammara isn't found
        alpha = 255, red = 255, green = 255, blue = 255,
        stroke = { width = 2, alpha = 200, red = 0, green = 0, blue = 0 },
    },
    flags = { draggable = true, bold = false },
    padding = 2,
}

local hud = nil

-- Persisted HUD position. Lives next to this file so it survives `gs reload` and
-- relogs. Written by `gs c hud pos <x> <y>`, read by init_hud at startup.
local hud_pos_path = windower.addon_path..'data/Cevapi/Cevapi_GEO_hud.lua'

function load_hud_pos()
    local f = io.open(hud_pos_path, 'r')
    if not f then return nil end
    f:close()
    local ok, pos = pcall(dofile, hud_pos_path)
    if ok and type(pos) == 'table' and tonumber(pos.x) and tonumber(pos.y) then
        return { x = tonumber(pos.x), y = tonumber(pos.y) }
    end
    return nil
end

function save_hud_pos(x, y)
    local f = io.open(hud_pos_path, 'w')
    if not f then
        add_to_chat(123, '[GEO] Could not write HUD position to '..hud_pos_path)
        return false
    end
    f:write(string.format('return { x = %d, y = %d }\n', x, y))
    f:close()
    return true
end

function init_hud()
    -- If a saved position exists, override the default before creating the text object
    -- so the HUD appears at the persisted spot rather than the (8, 1052) default.
    local saved_pos = load_hud_pos()
    if saved_pos then
        hud_settings.pos = saved_pos
    end
    if not hud then
        hud = texts.new(hud_format, hud_settings)
    elseif saved_pos then
        hud:pos(saved_pos.x, saved_pos.y)
    end
    hud:show()
end

function update_hud()
    if not hud then return end
    -- Direct property assignment + bare :update() — more reliable than passing a table to :update().
    hud.off  = (state.OffenseMode     and state.OffenseMode.value)     or '?'
    hud.cast = (state.CastingMode     and state.CastingMode.value)     or '?'
    hud.idle = (state.IdleMode        and state.IdleMode.value)        or '?'
    hud.hyb  = (state.HybridMode      and state.HybridMode.value)      or '?'
    hud.def  = (state.DefenseMode     and state.DefenseMode.value)     or 'None'
    hud.cp   = (state.CP              and state.CP.value)              and 'ON'  or 'off'
    hud.kit  = (state.Kiting          and state.Kiting.value)          and 'ON'  or 'off'
    hud.afc  = (state.AutoFullCircle  and state.AutoFullCircle.value)  and 'ON'  or 'off'
    hud.indi = last_indi or '--'
    hud:update()
end

function destroy_hud()
    if hud then
        hud:destroy()
        hud = nil
    end
end

-- Mote-SelfCommands calls this whenever a mode cycles. Overriding it lets us update the HUD
-- and (by setting handled) suppress Mote's default "Mode set to X" chat printout.
function display_current_job_state(eventArgs)
    update_hud()
    if eventArgs then eventArgs.handled = true end
end


-- Mote calls job_state_change on EVERY state cycle/toggle/set/reset (cleaner hook than
-- display_current_job_state, which doesn't fire for `gs c toggle <field>`).
function job_state_change(field, new_value, old_value)
    update_hud()
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific setup (runs before user_setup).
-------------------------------------------------------------------------------------------------------------------
function job_setup()
    -- Register buffs Mote should auto-track on state.Buff[...]
    state.Buff['Bolster']         = buffactive['Bolster']         or false
    state.Buff['Entrust']         = buffactive['Entrust']         or false
    state.Buff['Blaze of Glory']  = buffactive['Blaze of Glory']  or false
    state.Buff['Colure Active']   = buffactive['Colure Active']   or false
end


-------------------------------------------------------------------------------------------------------------------
-- User-specific setup (state vars, keybinds, macros).
-------------------------------------------------------------------------------------------------------------------
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'PDT')
    state.CastingMode:options('Normal', 'Resistant', 'Burst')
    state.IdleMode:options('Normal', 'PDT')
    state.WeaponskillMode:options('Normal', 'Acc')

    -- Custom toggles
    state.CP             = M(false, 'Capacity Points Mode')
    state.AutoFullCircle = M(true,  'Auto Full Circle')

    -- Tracking state — used by Indi overlay and timer cleanup
    last_indi = nil
    last_geo  = nil

    -- Macro setup — adjust book/sheet to your in-game macros for GEO
    set_macro_page(1, 5)    -- Sheet 1, Book 5 (user's GEO macro book)

    -- Keybinds
    send_command('bind F9 gs c cycle OffenseMode')
    send_command('bind F10 gs c cycle CastingMode')
    send_command('bind F11 gs c cycle IdleMode')
    send_command('bind F12 gs c cycle HybridMode')
    send_command('bind ^F8 gs c toggle CP')
    send_command('bind !F12 gs c toggle AutoFullCircle')
    send_command('bind @F12 gs c update')
    send_command('bind ^F11 gs c toggle Kiting')   -- Ctrl+F11: toggle Kiting (overlays sets.Kiting via Mote's apply_kiting)

    -- HUD overlay (see file-scope section above)
    init_hud()
    update_hud()
end


-- Called from Mote's file_unload — clean up our binds AND the HUD overlay
function user_unload()
    send_command('unbind F9; unbind F10; unbind F11; unbind F12')
    send_command('unbind ^F8; unbind !F12; unbind @F12; unbind ^F11')
    destroy_hud()
end


-------------------------------------------------------------------------------------------------------------------
-- Gear sets.
-------------------------------------------------------------------------------------------------------------------
function init_gear_sets()
    -- Two Nantosuelta capes — identical except 5th augment. Rule: Pet cape (Regen+5) when luopan
    -- is out, Solo cape (PDT-10%) when it isn't. Both still carry Pet Regen+10 so the luopan keeps
    -- regen even in the Solo cape, just less. Augment order is order-sensitive in gearswap matching.
    --
    --   Nantosuelta_Pet  — VIT+20 / Eva+20+MEva+20 / Evasion+10 / Pet:Regen+10 / Pet:Regen+5
    --                      = 15 HP/tick pet regen total. Used in sets.idle.Pet, sets.idle.PDT.Pet,
    --                      and precast.JA["Life Cycle"] (Life Cycle requires luopan out by design).
    --
    --   Nantosuelta_Solo — VIT+20 / Eva+20+MEva+20 / Evasion+10 / Pet:Regen+10 / Phys.dmg.taken-10%
    --                      = 10 HP/tick pet regen + PDT-10%. Used in every other set (idle/PDT/cures/
    --                      nukes/enfeebs/precast/WS) — PDT-10% on a single slot is meaningful for
    --                      player survival during cast windows where luopan is not contributing.
    local Nantosuelta_Pet = { name="Nantosuelta's Cape", augments={
        'VIT+20',
        'Eva.+20 /Mag. Eva.+20',
        'Evasion+10',
        'Pet: "Regen"+10',
        'Pet: "Regen"+5',
    }}
    local Nantosuelta_Solo = { name="Nantosuelta's Cape", augments={
        'VIT+20',
        'Eva.+20 /Mag. Eva.+20',
        'Evasion+10',
        'Pet: "Regen"+10',
        'Phys. dmg. taken-10%',
    }}

    -- =============================================================================
    -- PRECAST: Fast Cast & spell-specific FC overlays
    -- =============================================================================
    -- Confirmed FC from owned gear (all VERIFIED against BGWiki):
    --   Solstice Path D R15  : +5% FC + Indicolure dur+15
    --   Dunna R15            : +3% FC
    --   Vanya Hood (Path D)  : +10% FC + Haste+2% + base Cure pot+10%
    --   Vanya Clogs (Path D) : +10% FC + Haste+2%
    --   Embla Sash           : +5% FC + Enh.Mag.Dur+10% + Sublimation+3
    --   Loquac. Earring      : +2% FC
    --   Malignance Earring   : +4% FC + INT+8 + MND+8 + MAcc+10 + MAB+8
    --   Total confirmed      : 39% FC. Cast-time-cap is -80%; gap closes with TODO accessories + Indi-Haste buff.
    sets.precast.FC = {
        main  = "Solstice",             -- has Path D R15 — +5% FC
        sub   = "Genbu's Shield",       -- has — lvl 74 mage shield, PDT-10%. Upgrade target: Genmei Shield (lvl 99, Genbu Geas Fete Escha Ru'Aun)
        range = "Dunna",                -- has R15 — +3% FC (Dunna lives in the range slot, not ammo)
        head  = "Vanya Hood",           -- has Path D — +10% FC
        body  = "Vanya Robe",           -- has Path C — SIRD-15%, no FC contribution; placeholder
        hands = "Vanya Cuffs",          -- has Path B — Healing+20, Cure cast -7% (Cure-only); placeholder for non-cure FC
        legs  = "Vanya Slops",          -- unaugmented — no FC; placeholder. Lengo Pants +13% FC is upgrade target.
        feet  = "Vanya Clogs",          -- has Path D — +10% FC
        neck  = "Voltsurge Torque",     -- TODO: Cloister of Storms (Avatar Prime II) or Kupon AW-Mis; +4% FC
        waist = "Embla Sash",           -- has — +5% FC (verified)
        left_ear  = "Loquac. Earring",  -- has — +2% FC
        right_ear = "Malignance Earring", -- has — FC+4%, INT+8, MND+8, MAcc+10, MAB+8 (replaces Etiolation TODO; Malignance is +3% FC over Etiolation)
        left_ring  = "Kishar Ring",     -- TODO: Reisenjima Henge Omen (Glassy Gorger); +4% FC
        right_ring = "Lebeche Ring",    -- TODO: stats not yet BGWiki-verified
        back  = Nantosuelta_Solo,            -- 0 FC contribution; placeholder
    }

    -- Cure precast — Vanya Cuffs Path B's "Cure cast time -7%" is already in base FC.hands.
    -- (Correction: -7% Cure cast time is on HANDS, not body.)
    sets.precast.FC.Cure = sets.precast.FC

    -- Elemental Magic precast — adds Elemental cast-time-reduction on hands.
    -- Bagua Mitaines +2 (-13% Elemental cast) is the biggest single source.
    -- Mall. Chapeau +2 (-6%) and Mall. Clogs +2 (-6%) compete with Vanya Hood/Clogs Path D's +10% FC.
    -- Math: -10% FC > -6% Elemental cast for these slots, so we keep Vanya in head/feet.
    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {
        hands = "Bagua Mitaines +2",    -- has — -13% Elemental Magic cast time
    })

    -- Geomancy precast — Dunna already in base; nothing more to add here for now.
    sets.precast.FC.Geomancy = sets.precast.FC

    -- =============================================================================
    -- PRECAST: Job Abilities (each piece augments the JA effect)
    -- =============================================================================
    sets.precast.JA = {}
    sets.precast.JA["Bolster"]            = { body  = "Bagua Tunic +2"     }  -- has — Enhances Bolster: +30s duration (augment persists once equipped at JA use)
    sets.precast.JA["Life Cycle"]         = { body  = "Geomancy Tunic +2", back = Nantosuelta_Pet }  -- has — "Life Cycle"+12 (was +10 on AF +1) = more HP transferred to luopan; Pet cape because luopan is by definition out when Life Cycle fires
    sets.precast.JA["Full Circle"]        = { head  = "Azimuth Hood +2",
                                              hands = "Bagua Mitaines +2"  }  -- +MP recovered (Hood +2 has Full Circle+3 vs +1's +2)
    sets.precast.JA["Radial Arcana"]      = { feet  = "Bagua Sandals +3"   }  -- has — Augment: Enhances Radial Arcana effect = +5% MP restored per merit level (so +25% MP at 5/5 merits, party-wide AoE)
    sets.precast.JA["Mending Halation"]   = { legs  = "Bagua Pants +2"     }  -- +AoE Cure amount
    sets.precast.JA["Ecliptic Attrition"] = { hands = "Geomancy Mitaines +3"   }  -- has — +next aura tick potency (AF+3 retains the Ecliptic Attrition augment from base AF, now stronger)
    sets.precast.JA["Lasting Emanation"]  = { body  = "Geomancy Tunic +2"  }  -- has — base stats upgrade only; AF body actually augments "Life Cycle" not "Lasting Emanation" (the original file comment was wrong). Slot kept for stat consistency.
    sets.precast.JA["Theurgic Focus"]     = { head  = "Azimuth Hood +2"    }  -- +next-spell MAB
    sets.precast.JA["Curative Recantation"] = { hands = "Bagua Mitaines +2" }  -- has — augment "Enhances Curative Recantation effect" (+2% per RP level on +2; scales to +3)
    sets.precast.JA["Primeval Zeal"]      = { head  = "Bagua Galero +2"    }  -- has — augment "Enhances Primeval Zeal effect"
    sets.precast.JA["Concentric Pulse"]   = { head  = "Bagua Galero +2"    }  -- has — augment "Concentric Pulse uses Luopan's max HP instead of current HP"; Galero +2 also adds +30 to Drain/Aspir potency (not a JA effect)
    sets.precast.JA["Blaze of Glory"]     = {}  -- no GEO JSE augments Blaze of Glory
    sets.precast.JA["Entrust"]            = {}  -- no GEO JSE augments Entrust (verified across all 15 +3 slot pages 2026-05-20)

    -- =============================================================================
    -- PRECAST: Weapon Skills (Cataclysm, Black Halo, Realmrazer share Nyame base)
    -- =============================================================================
    sets.precast.WS = {
        sub   = "Genbu's Shield",       -- has — PDT-10% sub (no WS damage benefit; auto-unequips if you swap to a 2H weapon)
        range = "Dunna",                -- has R15 — locked; ammo slot left empty (collides with range on GEO).
                                        -- If you ever decide WS MAB > Dunna utility, swap to ammo = "Pemphredo Tathlum"
                                        -- (Pemphredo gives MAB+4, MAcc+8, INT+4 — better for one-off WS dmg)
        head  = "Nyame Helm",
        body  = "Nyame Mail",
        hands = "Nyame Gauntlets",
        legs  = "Nyame Flanchard",
        feet  = "Nyame Sollerets",
        neck  = "Fotia Gorget",         -- has
        waist = "Fotia Belt",           -- has
        left_ear  = { name="Moonshade Earring", augments={'TP Bonus +250'} },  -- has (verify augment)
        right_ear = "Mache Earring +1", -- has
        left_ring  = "Chirich Ring +1", -- has
        right_ring = "Mummu Ring",      -- has
        back  = Nantosuelta_Solo,
    }

    -- =============================================================================
    -- MIDCAST: Cures & Cursna
    -- =============================================================================
    sets.midcast.FastRecast = sets.precast.FC

    -- Cure midcast — VERIFIED against BGWiki for every owned piece.
    --   Marin Staff is NOT a cure weapon (it's a Wind-element nuke staff with FC+2%). Removed.
    --   Of your Vanya pieces, only Vanya Hood base has Cure potency (+10%).
    --   Vanya Cuffs Path B is the Healing Skill +20 source.
    --   Sanare Earring does NOT have cure cast time reduction (verified base stats: MEva+6, MDB+4, Club skill+5).
    sets.midcast.Cure = {
        main  = "Daybreak",             -- has — Aeonic club: Cure potency +30%, MND+30, Magic Damage+241, Refresh+1. THE biggest cure mainhand upgrade in the game (acquired 2026-05-20)
        sub   = "Genbu's Shield",       -- has — lvl 74, PDT-10% (synergy-augmentable for Cure pot 1-5%, Cure cast 1-8%); upgrade: Genmei Shield
        range = "Dunna",                -- has R15 — Dunna locked in range; for GEO the ammo slot collides with range
                                        --   so we leave ammo undefined. Hydrocera (MND+3, MAcc+6) would kick out
                                        --   Dunna and lose more than it gains. Same story for Pemphredo Tathlum.
        head  = "Vanya Hood",           -- has Path D — base Cure potency +10%, +10% FC + Haste 2%
        body  = "Vanya Robe",           -- has Path C — MND+10, SIRD-15%, no cure benefit; placeholder
        hands = "Vanya Cuffs",          -- has Path B — Healing Skill +20, Cure cast time -7%, MDT-3%
        legs  = "Bagua Pants +2",       -- has — HP+108 (vs Vanya Slops HP+43). Vanya Slops are unaugmented and give 0 cure benefit; Bagua Pants are also 0 cure benefit but preserve 65 HP during midcast. If Vanya Slops Path A is augmented later (+Cure potency 7%), swap back.
        feet  = "Vanya Clogs",          -- has Path D — +10% FC, no specific cure benefit but stays in slot
        neck  = "Bagua Charm +2",       -- has — MAcc+30, Geomancy+7; placeholder until a Cure-pot neck is acquired
        waist = "Embla Sash",           -- placeholder; auto-overridden to Hachirin-no-Obi on Lightsday (TODO: verify Hachirin)
        left_ear  = "Mendi. Earring",   -- has — VERIFIED: Cure potency +5% + Cure cast -5% + MP+30 + Conserve MP+2 — real cure piece
        right_ear = "Alabaster Earring",-- has — HP+100, Haste+5%, DT-5% (was Loquac. Earring; Loquac's only contribution is FC+2% which DOESN'T apply during midcast, only precast — so it was costing 100 HP for zero cure benefit). Alabaster adds DT during the cast vulnerability window.
        left_ring  = "Stikini Ring +1", -- has — VERIFIED: MND+8, MAcc+11, All magic skills +8 (incl. Healing), Refresh+1
        right_ring = "Stikini Ring +1", -- TODO: verify you own a 2nd (gearinfo only saw one)
        back  = Nantosuelta_Solo,            -- pet/eva cape — 0 cure benefit; placeholder
    }
    sets.midcast.Curaga = sets.midcast.Cure

    sets.midcast.Cursna = set_combine(sets.midcast.Cure, {
        neck       = "Debilis Medallion",  -- TODO: Limbus or Ambuscade
        right_ring = "Haoma's Ring",       -- TODO: Ambuscade
        left_ring  = "Menelaus's Ring",    -- TODO: Ambuscade
    })

    -- =============================================================================
    -- MIDCAST: Enhancing Magic (/RDM sub gives Phalanx, Haste II, Bar spells, Refresh II)
    -- =============================================================================
    sets.midcast['Enhancing Magic'] = {
        main  = "Solstice",
        sub   = "Genbu's Shield",           -- has — lvl 74 sub, PDT-10%; upgrade target: Genmei Shield
        range = "Dunna",                    -- has R15 — locked; ammo slot left empty (collides with range on GEO)
        head  = "Azimuth Hood +2",          -- has — Geomancy skill+20, Haste+6%, Full Circle+3, DT-11%, MAB+46
        body  = "Telchine Chasuble",        -- TODO: Skirmish — +Enh.Mag duration
        hands = "Telchine Gloves",          -- TODO: Skirmish
        legs  = "Telchine Braconi",         -- TODO: Skirmish
        feet  = "Telchine Pigaches",        -- TODO: Skirmish
        neck  = "Incanter's Torque",        -- TODO: Eschan Portal NM; +10 Enhancing skill
        waist = "Embla Sash",               -- has — +10% Enh.Mag duration
        left_ear  = "Andoaa Earring",       -- TODO: Voidstone trade; +5 Enh.Mag skill
        right_ear = "Mimir Earring",        -- TODO: Reisenjima HM; +10 Enh.Mag skill
        left_ring  = "Stikini Ring +1",
        right_ring = "Stikini Ring +1",     -- TODO: 2nd Stikini verify
        back  = Nantosuelta_Solo,
    }

    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {
        main = "Daybreak",                  -- has — Refresh+1 augments the self-Refresh buff tier
        head = "Amalric Coif",              -- TODO: Sortie BCNM; +Refresh potency
        body = "Shamash Robe",              -- has — fallback if no Amalric body
        legs = "Atrophy Tights +3",         -- TODO: Reforged BLM legs +3 — but you're GEO so probably skip
        waist = "Gishdubar Sash",           -- TODO: Reisenjima Synergy
    })

    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
        head  = "Umuthi Hat",               -- TODO: Skirmish; +Stoneskin potency
        neck  = "Stone Gorget",             -- TODO: Lv 60 craftable, very cheap
        waist = "Siegel Sash",              -- TODO: Lufaise Meadows NM; +Stoneskin potency
    })

    sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {
        head  = "Amalric Coif",             -- TODO
        hands = "Regal Cuffs",              -- TODO: Ambuscade
    })

    sets.midcast.Phalanx     = set_combine(sets.midcast['Enhancing Magic'], {})  -- /RDM sub gives Phalanx
    sets.midcast.Haste       = set_combine(sets.midcast['Enhancing Magic'], {})  -- /RDM sub gives Haste II
    sets.midcast.BarElement  = set_combine(sets.midcast['Enhancing Magic'], {})  -- Bar-* spells

    -- =============================================================================
    -- MIDCAST: Enfeebling Magic (Slow II, Paralyze II, Dia, Bio, Sleep, etc.)
    -- =============================================================================
    sets.midcast['Enfeebling Magic'] = {
        main  = "Daybreak",                 -- has — MAcc+40 (vs Solstice Path D MAcc+35), MND+30 (boosts MND-based enfeebs like Slow II / Paralyze II)
        sub   = "Genbu's Shield",           -- has — lvl 74, PDT-10%. Upgrade target: Ammurapi Shield (Sortie BCNM; +Enfeebling effect)
        range = "Dunna",                    -- has R15 — locked; ammo slot left empty (collides with range on GEO)
        head  = "Bagua Galero +2",          -- has — Indi magic acc + Geomancy skill
        body  = "Azimuth Coat +2",          -- has — MAcc+54, MAB+54, Elemental skill+23, Refresh+3, MBD II+4, Haste+3%, Enmity-9
        hands = "Azimuth Gloves +1",        -- has
        legs  = "Azimuth Tights +2",        -- has — MAcc+53, MAB+53, INT+50, MND+33, MDmg+23, Dark skill+25, Haste+5%, MBD+10 (strict upgrade over Bagua Pants +2's MAcc+29)
        feet  = "Bagua Sandals +3",         -- has — Enfeebling skill+21 (vs +19 on +2), MAcc+36, MAB+48; lands /RDM sub enfeebles cleaner
        neck  = "Bagua Charm +2",           -- has
        waist = "Acuity Belt +1",           -- TODO: Sortie; +MAcc
        left_ear  = "Regal Earring",        -- TODO: Ambuscade
        right_ear = "Vor Earring",          -- TODO: Reisenjima
        left_ring  = "Stikini Ring +1",
        right_ring = "Stikini Ring +1",
        back  = Nantosuelta_Solo,
    }

    -- =============================================================================
    -- MIDCAST: Elemental Magic (nukes + helices)
    --
    -- Three CastingMode tiers, cycle with F10 (//gs c cycle CastingMode):
    --   Normal      → pure damage (Jhakri/Mallquis where they beat Azimuth +1 for MAB)
    --   Resistant   → swap a few MAB pieces for MAcc when the mob resists your spells
    --   Burst       → Magic Burst Damage stacking (only fires inside a Skillchain window)
    --
    -- The Burst set stacks TWO separate caps:
    --   • Magic Burst Damage I  (cap +40%; Jhakri Robe +2 provides +6%)
    --   • Magic Burst Damage II (cap +10%; Mall. Chapeau/Cuffs +2 contribute here)
    -- BOTH stack additively — so Jhakri Robe + Mall. pieces > all-Jhakri.
    -- =============================================================================
    sets.midcast['Elemental Magic'] = {
        main  = "Daybreak",                 -- has — Magic Damage+241 (vs Solstice +124 — biggest single delta), MAB+40, MAcc+40, MND+30. Trade: lose Pet:DT-4% during cast window and INT+6 — worth it for the MD swing
        sub   = "Genbu's Shield",           -- has — lvl 74, PDT-10%. Upgrade target: Ammurapi Shield (Sortie BCNM; M.Eva + Enhances Helix dmg)
        range = "Dunna",                    -- has R15 — locked; ammo slot left empty (collides with range on GEO)
        head  = "Jhakri Coronal +2",        -- has — MAB+27, INT+22 (NOTE: Azimuth Hood +2 has MAB+46/INT+34 — verify Jhakri Coronal +2 actual stats; may be obsoleted)
        body  = "Jhakri Robe +2",           -- has — MAB+47, INT+27, +6% MBD I
        hands = "Jhakri Cuffs +2",          -- has — MAB+23, INT+22
        legs  = "Azimuth Tights +2",        -- has — MAB+53, INT+50, MDmg+23, MAcc+53, MBD+10, Haste+5%, Dark skill+25 (strict upgrade over Jhakri Slops +2 in every relevant nuke stat)
        feet  = "Jhakri Pigaches +2",       -- has — MAB+27, INT+22
        neck  = "Bagua Charm +2",           -- has (small MAB via skill; better neck options are Ambuscade)
        waist = "Embla Sash",               -- placeholder; auto-overridden by day/weather waist check below
        left_ear  = "Friomisi Earring",     -- TODO: Ambuscade; +10 MAB
        right_ear = "Regal Earring",        -- TODO: Ambuscade; MAcc + MAB combo
        left_ring  = "Jhakri Ring",         -- has — MAB+5, INT+5
        right_ring = "Metamor. Ring +1",    -- TODO: Sheol path A; INT+10, MAB+8
        back  = Nantosuelta_Solo,                -- current pet cape contributes ~0 MAB; nuke cape is a major upgrade
    }

    -- RESISTANT: swap MAB pieces for highest-MAcc verified pieces. Mall. +2 has MAcc+42-44 per piece.
    sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {
        -- head stays Jhakri Coronal +2 (MAcc+44, tied with Mall. Chapeau +2 but higher MAB)
        -- body stays Jhakri Robe +2 (MAcc+46, highest)
        hands = "Mall. Cuffs +2",           -- has — MAcc+43 (vs Bagua Mitaines +2 MAcc+28)
        -- legs stays Azimuth Tights +2 from base (MAcc+53 already beats Jhakri Slops +2 MAcc+45 and Mall. Trews +2)
        feet  = "Mall. Clogs +2",           -- has — MAcc+42 (still beats Bagua Sandals +3's MAcc+36 for Resistant casting)
    })

    -- BURST: Azimuth Coat +2 body + Azimuth Tights +2 legs (MAB / MBD I / Empyrean set bonus) + Nyame head + MBD-heavy hands/feet.
    -- MBD totals in this set:
    --   MBD I  = Nyame Helm+5 + Bagua Mitaines+8 + Azimuth Tights +2 (+10) + Jhakri Pigaches+7 + Jhakri Ring+2 = 32 (cap +40%)
    --   MBD II = Azimuth Coat +2 (+4) = 4 (cap +10%) — Coat +2 is the only GEO body with MBD II
    -- Net swing from removing Nyame Flanchard and adding Azimuth Tights +2:
    --   +4 MBD I, +23 MAB, +28 INT, +23 MDmg, +5% Haste, -6 SC Bonus, -8% DT
    -- Net swing from removing Nyame Mail and adding Azimuth Coat +2 (prior swap):
    --   -7 MBD I, +4 MBD II, +24 MAB, +3 Refresh, +Elemental skill+23, -9% DT
    -- Azimuth Coat +2 + Tights +2 = 2 Empyrean +2 pieces; the "Occ. casts geomancy w/o MP" set bonus is irrelevant here
    -- (it only triggers on geomancy spells, not elemental nukes). Adding Mujin Band (TODO, +5 MBD II) → 9 MBD II.
    sets.midcast['Elemental Magic'].Burst = set_combine(sets.midcast['Elemental Magic'], {
        head  = "Nyame Helm",               -- has — MAB+30, MBD+5, SC Bonus+5, DT-7%
        body  = "Azimuth Coat +2",          -- has — MAB+54, MBD II+4, Refresh+3, Elemental skill+23, INT+45 (no DT, but +24 MAB and the only GEO body with MBD II)
        hands = "Bagua Mitaines +2",        -- has — MAB+43, MBD+8 (more MAB than Nyame Gauntlets's MAB+30 + MBD+5)
        -- legs stays Azimuth Tights +2 from base (MAB+53, MBD+10 beats Nyame Flanchard's MAB+30, MBD+6 — see header comment for swing)
        feet  = "Jhakri Pigaches +2",       -- has — MAB+39, MBD+7 (more MAB than Nyame Sollerets's MAB+30 + MBD+5)
        left_ring  = "Jhakri Ring",         -- has — MAB+3, MBD+2 (small additional MBD; Set Bonus FC if Jhakri stack)
        right_ring = "Mujin Band",          -- TODO: claimed +5% MBD II — stats need BGWiki verification
    })

    -- Helices (when /SCH or /BLM): use Burst for amped damage if SC window
    sets.midcast.Helix = sets.midcast['Elemental Magic']

    -- =============================================================================
    -- MIDCAST: Dark / Divine
    -- =============================================================================
    sets.midcast['Dark Magic'] = sets.midcast['Enfeebling Magic']
    sets.midcast.Drain         = sets.midcast['Dark Magic']
    sets.midcast.Aspir         = sets.midcast['Dark Magic']
    sets.midcast.Stun          = sets.midcast['Dark Magic']
    sets.midcast['Divine Magic'] = sets.midcast['Elemental Magic']  -- Banish

    -- =============================================================================
    -- MIDCAST: Geomancy (Indi-* / Geo-*) — skill-capped base + Indi overlay
    -- =============================================================================
    -- Base is the "skill cap" stack. Indi overlay adds duration without losing skill.
    sets.midcast.Geomancy = {
        main  = "Solstice",                 -- has — Path D R15. KEEP for GEO: base Handbell skill+5 (boosts Geo-* / Indi-* potency) + Indicolure dur+15. Daybreak has MD+241 but zero Handbell skill / zero Indi dur — wrong tool for Geomancy
        sub   = "Genbu's Shield",           -- has — lvl 74 sub, PDT-10%; upgrade target: Genmei Shield
        range = "Dunna",                    -- has — Geomancy +5 + R15 augments (Dunna is range slot, not ammo)
        head  = "Azimuth Hood +2",          -- has — Geomancy skill +20 (was +15 on +1), DT-11%, Full Circle+3, Luopan Regen+4, Haste+6%
        body  = "Bagua Tunic +2",           -- has — Geomancy skill +14, MAcc+30, MAB+56, INT/MND/CHR+34, Haste+3%
        hands = "Geomancy Mitaines +3",     -- has — Geomancy skill+19 (was +15 on +1), MAcc+48, PDT-3%, Luopan DT-13%, Haste+3%, Ecliptic Attrition augment
        legs  = "Bagua Pants +2",           -- has
        feet  = "Azimuth Gaiters +2",       -- has — Indicolure spell duration +25, DT-10%, MAcc+50, MAB+45, Haste+3% (replaces +1: more Indi dur and DT-10% is new)
        neck  = "Bagua Charm +2",           -- has
        waist = "Embla Sash",
        left_ear  = "Mendi. Earring",       -- has
        right_ear = "Lugalbanda Earring",   -- TODO
        left_ring  = "Stikini Ring +1",
        right_ring = "Stikini Ring +1",
        back  = Nantosuelta_Solo,
    }

    -- Indi-* overlay: same base but lean into duration where possible.
    -- Will be selected when spellMap == 'Indi' (set in job_get_spell_map).
    sets.midcast.Geomancy.Indi = set_combine(sets.midcast.Geomancy, {
        -- Bagua Sandals +1/+2 has Indi duration; if your Sandals +2 has the Indi aug, keep them.
        -- TODO: once you have a Lifestream Cape (Reisenjima craft), put it here:
        --   back = { name="Lifestream Cape", augments={...} }
    })

    -- Geo-* overlay: luopan stats are LOCKED at "time of placement" (BGWiki Luopan page).
    -- Whatever gear is equipped at the moment the cast completes is what the spawned luopan
    -- inherits — aftercast gear changes do NOT retroactively adjust the luopan's HP/regen.
    -- So pet-stat pieces must live in midcast (not just sets.idle.Pet) to be inherited.
    --
    -- Feet swap: Azimuth Gaiters +2 (DT-10%, no pet stat) → Bagua Sandals +3 (Luopan: Regen+5).
    -- Trade: lose DT-10% during the ~2s cast window, gain Luopan Regen+5 for the luopan's
    -- entire life. Cheap win for pet survival.
    --
    -- Head NOT swapped here intentionally: swapping Azimuth Hood +2 (Geomancy skill +20)
    -- for Bagua Galero +2 (Luopan HP+500) would add 500 max HP to the luopan but cost
    -- 20 Geomancy skill, weakening Geo-* aura potency for the luopan's life. Kept Hood +2
    -- for aura strength. If running content where the luopan dies regularly, swap to:
    --   head = "Bagua Galero +2"   -- Luopan HP+500 at placement; aura weaker
    sets.midcast.Geomancy.Geo = set_combine(sets.midcast.Geomancy, {
        feet = "Bagua Sandals +3",
    })

    -- =============================================================================
    -- IDLE
    -- =============================================================================
    -- Base idle uses gear you currently own (verified against /gs export 2026-05-13).
    -- TODO upgrades are noted in comments; they don't replace slot values until acquired.
    sets.idle = {
        main  = "Solstice",
        sub   = "Genbu's Shield",           -- has — lvl 74 sub, PDT-10%. Upgrade target: Genmei Shield (Genbu, Escha Ru'Aun Geas Fete) for the same -10% PDT at item lvl 119.
        range = "Dunna",                    -- has R15 — locked. On GEO the ammo slot collides with range, so
                                            --   we never define ammo in any set. Homiliary (Limbus, Refresh+1)
                                            --   would be a tempting idle ammo BUT it would kick Dunna out.
        head  = "Azimuth Hood +2",          -- has — Geomancy skill+20, Full Circle+3, DT-11%, Luopan Regen+4, Haste+6%, Azimuth set bonus (activates with 2+ Empyrean +2 pieces — now triggers with Coat +2 + Hood +2)
        body  = "Shamash Robe",             -- has — Refresh+3, PDT-10%, MAB+45, Resist Silence+90
        hands = "Azimuth Gloves +2",        -- has — DT-11%, Enfeebling skill+23, Haste+3%, MAB+47, MAcc+52, Enmity-12 (replaces Bagua Mitaines +2 for support-survival framing; loses Refresh+1, gains DT-11%)
        legs  = "Bagua Pants +2",           -- has — Indicolure dur+18, MAB+44, Haste+5%
        feet  = "Azimuth Gaiters +2",       -- has — DT-10% for player survival (was Sandals +3 for Luopan Regen+5; swapped 2026-05-17 per support-survival framing). Sandals +3 still equips in `sets.idle.Pet` for pet survival when luopan is out.
        neck  = "Bagua Charm +2",           -- has (Path A: MP+50, Luopan Dur+25%, Luopan Absorbs DT+10%). TODO upgrade: Loricate Torque +1 for DT-6%.
        waist = "Embla Sash",               -- has — Sublimation+3, FC+5%, Enh.Mag dur+10%. TODO: Carrier's Sash for resist utility.
        left_ear  = "Odnowa Earring",       -- has — HP+100 (from MP convert), VIT+2, STR+2, MDT-1%. Idle-DT pick over Loquac. (FC doesn't apply at idle).
        right_ear = "Alabaster Earring",    -- has — DEF+10, HP+100, Haste+5%, DT-5%, Pet:Acc/RAcc/MAcc+15. Biggest single DT earring you own.
        left_ring  = "Stikini Ring +1",     -- has — MND+8, MAcc+11, All Magic Skills+8, Refresh+1
        right_ring = "Stikini Ring +1",     -- TODO: verify if you own a 2nd Stikini Ring +1. If not, use a placeholder ring you own. KEY UPGRADE: Defending Ring (Sovereign Behemoth) for DT-10%.
        back  = Nantosuelta_Solo,
    }
    -- =========================================================================
    -- PDT idle — MAXIMIZE PLAYER DT, PERIOD.
    -- This is the "I'm in content that can kill me, big AoEs incoming" stance.
    -- User explicitly toggles to PDT only when survival > everything else.
    -- Pet survival is NOT a consideration here — sets.idle.PDT.Pet aliases to this set.
    -- =========================================================================
    -- Slot-by-slot DT comparison (Empyrean vs Nyame) — pick whichever is higher per slot:
    --   head: Hood +2 (DT-11%) > Nyame Helm (DT-7%)            → KEEP base idle's Hood +2
    --   body: Shamash Robe (PDT-10%, physical only) < Nyame Mail (DT-9% mixed) → OVERRIDE to Nyame Mail
    --   hands: Gloves +2 (DT-11%) > Nyame Gauntlets (DT-7%)    → KEEP base idle's Gloves +2
    --   legs: Bagua Pants +2 (0% DT) < Nyame Flanchard (DT-8%) → OVERRIDE to Nyame Flanchard
    --   feet: Gaiters +2 (DT-10%) > Nyame Sollerets (DT-7%)    → KEEP base idle's Gaiters +2
    --
    -- Full DT accounting across ALL inherited slots:
    --   Generic DT: Hood 11 + Mail 9 + Gloves 11 + Flanchard 8 + Gaiters 10 + Alabaster Earring 5
    --             = 54% raw → CAPPED at -50% generic DT. The extra 4% is wasted.
    --             Once you have Defending Ring (DT-10%) or Loricate Torque +1 (DT-6%), the cap
    --             gives slack to swap a current generic DT piece for utility (e.g., Alabaster → Magnetic
    --             Earring for SIRD-8%, or drop a Nyame slot for an Empyrean Refresh body).
    --   PDT-only:   Genbu's Shield -10% (stacks ON TOP of the generic cap for physical damage)
    --   MDT-only:   Odnowa Earring -1% (negligible; main MDT upgrade target is Etiolation Earring -3% MDT)
    --
    -- Effective damage reduction in this set:
    --   Physical: -50% generic + -10% PDT = ~-60% combined
    --   Magical:  -50% generic + -1% MDT  = ~-51% combined
    --
    -- Empyrean set bonus: Hood +2 + Gloves +2 + Gaiters +2 = 3 pieces in PDT idle
    -- → "Occ. casts geomancy spells without using MP" at +3% chance (was +2% before Gloves +2).
    --
    -- Empyrean set bonus active (Hood +2 + Gaiters +2 = 2 pieces, "Occ. casts geomancy spells
    -- without using MP" at +2% chance).
    --
    -- DT-cap upgrade path (these don't add DT past the cap but FREE UP non-DT pieces for utility):
    --   • Defending Ring (DT-10%) — Sovereign Behemoth — frees up an Alabaster Earring slot for utility
    --   • Loricate Torque +1 (DT-6%) — Sovereign Behemoth / Unity — frees up Bagua Charm slot
    --   • Etiolation Earring (MDT-3%) — Vagary — real MDT upgrade (we're under MDT cap)
    --   • Adamantite Armor (DT-20%) — Limbus — frees up Nyame Mail slot (Coat +2's set bonus + Refresh+3 could go here instead)
    sets.idle.PDT = set_combine(sets.idle, {
        body  = "Nyame Mail",       -- DT-9% mixed (replaces Shamash Robe's PDT-10% physical-only)
        legs  = "Nyame Flanchard",  -- DT-8%
        -- hands intentionally NOT overridden: base idle's Azimuth Gloves +2 (DT-11%) wins over Nyame Gauntlets (DT-7%)
    })
    -- (Previously had an empty sets.idle.Town here. Removed because Mote's idle walk is
    --  sets.idle → [scope: Weak/Town/Field] → [IdleMode] → .Pet → CustomIdleGroups.
    --  An empty .Town sub-table swallowed the .PDT lookup when standing in cities, so
    --  IdleMode=PDT did nothing in town. Without .Town defined, Mote skips the scope tier
    --  and goes straight to sets.idle.PDT, which is what we want.)

    -- Pet overlay (luopan summoned). Mote auto-layers this when pet.isvalid is true.
    -- Pet survival philosophy: stack Luopan: HP / Luopan: DT / Luopan: Regen / Pet: Regen.
    -- Your verified pet-survival pieces:
    --   Bagua Galero +2 head  : Luopan HP+500             (BIG max-HP boost — keeps Mending Halation/Radial Arcana strong)
    --   Geomancy Mitaines +3 hands: Luopan: Damage Taken -13% + PDT-3% (KEY pet DT reduction; biggest single pet-survival piece in the game)
    --   Azimuth Hood +2 head  : Luopan: Regen+4 + Set Bonus MP-on-Geo (alt head if you'd rather have GEO MP refund — but Galero +2's HP+500 wins for spike survival)
    --   Bagua Sandals +3 feet : Luopan: Regen+5           (explicit override in sets.idle.Pet; base idle uses Azimuth Gaiters +2 for player DT-10%)
    --   Nantosuelta (your cape augments): Pet: Regen+15 total (already in base idle; stays)
    --   Bagua Charm +2 (Oboro Path A augment) : Luopan: Absorbs DT+10% (TODO: you'd need to augment via Oboro)
    sets.idle.Pet = set_combine(sets.idle, {
        head  = "Bagua Galero +2",          -- Luopan HP+500 (overrides Azimuth Hood +2 — Galero's raw HP wins spike survival vs Hood's Luopan Regen+4)
        hands = "Geomancy Mitaines +3",     -- Luopan: Damage Taken -13% + PDT-3% (overrides Azimuth Gloves +2 — pet idle prioritizes pet DT over player DT; +3 also adds small player PDT)
        feet  = "Bagua Sandals +3",         -- Luopan Regen+5 (overrides base idle's Gaiters +2 — pet idle prioritizes pet survival over player DT)
        back  = Nantosuelta_Pet,            -- Pet:Regen+15 total (overrides Solo cape's PDT-10% — luopan-out idle wants max pet regen)
        -- body, legs, neck, rings: stays as base idle (no GEO-equippable pet upgrades known)
    })
    -- PDT mode with pet out: inherits sets.idle.PDT's Nyame body/legs (player DT priority) but
    -- swaps the cape back to Nantosuelta_Pet for max luopan regen. Rationale: pet body/legs
    -- pieces (Galero/Geo.Mitaines/Sandals) don't contribute to player DT so we keep them out
    -- of PDT mode, but the cape's Pet:Regen+5 vs PDT-10% trade is per-rule: luopan out = Pet cape.
    -- (For pet-survival idle without the player-DT compromise, stay IdleMode=Normal with luopan
    -- out → sets.idle.Pet handles full pet-stack.)
    sets.idle.PDT.Pet = set_combine(sets.idle.PDT, { back = Nantosuelta_Pet })

    -- Indi-active overlay: job_aftercast appends 'Indi' to classes.CustomIdleGroups when an Indi-* spell lands.
    -- Mote's get_idle_set walks down into sets.idle[...].Indi if that tier exists. Currently we have no Indi-
    -- specific idle gear, so we DON'T define sets.idle.Indi / sets.idle.Pet.Indi / sets.idle.PDT.Pet.Indi —
    -- Mote skips missing tiers and keeps the parent set. If you ever get Indi-specific idle pieces (e.g., a
    -- Colure-Active-aware Refresh body), define them like:
    --   sets.idle.Pet.Indi = set_combine(sets.idle.Pet, { neck = "Some Indi-bonus Neck" })

    -- =============================================================================
    -- ENGAGED — aliased to idle until a real TP set is built.
    -- =============================================================================
    -- GEO rarely melees. Until you commit to a weapon path (Black Halo club / Naegling sword / etc.),
    -- engaged mirrors idle so you keep player DT, Refresh, and Haste while swinging.
    -- Table alias: sets.engaged IS sets.idle (so .Pet / .Indi sub-tables inherit too).
    -- TODO: when you start meleeing regularly, build a real TP set (Haste cap + STP + Acc).
    sets.engaged     = sets.idle
    sets.engaged.PDT = sets.idle.PDT

    -- =============================================================================
    -- DEFENSE / TOGGLES
    -- =============================================================================
    sets.defense.PDT = sets.idle.PDT
    sets.defense.MDT = sets.idle.PDT

    -- Interim Kiting setup: Geo. Sandals +1 still only give +12% movement (same as base AF —
    -- the +1 upgrade bumps defensive stats but NOT movement speed). Movement bump comes at +3
    -- (+18% from the boots alone). Until then, Shneddick Ring (+18%) fills the gap.
    sets.Kiting       = {
        feet       = "Geo. Sandals +1",   -- has — Movement speed +12% + Haste+3%, GEO-only.
                                          -- +1 vs base: same move speed, but better defensive stats.
                                          -- KEY UPGRADE: Geomancy Sandals +3 (Movement speed +18%, RP path).
                                          -- After +3: drop Shneddick from this set, it's redundant.
        left_ring  = "Shneddick Ring",    -- has — Movement speed +18%, Resist Petrify/Bind/Gravity +15 each.
                                          -- Filling the gap until boots reach +3.
        right_ring = "Warp Ring",         -- has — No passive stats, but the Warp enchantment is the
                                          -- "oh no" escape button.
    }
    sets.CP           = { back = "Mecisto. Mantle"    }  -- has — CP cape overlay
    sets.TreasureHunter = {}                              -- TODO: Merlinic Dastanas w/ TH+2 augment
end


-------------------------------------------------------------------------------------------------------------------
-- Hook functions for job-specific events.
-------------------------------------------------------------------------------------------------------------------

-- Tell Mote that Indi-*/Geo-* spells use the 'Indi'/'Geo' spellMaps so
-- sets.midcast.Geomancy.Indi / sets.midcast.Geomancy.Geo resolve.
function job_get_spell_map(spell, default_spell_map)
    if spell.english:startswith('Indi-') then
        return 'Indi'
    elseif spell.english:startswith('Geo-') then
        return 'Geo'
    end
    return default_spell_map
end


function job_precast(spell, action, spellMap, eventArgs)
    -- Bolster guard: BoG / Ecliptic Attrition are wasted under Bolster (aura at cap)
    if (spell.english == 'Blaze of Glory' or spell.english == 'Ecliptic Attrition') and buffactive.Bolster then
        add_to_chat(123, '[GEO] ' .. spell.english .. ' is wasted under Bolster — cancelling.')
        eventArgs.cancel = true
        return
    end

    -- Auto Full Circle: recasting Geo-* while a luopan is on the field → dismiss first, then cast.
    if state.AutoFullCircle.value and spell.action_type == 'Magic'
       and spell.english:startswith('Geo-') and pet.isvalid then
        local recasts = windower.ffxi.get_ability_recasts()
        local full_circle_id = 246  -- Full Circle JA id
        if recasts[full_circle_id] and recasts[full_circle_id] < 1 then
            cancel_spell()
            send_command('input /ja "Full Circle" <me>; wait 1.3; input /ma "' .. spell.english .. '" <bt>')
            eventArgs.cancel = true
        end
    end
end


function job_midcast(spell, action, spellMap, eventArgs)
    -- Day / weather waist swap for cures (Lightsday or Light weather boost)
    if spellMap == 'Cure' or spellMap == 'Curaga' then
        if world.day_element == 'Light' or world.weather_element == 'Light' then
            equip({ waist = 'Hachirin-no-Obi' })  -- gearswap will warn if not owned; remove the line if so
        end
    end
    -- Day / weather waist swap for matching-element nukes / divine / helix
    if spell.skill == 'Elemental Magic' and spell.element then
        if world.day_element == spell.element or world.weather_element == spell.element then
            equip({ waist = 'Hachirin-no-Obi' })
        end
    end
end


function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.interrupted then return end

    if spell.english:startswith('Indi-') then
        last_indi = spell.english:sub(6)
        -- Activate Indi overlay on idle. Mote walks classes.CustomIdleGroups in get_idle_set.
        if not classes.CustomIdleGroups:contains('Indi') then
            classes.CustomIdleGroups:append('Indi')
        end
        -- Timer notification (Windower 'timers' addon required)
        send_command('timers delete "' .. spell.english .. '"')
        send_command('timers create "' .. spell.english .. '" 180 down')
        update_hud()
    elseif spell.english:startswith('Geo-') then
        last_geo = spell.english:sub(5)
        -- Luopan timer (no fixed duration — runs until killed / Full Circle)
        send_command('timers delete "Luopan: Geo-' .. last_geo .. '"')
        update_hud()
    end
end


function job_buff_change(buff, gain)
    -- Colure Active falls off → clear Indi overlay so idle reverts to base
    if buff == 'Colure Active' and not gain then
        -- Windower's list:remove() takes an INDEX, not a value. Find the 'Indi' index first.
        for i, v in ipairs(classes.CustomIdleGroups) do
            if v == 'Indi' then
                classes.CustomIdleGroups:remove(i)
                handle_equipping_gear(player.status)
                break
            end
        end
        last_indi = nil
        update_hud()
    end
end


function job_pet_change(petParam, gain)
    if not gain and last_geo then
        send_command('timers delete "Luopan: Geo-' .. last_geo .. '"')
        last_geo = nil
        update_hud()
    end
end


function customize_idle_set(idleSet)
    if state.CP.value then
        idleSet = set_combine(idleSet, sets.CP)
    end
    return idleSet
end


function customize_melee_set(meleeSet)
    if state.CP.value then
        meleeSet = set_combine(meleeSet, sets.CP)
    end
    return meleeSet
end


function job_self_command(cmdParams, eventArgs)
    local cmd = (cmdParams[1] or ''):lower()
    if cmd == 'autofullcircle' or cmd == 'afc' then
        state.AutoFullCircle:toggle()
        add_to_chat(122, '[GEO] AutoFullCircle: ' .. (state.AutoFullCircle.value and 'ON' or 'OFF'))
        update_hud()
        eventArgs.handled = true
    elseif cmd == 'hud' then
        local sub = (cmdParams[2] or 'toggle'):lower()
        if hud then
            if sub == 'show' then
                hud:show()
            elseif sub == 'hide' then
                hud:hide()
            elseif sub == 'toggle' then
                if hud:visible() then hud:hide() else hud:show() end
            elseif sub == 'where' then
                -- gs c hud where  — print the current rendered position (reflects mouse drags)
                local x, y = windower.text.get_location(hud._name)
                add_to_chat(122, string.format('[GEO] HUD is at (%d, %d). Run "gs c hud save" to persist.', x, y))
            elseif sub == 'save' then
                -- gs c hud save  — capture the current rendered position (post-drag) and persist it
                local x, y = windower.text.get_location(hud._name)
                save_hud_pos(x, y)
                add_to_chat(122, string.format('[GEO] Saved current HUD position (%d, %d) — will load here next time.', x, y))
            elseif sub == 'pos' then
                -- gs c hud pos <x> <y>  — move HUD to absolute coordinates AND persist
                local x, y = tonumber(cmdParams[3]), tonumber(cmdParams[4])
                if x and y then
                    hud:pos(x, y)
                    save_hud_pos(x, y)
                    add_to_chat(122, string.format('[GEO] HUD moved to (%d, %d) and saved.', x, y))
                else
                    add_to_chat(123, '[GEO] Usage: gs c hud pos <x> <y>')
                end
            end
        end
        eventArgs.handled = true
    end
end
