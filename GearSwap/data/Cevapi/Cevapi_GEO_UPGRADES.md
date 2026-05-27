# Cevapi GEO — Upgrade Roadmap

All stats below are **verified against BGWiki**. Items I cannot fully verify (typically because BGWiki doesn't expose augment tables on the standard item page) are flagged `(unverified)`.

The first half of this document is **priority-ordered**: do these first. The second half organizes the same items **by set** so you can see what every set's upgrade path looks like.

---

## Tier 1 — Highest impact, accessible-ish (do these first)

These are the upgrades that change *the most slots in the most sets* per unit of acquisition effort. Roughly in order of bang-for-buck.

### 1. Genmei Shield
- **Source**: Genbu, Escha Ru'Aun via Geas Fete (`Genbu's Honor` KI). Also Kupon AW-GFIII or AW-GeIV.
- **Stats**: DEF:114, Acc+15, Att+15, Shield skill +112, "Counter"+4, Block chance +6, **Physical Damage Taken -10%**
- **Goes into**: Sub-slot of *every* one-handed-wand set — Cure, Enhancing, Enfeebling, Geomancy, Idle, Defense. Massive PDT for one upgrade slot.
- **Why now**: Mage shield with -10% PDT is the single biggest defensive upgrade you can hand off across every set.
- **Current interim**: You're using **Genbu's Shield** (lvl 74, GEO-equippable, also PDT-10%) in every sub slot until Genmei drops. Genbu's gives the same -10% PDT — the upgrade to Genmei is mostly DEF/Shield-skill/level, not a PDT delta. Genbu's also supports Tatter/Scrap Synergy augments (Cure pot 1-5%, Cure cast 1-8%, MAcc 1-6, HP 6-25, MP 4-32) — worth augmenting if you can.

### 2. Geomancy Pants +3 (Reforged AF, Coelestrox)
- **Source**: Ethereal Ingress #10, Coelestrox NPC. Trade Geomancy Pants +2 + RP materials (P. GEO Cards + Kyou's Scale + Cypress + Cyan Orbs).
- **Stats**: DEF:129, MAcc+49, Haste+5%, **Fast Cast +15%**, **Spell Interruption Rate -24%**
- **Goes into**: `sets.precast.FC` (replaces Vanya Slops unaugmented). **Single biggest precast upgrade in the game for GEO.**
- **Why now**: +15% FC on one piece moves your FC pool from 35% to 50%, plus -24% SIR makes you nearly uninterruptible.

### 3. Defending Ring
- **Source**: Sovereign Behemoth (Behemoth's Dominion) or King Behemoth — rare drop. Also Mog Bonanza Rank 1.
- **Stats**: **Damage Taken -10%** (specifically 26/256).
- **Goes into**: `sets.idle` (replaces Stikini Ring +1 in ring2), `sets.idle.PDT`, `sets.defense.PDT`, `sets.defense.MDT`.
- **Why now**: Best generic DT ring in the game; goes into every defensive set. Critical for Sortie, Omen, Dynamis-D content.

### 4. Loricate Torque +1
- **Source**: Sovereign Behemoth drop, OR Unity NPC upgrade of base Loricate Torque, OR Kupon AW-UWIII.
- **Stats**: **Damage Taken -6%** (15/256). Unity Rank 15 augments add DEF+45 and Spell Interruption -5%.
- **Goes into**: `sets.idle` (replaces Bagua Charm +2 placeholder in neck), `sets.idle.PDT`, `sets.defense.*`.
- **Why now**: Best generic DT neck for mage. Stacks with Defending Ring and Genmei Shield.

### 5. Geomancy Mitaines +3 (Reforged AF, Coelestrox)
- **Source**: Same as Geomancy Pants +3 (RP path).
- **Stats**: DEF:105, MAcc+48, Geomancy skill +19, Haste+3%, **Luopan: Damage Taken -13%**, PDT-3%
- **Goes into**: `sets.idle.Pet` (replaces Geo. Mitaines +1's Luopan DT-11%). Also `sets.midcast.Geomancy` for the +19 skill.
- **Why now**: 13% Luopan DT extends luopan survival dramatically; Mending Halation and Radial Arcana need a high-HP luopan to be strong.

### 6. Geomancy Sandals +3 (Reforged AF, Coelestrox)
- **Source**: RP path.
- **Stats**: DEF:87, MAcc+46, Haste+3%, **Movement Speed +18%**
- **Goes into**: `sets.Kiting` (replaces base AF Geomancy Sandals' +12%).
- **Why now**: Six-percentage-point upgrade for movement; huge in Omen / Sortie / kiting mechanics.

### 7. Witful Belt
- **Source**: Voidwatch (East Sarutabaruta — Rw Nw Prt M Hrw boss in a Riftworn Pyxis).
- **Stats**: DEF:8, Enhances Fast Cast (+3%), Haste+3%, **Occ. quickens spellcasting +3%**
- **Goes into**: `sets.precast.FC` waist (replaces Embla Sash).
- **Why now**: Embla Sash gives +5% FC already so the swap is +3 vs +5 FC at the waist — actually a slight FC DOWNGRADE in raw FC. **Skip until you also need Quick Magic uptime.** Note: Embla Sash + Quick Magic from Witful is the long-term setup for Sublimation-uptime SCH/mage casting; for GEO specifically Embla wins.

### 8. Voltsurge Torque
- **Source**: Cloister of Storms (Avatar Prime II battle with Phantom Gem). Also Kupon AW-Mis.
- **Stats**: MP+20, Acc+5, MAcc+7, **Fast Cast +4%**
- **Goes into**: `sets.precast.FC` neck (currently placeholder).
- **Why now**: Cheap +4% FC piece. Replace once acquired.

### 9. Kishar Ring
- **Source**: Reisenjima Henge Omen (Glassy Gorger, 3rd floor, 15% drop). Also Kupon AW-Om.
- **Stats**: MAcc+5, **Fast Cast +4%**, Enfeebling magic duration +10%, "Absorb" duration +10%
- **Goes into**: `sets.precast.FC` ring1, `sets.midcast['Enfeebling Magic']` for the +10% duration.
- **Why now**: Dual-purpose FC + Enfeeb duration ring.

### 10. Etiolation Earring
- **Source**: Vagary (Perfidien in Outer Ra'Kaznar [U] BCNM, Uncommon drop) or `Kupon AW-Vgr` trade or random reward from turning in all 5 Vagary key items.
- **Stats**: HP+50, MP+50, **Fast Cast +1%**, Magic Damage Taken -3%, Resist Silence+15
- **Goes into**: `sets.precast.FC` ear2 (currently placeholder).
- **Why now**: +1% FC and MDT-3% utility. Vagary is fairly accessible content.

---

## Tier 2 — Medium impact / medium effort

### 11. Bagua Mitaines +3 (Reforged Relic, Aurix)
- **Source**: Aurix NPC, Ru'Lude Gardens G-8. Trade Bagua Mitaines +2 + RP materials (shards/voidshards/Hades' Claw/Plovid Flesh/Tartarian Soul).
- **Stats**: DEF:104, MAcc+38, MAB+50, Haste+3%, Enmity-8, **Magic Burst damage +12**, **Refresh+2**, **Elemental magic casting time -14%**
- **Goes into**: `sets.midcast['Elemental Magic']` and `.Burst` hands (replaces Bagua Mitaines +2's MAB+43/MBD+8), and `sets.idle` hands (replaces +2's Refresh+1).
- **Why**: +12 MBD vs +8 on the +2 = +4 MBD on burst; +2 Refresh in idle.

### 12. Lifestream Cape
- **Source**: Reisenjima Synergy craft (GEO-only cape).
- **Stats**: DEF:13, HP+50, MP+50, Enfeebling skill+10, **Geomancy skill +5**, **Fast Cast +7%**
- **Goes into**: A *second* back-slot dedicated to `sets.midcast.Geomancy.Indi` (Indi precast/cast back) — your one Nantosuelta cape is pet-focused so Lifestream covers the Indi side.
- **Why**: GEO-only cape with FC+7% and Geomancy skill — strictly better than Nantosuelta for Indi/Geo casting.

### 13. Azimuth Hood +3 (Reforged Empyrean, Ruspix)
- **Source**: Ruspix NPC, Leafallia H-8. **70,000 Gallimaufry + 1 Ra'Kaz. Starstone** per +3 piece, traded with the +2 piece.
- **Stats**: DEF:128, MAcc+61, MAB+51, MDmg+31, **Geomancy skill +25**, Haste+6%, **Full Circle +4**, **DT -12%**, Luopan Regen+5
- **Goes into**: `sets.midcast.Geomancy` head (replaces Azimuth Hood +1), `sets.precast.JA["Full Circle"]`.
- **Why**: +25 Geomancy skill is enormous for indi/geo potency. Full Circle +4 maxes MP recovery. DT-12% adds defensive overlap.

### 14. Bagua Pants +3 (Reforged Relic, Aurix)
- **Source**: RP path.
- **Stats**: DEF:128, MAcc+39, MAB+51, Haste+5%, **Indicolure spell duration +21**
- **Goes into**: `sets.midcast.Geomancy.Indi` legs (replaces Bagua Pants +2's +18 Indi duration). Also `sets.precast.JA["Mending Halation"]`.
- **Why**: +3 Indi duration vs +2 base. Stacks with other Indi-duration sources for longer auras.

### 15. Azimuth Coat +3 (Reforged Empyrean, Ruspix)
- **Source**: RP path.
- **Stats**: DEF:158, MAcc+64, MAB+59, MDmg+34, **Elemental skill +28**, Haste+3%, Enmity-10, **Magic Burst dmg II +5**, **Refresh+4**
- **Goes into**: `sets.midcast['Elemental Magic']` and `.Burst` body, `sets.idle` body (replaces Shamash Robe in burst mode), `sets.midcast.Refresh`.
- **Why**: Rare GEO source of **Magic Burst Damage II** (+5%, on top of MBD I). Refresh+4 also makes it competitive idle body.

### 16. Azimuth Tights +3 (Reforged Empyrean, Ruspix)
- **Source**: RP path.
- **Stats**: DEF:138, MAcc+63, MAB+58, MDmg+33, Dark skill+30, Haste+5%, **Magic Burst damage +15**
- **Goes into**: `sets.midcast['Elemental Magic'].Burst` legs (currently the +2 — Nyame Flanchard already displaced).
- **Why**: +15 MBD I vs +10 on +2 = +5 MBD on burst; +5 MAB, +10 MDmg, +5 Dark skill, +10 MAcc.
- **Current**: **Azimuth Tights +2 acquired 2026-05-18** and slotted in nuke / nuke.Resistant / Burst / Enfeebling Magic. Path forward = +3 RP upgrade.

### 17. Bagua Tunic +3 (Reforged Relic, Aurix)
- **Source**: RP path. You now own **Bagua Tunic +2** (DEF:139, MAcc+30, MAB+56, Geomancy skill+14, Haste+3%, Enhances Bolster: +30s duration) — already slotted in `sets.midcast.Geomancy` and `sets.precast.JA["Bolster"]`.
- **Stats (+3)**: DEF:149, MAcc+40, MAB+63, **Geomancy skill +16**, Haste+3%, Enhances Bolster (longer duration than +2).
- **Goes into**: `sets.midcast.Geomancy` body, `sets.precast.JA["Bolster"]`. Replaces the +2 once RP'd.
- **Why**: +2 Geomancy skill over +2 (+16 vs +14), +7 MAB, +10 MAcc, and a longer Bolster window. Marginal vs the +2 you just finished — lowest-priority Bagua +3 next to Mitaines and Pants.

### 18. Sors Shield
- **Source**: Brothers D'Aurphe II BC (Qu'Bia Arena, Macrocosmic Orb).
- **Stats**: DEF:30, HP+10, MP+54, Shield skill+48, Enmity-5, **Cure potency +3%**, **Cure cast time -5%**
- **Goes into**: `sets.midcast.Cure` and `sets.precast.FC.Cure` sub-slot.
- **Why**: Stacks cure potency on top of Vanya Hood's +10%; cure cast time -5% stacks with Vanya Cuffs Path B's -7%.

### 19. ~~Bagua Charm +2 Oboro Path A~~ — **DONE** (confirmed via /gs export 2026-05-13)
- Your Bagua Charm +2 already has Path A augment: MP+50 / Luopan Duration +25% / Luopan: Absorbs DT +10%.
- Already contributing to your `sets.idle.Pet` neck slot.

### 20. Mendi. Earring stays, but Sanare ≠ cure piece
- **Source**: N/A — context note. Sanare Earring is in many GEO guides but its actual stat block is MEva+6 / MDB+4 / Club skill+5 — it has **NO** cure cast time reduction (I had it wrong earlier). Skip Sanare in your cure pursuit.
- Use **Mendi. Earring** (you own; Cure pot +5% / Cure cast -5%) in the Cure earring slot until you can do better.

---

## Tier 3 — Endgame / long-term

### 21. Idris (Mythic Weapon)
- **Source**: Mythic Weapon questline. ~3000 Alexandrite + Voidstones + Plovids over months/years.
- **Stats** (Level 119 III): DMG:175, Delay:280, MAcc+40, MAB+40, MDmg+217, Macc skill+255, **Geomancy +10**, **Luopan: Damage Taken -25%**, Exudation Aftermath (boosts MAcc/MAB, occ. 2x/3x).
- **Goes into**: Mainhand of every magic set. The Luopan DT-25% replaces 1/4 of all damage your luopan takes — irreplaceable.
- **Note**: Until Idris, **Solstice Path D** is fine. Skip Idris unless committed to the multi-month grind.

### 22. ~~Daybreak (Aeonic Club)~~ — **DONE** (acquired 2026-05-20)
- **Source**: Reisenjima Aeonic weapon trial (Reisenjima BCNMs).
- **Stats (BGWiki-verified 2026-05-20)**: DMG:150, Delay:216, MP+60, MND+30, MAcc+40, MAB+40, **Magic Damage+241**, Magic Evasion+30, Club/Parrying skill +228, Magic Accuracy skill +242, **Cure potency +30%**, Refresh+1, Light damage+50 (melee), main hand grants **Dispelga**.
- **Slotted in**: `sets.midcast.Cure` (Curaga + Cursna inherit), `sets.midcast.Refresh`, `sets.midcast['Enfeebling Magic']` (Dark Magic / Drain / Aspir / Stun inherit), `sets.midcast['Elemental Magic']` (Helix inherits, Burst inherits via set_combine).
- **NOT slotted in**: `sets.midcast.Geomancy` / `.Indi` — Solstice has **Handbell skill+5** (boosts Geo-* damage and Indi-* potency) and **Indicolure spell duration+15** as base stats; Daybreak has neither. Both are GEO-essential and not findable on any other club, so Solstice stays here regardless of Daybreak's raw MD/MAB/MAcc lead. `sets.idle` / `.Pet` / `.PDT` / `.PDT.Pet` (Solstice Path D's Pet:DT-4% is critical for luopan survival at idle). `sets.engaged` (aliases idle). `sets.precast.WS` (user not focused on WS).
- **Note**: Pairs with Genmei Shield for the +30% Cure potency mage mainhand setup. Maxentius (Ambuscade) remains the BiS Burst club for the per-skillchain MB Bonus — Daybreak fills Burst until Maxentius.

### 23. Maxentius (Ambuscade Club)
- **Source**: Ambuscade — high-tier reward (~10,000+ Hallmarks).
- **Stats**: DMG:200, Delay:288, INT+15, MND+15, CHR+15, Acc+40, MAcc+40, MAB+21, Club+250, Macc skill+250, **grants Black Halo WS**, **Magic Burst Bonus +4% per skillchain step (caps at +40%)**.
- **Goes into**: `sets.midcast['Elemental Magic'].Burst` mainhand, plus `sets.precast.WS` if you decide to Black Halo.
- **Note**: Genuinely competes with Idris for Magic Burst club. +40% MB bonus in long skillchains is huge.

### 24. Ammurapi Shield (Sortie BCNM)
- **Source**: Kei in Reisenjima Henge Omen.
- **Stats**: DEF:94, HP+22, MP+58, INT+13, MND+13, **MAcc+38**, **MAB+38**, Shield skill+107, Enhancing magic duration+10%
- **Goes into**: Sub-slot of `sets.midcast['Elemental Magic']`, `.Burst`, `.Resistant`, `sets.midcast['Enfeebling Magic']`.
- **Why**: Highest MAB/MAcc shield available, GEO-equippable. Genmei Shield wins for PDT idle, Ammurapi wins for nuke/enfeeb damage.

### 25. Acuity Belt +1 (Sortie)
- **Source**: Sheol A "Joyous Green" NM, after 30k Unity accolades trade for Acuity Belt + Sheol Stone of Approbation.
- **Stats**: Base MP+35, INT+6. Unity Rank 15 adds MAcc+15, INT+10.
- **Goes into**: `sets.midcast['Elemental Magic']` waist (alternative to Embla Sash when MAcc matters more than FC carry-over).

### 26. Ea +1 set (Smithing Synthesis, top-tier GEO MB gear)
- **Source**: Smithing 115–120 + Clothcraft, Blacksmith's argentum tome key item required.
- **Stats**: Every piece has **both Magic Burst Damage I AND II**:
  - **Ea Hat +1**: MAB+38, MBD I+7, MBD II+7, Haste+6%
  - **Ea Houppe. +1**: MAB+44, MBD I+9, MBD II+9, Haste+3%
  - **Ea Cuffs +1**: MAB+35, MBD I+6, MBD II+6
  - **Ea Slops +1**: MAB+41, MBD I+8, MBD II+8, Haste+5%
  - **Ea Pigaches +1**: MAB+32, MBD I+5, MBD II+5
- **Goes into**: `sets.midcast['Elemental Magic'].Burst`. This is GEO's only path to filling MBD II from armor (Mall. Chapeau / Cuffs / Clogs +2 do NOT have MBD II despite community lore).
- **Note**: Body and Legs are BiS-tier. Hat/Cuffs/Pigaches are good but compete with Nyame for MBD I + Skillchain Bonus combos.

### 27. Phalaina Locket
- **Source**: Bismarck (Voidwatch), or Bibiki Bay 5% Pyxis drop.
- **Stats**: MND+3, **Cure potency +4%**, **Potency of Cure effect received +4%**.
- **Goes into**: `sets.midcast.Cure` neck (replaces Bagua Charm +2 placeholder).
- **Note**: Small but real Cure potency neck for GEO since Sacro Gorget is PLD/RUN-locked.

### 28. Lebeche Ring
- **Source**: Avatar Prime II (Cloister of Gales). Phantom Gem trial.
- **Stats**: MP+40, Enmity-5, **Cure potency +3%**, **Quick Magic +2%**.
- **Goes into**: `sets.midcast.Cure` ring2 (currently 2nd Stikini Ring +1 TODO).

### 29. Witching Robe
- **Source**: Sinister Reign (Arciela boss).
- **Stats**: DEF:128, HP+50, MP+67, INT+35, MND+28, **MAB+25**, Haste+3%, Conserve MP+5, **Refresh+2**
- **Goes into**: alternative idle body (Shamash Robe with Refresh+3 + PDT-10% still wins overall, but Witching is a backup if Shamash is unavailable).

### 30. Amalric Coif
- **Source**: Venerian Abjuration trade.
- **Stats**: MAcc+26, Haste+6%, **Fast Cast +10%**, **Refresh potency +1**, Aquaveil+1.
- **Goes into**: `sets.precast.FC.Refresh` head and `sets.midcast.Aquaveil` head.
- **Note**: Big FC head; competes with Vanya Hood (Path D, +10% FC) — tied on FC%. Amalric wins on Refresh potency stack.

### 31. Lengo Pants
- **Source**: Sinister Reign (Arciela/Ygnas).
- **Stats**: DEF:105, HP+43, MP+29, INT+34, MND+24, MAB+20, Haste+5%, **Fast Cast +5%**, Conserve MP+5, **SIR-10%**.
- **Goes into**: `sets.precast.FC` legs (replaces Vanya Slops placeholder; obsoleted by Geomancy Pants +3 once you get there).

### 32. Merlinic Hood (augmented)
- **Source**: Reisenjima Geas Fete (Oseem augment NPC). Augments via Pellucid/Fern/Taupe/Dark Matter stones.
- **Stats**: DEF:95, MAcc+15, MAB+10, Haste+6%, **Fast Cast +8%** native, plus augments: MAB +1~40, MAcc +1~40, MDmg +1~15, FC +1~6 (Path F: +7).
- **Goes into**: `sets.midcast['Elemental Magic']` head when augmented for MAB+MAcc+MDmg; alternative FC head with native +8% + FC augment.

### 33. Merlinic Shalwar (augmented)
- **Source**: Same Oseem augment path.
- **Stats**: DEF:106, MAcc+20, MAB+15, MDmg+13, Haste+5%, Enmity-5; augments same pool as Hood.
- **Goes into**: `sets.midcast['Elemental Magic']` legs when augmented for MAB+MAcc+MDmg.

### 34. Adamantite Armor
- **Source**: Limbus (Apollyon / Temenos boss drop).
- **Stats**: DEF:200, HP+182, MP+118, **Damage Taken -20%**
- **Goes into**: alternative `sets.idle.PDT` body if you want more raw DT than Nyame Mail (-9%). Note: lacks Refresh/MAB so it's a pure DT body.

### 35. Magnetic Earring (you already own this)
- **Source**: Apocalypse Nigh mission reward.
- **Stats**: MP+20, Conserve MP+5, **Spell Interruption Rate -8%**.
- **Goes into**: future `sets.midcast.SIRD` set for casting under enemy fire.

---

## Items the agents proved I was wrong about (do NOT chase these)

| Item | What it actually does | Why I had it wrong |
|---|---|---|
| Sanare Earring | MEva+6, MDB+4, Club+5 | Community lore mislabels as cure-cast piece — it is not |
| Sanctity Necklace | HP/MP+35, Acc/MAcc/MAB/RAcc/RAtk+10, Regen+2 | Has Regen+2, not Refresh; no cure potency |
| Sacro Gorget | PLD/RUN only | I claimed GEO could equip — wrong |
| Bishop's Sash | Divine/Healing skill +5 only | No Cure potency at all |
| Beatific Earring | Divine/Healing skill +4 only | No Cure potency at all |
| Lugalbanda Earring | MEva+10, MAcc+15, Avatar/RAcc+15, BP dmg+10 | No Refresh — it's a MAcc earring |
| Hermes' Sandals | WAR/MNK/COR/PUP/RUN only | GEO cannot equip |
| Carmine Cuisses +1 | RDM/PLD/DRK/RNG/DRG/BLU/COR/RUN only | GEO blocked |
| Carmine Greaves +1 | Haste+4%, FC+8%, no movement speed | NOT a move speed piece; it's an FC piece |
| Skadi's Jambeaux +1 | THF/BST/RNG/COR/DNC/RUN only | GEO blocked |
| Tandava Crackows | DNC only | GEO blocked |
| Leyline Gloves | not on GEO equip list | GEO blocked |
| Atrophy Tights +3 | RDM only | GEO blocked |
| Inyanga +3 set | WHM/BRD/SMN only | NOT GEO's Reforged Empyrean — Azimuth is |
| Bunzi set | WHM/RDM/BRD/SMN only | NOT GEO's Sortie set |
| Roundel Earring | WHM/BLM/RDM/DRG/SMN/PUP/DNC/RUN only | GEO blocked |
| Cleric's Torque | WHM only | GEO blocked |
| Sucellos's Cape | RDM only | GEO blocked |
| Bookworm's Cape | SCH only | GEO blocked |
| Pixie Hairpin +1 | Dark MAB+28 | Dark nuke head, NOT a pet piece |
| Janniston Ring | Cure pot II +5%, Enmity-7 | A cure ring, NOT a pet ring (still useful for cures!) |
| Adamantite Armor | DT-20% generic body | NOT a pet HP body; it's a pure DT idle body |
| Naegling | not on GEO equip list | GEO blocked |
| Yamabuki-no-Obi | MP+35, INT+6, MAB+5 | Nuke waist, NOT a cure waist |
| Skrymir Cord | MAB+5, MAcc+5, MDmg+30 | Generic nuke waist, NOT a Magic Burst waist |
| Phillemot | does not exist on BGWiki | I invented this name |
| Hesychast's Roundel | does not exist (Hesychast is MNK AF) | I invented this name |
| Spike rings/bands for MBD II | only Mujin Band + Ea +1 set | Mall. Chapeau/Cuffs/Clogs +2 have NO MBD II despite my earlier claims — they have Elemental cast time -6% |

---

## By Set — what each set's upgrade chain looks like

### sets.precast.FC (Fast Cast precast)

| Slot | Current | Best upgrade | Total FC delta |
|---|---|---|---|
| main | Solstice (+5% FC) | (no upgrade) | — |
| sub | (placeholder) | Genmei Shield | 0 FC, +PDT-10% utility |
| ammo | Dunna R15 (+3% FC) | (no upgrade) | — |
| head | Vanya Hood (Path D, +10% FC) | Amalric Coif (FC+10%, +Refresh) | tied FC, +Refresh utility |
| body | Vanya Robe (Path C, no FC) | Anhur Robe (FC+10%) or Inyanga Jubbah (BLOCKED — WHM/BRD/SMN only) | +10% |
| hands | Vanya Cuffs (Path B; Cure cast -7%, no generic FC) | Geomancy Mitaines +3 (Path C augment may add FC; unverified) | TBD |
| legs | Vanya Slops base (0 FC) | **Geomancy Pants +3 (FC+15%)** | **+15%** |
| feet | Vanya Clogs (Path D, +10% FC) | Carmine Greaves +1 (FC+8%, less than Vanya) | downgrade — keep Vanya |
| neck | (placeholder) | Voltsurge Torque (+4% FC) | +4% |
| waist | Embla Sash (+5% FC) | (no clear upgrade) | — |
| ear1 | Loquacious Earring (+2% FC) | (no upgrade) | — |
| ear2 | (placeholder) | Etiolation Earring (+1% FC) | +1% |
| ring1 | (placeholder) | Kishar Ring (+4% FC) | +4% |
| ring2 | (placeholder) | Lebeche Ring (Cure pot, no FC) — wrong slot | move to Cure |
| back | Nantosuelta (0 FC, pet aug) | Lifestream Cape (+7% FC, +Geomancy) — for Indi only | +7% on Indi |

**Path**: Geomancy Pants +3 → Voltsurge Torque → Kishar Ring → Etiolation Earring → Genmei Shield → Lifestream Cape for Indi.

### sets.midcast.Cure (Cure midcast)

| Slot | Current | Best upgrade |
|---|---|---|
| main | **Daybreak** (Cure pot +30%, MND+30, MD+241, Refresh+1) — acquired 2026-05-20 | (no upgrade) |
| sub | (placeholder) | **Sors Shield** (Cure pot +3%, Cure cast -5%) |
| head | Vanya Hood (Path D — base Cure pot +10%) | Vanya Hood Path A would give +7% more Cure pot (re-augment via Reforging Trader) |
| body | Vanya Robe (Path C) | Vanya Robe Path A would add +7% Cure pot |
| hands | Vanya Cuffs (Path B — Healing+20, Cure cast -7%) | keep |
| legs | Vanya Slops base | Vanya Slops Path A (+7% Cure pot) |
| feet | Vanya Clogs (Path D) | Vanya Clogs Path A (+7% Cure pot) |
| neck | Bagua Charm +2 (placeholder) | **Phalaina Locket** (Cure pot +4%) |
| waist | Embla Sash | Hachirin-no-Obi on day/weather (auto-equipped by file's job_midcast) |
| ear1 | Mendi. Earring (Cure pot +5%, Cure cast -5%) | keep |
| ear2 | Loquacious (FC+2% for cure precast) | keep |
| ring1 | Stikini Ring +1 (Refresh+1, All Magic Skills +8) | keep |
| ring2 | Stikini Ring +1 placeholder | **Lebeche Ring** (Cure pot +3%, QM+2%) |
| back | Nantosuelta (no cure benefit) | a 2nd cape with Cure potency +10% augment (long-term) |

**Path**: Phalaina Locket → Lebeche Ring → Sors Shield → re-augment Vanya pieces to Path A → Daybreak.

### sets.midcast.Geomancy / .Indi (Indi & Geo midcast)

| Slot | Current | Best upgrade |
|---|---|---|
| main | Solstice | Idris (long-term mythic; Geomancy +10) |
| sub | (placeholder) | Genmei Shield |
| ammo | Dunna R15 | keep |
| head | Azimuth Hood +1 | **Azimuth Hood +3** (Geomancy +25 vs +15) |
| body | Bagua Tunic +2 (Geomancy +14, Bolster+30s) | **Bagua Tunic +3** (Geomancy +16, longer Bolster) |
| hands | Geo. Mitaines +1 | **Geomancy Mitaines +3** (Geomancy +19, Luopan DT -13%) |
| legs | Bagua Pants +2 | **Bagua Pants +3** (Indicolure dur +21) |
| feet | Azimuth Gaiters +1 | **Azimuth Gaiters +3** (Indicolure dur +30, DT-11%) |
| neck | Bagua Charm +2 base | Bagua Charm +2 with Oboro Path A (MP+50, Luopan Dur +25%, Luopan DT abs +10%) |
| waist | Embla Sash | (Olympus Sash is +Enhancing/+Elemental skill but smaller; Embla wins here) |
| ear1 | Mendi. Earring | (no clear GEO upgrade — Andoaa/Mimir are Enhancing skill, not Indi-spell specific) |
| ear2 | (TODO) | (Indi cast doesn't have a definitive 2nd earring upgrade) |
| ring1 | Stikini Ring +1 | keep |
| ring2 | Stikini Ring +1 placeholder | keep / 2nd Stikini |
| back | Nantosuelta (pet) | **Lifestream Cape** for Indi-spell precast (GEO-only, FC+7%, Geomancy+5) |

**Path**: Geomancy Mitaines +3 → Bagua Pants +3 → Lifestream Cape → Azimuth Hood +3 → Azimuth Gaiters +3 → Bagua Tunic +3.

### sets.midcast['Elemental Magic'] (Nuke set)

| Slot | Current | Best upgrade |
|---|---|---|
| main | **Daybreak** (MAB+40, MD+241, MAcc+40) — acquired 2026-05-20 | Maxentius (Black Halo + MB Bonus per SC step) — better for Burst long-term |
| sub | (placeholder) | **Ammurapi Shield** (MAB+38, MAcc+38) |
| ammo | Pemphredo Tathlum | keep |
| head | Jhakri Coronal +2 (MAB+41) | Merlinic Hood (augmented MAB+40+) or Azimuth Hood +3 (geomancy crossover) |
| body | Jhakri Robe +2 (MAB+43) | Azimuth Coat +3 (MAB+59 + Refresh+4) |
| hands | Bagua Mitaines +2 (MAB+43) | **Bagua Mitaines +3** (MAB+50 + MBD+12) |
| legs | Azimuth Tights +2 (MAB+53, INT+50, MDmg+23) | Azimuth Tights +3 (MAB+58) or Merlinic Shalwar (augmented MAB+40+) |
| feet | Bagua Sandals +2 (MAB+41) | Merlinic Crackows (augmented MAB+40+) |
| neck | Bagua Charm +2 | keep (MAcc+30 is strong) |
| waist | Embla Sash | Acuity Belt +1 (Sortie; +MAcc) for resistant casting |
| ear1 | (Friomisi Earring TODO) | confirm Friomisi (MAB+10) acquisition: Wildskeeper Reive |
| ear2 | (Regal Earring TODO) | Regal Earring (MAB+7, INT+10, MND+10) — Reisenjima Henge Omen |
| ring1 | Jhakri Ring (MAB+3, MBD+2) | keep |
| ring2 | (Metamor. Ring +1 TODO) | Metamor. Ring +1 (INT+6, MND+6, CHR+6, Unity MAcc) |
| back | Nantosuelta (pet cape; 0 nuke benefit) | re-augment a 2nd cape for INT/MAcc/MAB/MDmg/Acumen rolls |

### sets.midcast['Elemental Magic'].Burst (Magic Burst set)

| Slot | Current | Best upgrade |
|---|---|---|
| head | Nyame Helm (MBD+5, SC Bonus+5) | **Ea Hat +1** (MBD I+7, MBD II+7) — Smithing endgame |
| body | Nyame Mail (MBD+7, SC Bonus+7) | **Ea Houppe. +1** (MBD I+9, MBD II+9) |
| hands | Bagua Mitaines +2 (MBD+8) | **Bagua Mitaines +3** (MBD+12) — Refresh+2 bonus |
| legs | Azimuth Tights +2 (MBD+10, MAB+53) | **Azimuth Tights +3** (MBD+15) OR Ea Slops +1 (MBD I+8, MBD II+8) |
| feet | Jhakri Pigaches +2 (MBD+7) | **Ea Pigaches +1** (MBD I+5, MBD II+5) — only piece that fills MBD II in feet |
| ring1 | Jhakri Ring (MBD+2) | keep |
| ring2 | (Mujin Band TODO) | **Mujin Band** (MBD II+5, SC Bonus+5) — Dynamis Windurst from Naa Yixo |

### sets.midcast['Enfeebling Magic']

| Slot | Current | Best upgrade |
|---|---|---|
| ammo | Pemphredo Tathlum | keep |
| head | Bagua Galero +2 | Bagua Galero +3 (MAcc+46 vs +36) |
| body | Azimuth Coat +1 | Azimuth Coat +3 (MAcc+64) |
| hands | Azimuth Gloves +1 | Azimuth Gloves +3 (MAcc+62, Enfeebling skill+28) |
| legs | Azimuth Tights +2 (MAcc+53, Dark skill+25) | Azimuth Tights +3 (MAcc+63) |
| feet | Bagua Sandals +2 | **Bagua Sandals +3** (Enfeebling skill +21, MAcc+36) |
| neck | Bagua Charm +2 | keep / Incanter's Torque alternative (all magic skills+10) |
| waist | Acuity Belt +1 TODO | Acuity Belt +1 (Sortie) |
| ear1 | Regal Earring TODO | Regal Earring (MAB+7, INT/MND+10) |
| ear2 | Vor Earring TODO | Vor Earring (Enfeebling skill+10) — Norg Domain Points |
| back | Nantosuelta (no enfeeb benefit) | (Lifestream Cape if dual-purpose with Indi) |

### sets.midcast['Enhancing Magic']

| Slot | Current | Best upgrade |
|---|---|---|
| ammo | Pemphredo Tathlum | keep |
| head | Azimuth Hood +1 | Telchine Cap (augmented for Enh. duration) or Azimuth Hood +3 |
| body | Telchine Chasuble TODO | **Telchine Chasuble** (augment to Enh. duration; cast and swap) |
| hands | Telchine Gloves TODO | augment for duration |
| legs | Telchine Braconi TODO | augment for duration |
| feet | Telchine Pigaches TODO | augment for duration |
| neck | Incanter's Torque TODO | Incanter's Torque (All magic skills +10) |
| waist | Embla Sash (+10% Enh. duration) | keep |
| ear1 | Andoaa Earring TODO | **Mimir Earring** (Enhancing skill +10) beats Andoaa (+5) |
| ear2 | Mendi. Earring | keep |

**Note**: BGWiki did not return Telchine's full augment ceiling table on this pass; the +10% Enhancing duration per piece is community knowledge but unverified. Treat as unverified.

### sets.idle (No-pet idle)

| Slot | Current | Best upgrade |
|---|---|---|
| main | Solstice | keep / Idris long-term |
| sub | (placeholder) | **Genmei Shield** |
| ammo | (Homiliary TODO) | Homiliary (Limbus drop; Refresh+1) — TODO verify |
| head | Azimuth Hood +1 | Azimuth Hood +3 (DT-12% + Set Bonus) |
| body | Shamash Robe (Refresh+3, PDT-10%, MAB+45) | Azimuth Coat +3 (Refresh+4) — close call vs Shamash |
| hands | Bagua Mitaines +2 (Refresh+1) | **Bagua Mitaines +3** (Refresh+2) |
| legs | Bagua Pants +2 | Bagua Pants +3 |
| feet | Bagua Sandals +2 | Bagua Sandals +3 |
| neck | (placeholder) | **Loricate Torque +1** (DT-6%) |
| waist | Embla Sash | (Carrier's Sash if you want resists; idle waist is hard to upgrade) |
| ear1 | (Etiolation TODO) | Etiolation Earring (FC+1%, MDT-3%) |
| ear2 | Mendi. Earring | keep |
| ring1 | Stikini Ring +1 | keep |
| ring2 | (Defending Ring TODO) | **Defending Ring** (DT-10%) |
| back | Nantosuelta (pet cape) | re-augment a 2nd cape for HP+60/MEva/Cure pot OR keep this as the dedicated pet cape |

### sets.idle.Pet (Luopan summoned — pet survival focus)

Layered on top of `sets.idle`. Your verified pet-survival pieces:

| Slot | Pet piece | What it does |
|---|---|---|
| head | **Bagua Galero +2** (current) | Luopan HP+500. Upgrades to **Bagua Galero +3** (Luopan HP+600) |
| hands | **Geo. Mitaines +1** (current) | Luopan DT -11%. Upgrades to **Geomancy Mitaines +3** (Luopan DT -13%) |
| feet | Bagua Sandals +2 | Luopan Regen +4. Bagua Sandals +3 → +5 |
| back | Nantosuelta | Pet:Regen +15 (your augments) |
| neck | Bagua Charm +2 (Oboro Path A) | Luopan: Absorbs DT +10% — just needs the Oboro augment quest |
| main | Solstice Path D | Pet:DT -4% (your Path D augment) |

### sets.idle.PDT (No-pet defensive idle)

| Slot | Current | Best upgrade |
|---|---|---|
| head | Nyame Helm (DT-7%) | keep (BiS DT head) |
| body | Nyame Mail (DT-9%) | keep OR Adamantite Armor (DT-20%) for pure DT |
| hands | Nyame Gauntlets (DT-7%) | keep |
| legs | Nyame Flanchard (DT-8%) | keep |
| feet | Nyame Sollerets (DT-7%) | keep |
| neck | (TODO) | **Loricate Torque +1** (DT-6%) |
| ring2 | (TODO) | **Defending Ring** (DT-10%) |

### sets.Kiting (movement speed)

| Slot | Current | Best upgrade |
|---|---|---|
| feet | Geo. Sandals +1 (+12% — same move speed as base; better defensive stats) | **Geomancy Sandals +3** (+18%) |
| left_ring | Shneddick Ring (+18% — fills gap until +3 boots) | drop after Sandals +3 (redundant) |
| right_ring | Warp Ring (escape utility) | rotate to Stikini Ring +1 if not actually warping |

---

## By Source — where to grind

### Reforged AF +3 (Coelestrox, Ethereal Ingress #10) and Reforged Relic +3 (Aurix, Ru'Lude G-8)
Bagua (Relic) and Geomancy (AF) +3 upgrades. Trade +2 piece + P. GEO Cards + Kyou's Scale + slot-specific materials.

**Per the Compendium of Colure GEO guide on BGWiki**, the two MANDATORY Bagua +3 pieces are **Bagua Pants +3** and **Bagua Sandals +3** — and the reason is their JA-enhancement augments, not their base stats:
- **Bagua Pants +3** augment: **Enhances Mending Halation** (party AoE HP cure when luopan dies; magnitude unquantified by BGWiki)
- **Bagua Sandals +3** augment: **Enhances Radial Arcana** (+5% MP restored per merit level — +25% at 5/5 merits, party-wide AoE)

These augments don't exist anywhere else in the game — no Empyrean +3, no Reforged AF, no future gear can replicate them. That's the "mandatory" framing. The other three (Galero/Tunic/Mitaines +3) are "optional" because their stats have viable substitute paths from Empyrean +3, Ea +1, Amalric, Merlinic, etc.

- **Priority order (updated)**:
  1. ~~Bagua Sandals +3~~ **DONE** (acquired 2026-05-16 via Kupon) — Radial Arcana augment is live
  2. Bagua Pants +3 (Mending Halation augment + Indi dur+21 — second mandatory)
  3. Geomancy Pants +3 (FC+15%, Reforged AF — biggest precast upgrade)
  4. Geomancy Mitaines +3 (Pet DT-13%, Reforged AF — dominant pet-survival lever)
  5. Bagua Mitaines +3 (Refresh+2 idle, MBD+12 burst)
  6. Bagua Galero +3 (Luopan HP+600)
  7. Bagua Tunic +3 (skippable per guide once you have Amalric Robe +1 / augmented Merlinic Jubbah)
  8. Geomancy Sandals +3 (movement speed +18%)

### Reforged Empyrean +3 (Ruspix, Leafallia)
Azimuth +3 upgrades. 70,000 Gallimaufry + 1 Ra'Kaz. Starstone per piece, traded with the +2 piece.
- **Priority order**: Azimuth Hood +3 (Geomancy+25, Full Circle+4) → Azimuth Coat +3 (Refresh+4, MBD II+5) → Azimuth Tights +3 (MBD+15) → Azimuth Gaiters +3 (Indi dur+30) → Azimuth Gloves +3

### Sortie BCNM (Reisenjima Henge Omen / Sheol)
- **Ammurapi Shield** (Kei, Reisenjima Henge)
- **Acuity Belt +1** (Sheol A "Joyous Green" + 30k Unity Accolades)
- **Regal Earring** (Ou, Reisenjima Henge)
- **Kishar Ring** (Glassy Gorger, Reisenjima Henge)
- **Lugalbanda Earring** (Kei) — MAcc earring, not refresh

### Ambuscade (current month rotates; some Hallmark/Gallantry items always available)
- **Maxentius** (club)
- Regal Ring, Argosy/Hizamaru pieces (DD jobs — not GEO)
- Hallmark currency redemption for various

### Voidwatch
- **Witful Belt** (East Sarutabaruta — Rw Nw Prt M Hrw)
- **Phalaina Locket** (Bismarck)
- Various Kupon-redeemable Vol items via Dealer Moogle

### Sinister Reign
- **Witching Robe** (Arciela)
- **Lengo Pants** (Arciela/Ygnas)

### Dynamis-D (Divergence)
- **Mujin Band** (Naa Yixo the Stillrage, Dynamis Windurst)

### BCNMs (Phantom Gem trials)
- **Sors Shield** (Brothers D'Aurphe II — Macrocosmic Orb)
- **Voltsurge Torque** (Avatar Prime II)
- **Lebeche Ring** (Avatar Prime II)
- **Sanare Earring** (Divine Might II — but skip, not actually a cure piece)

### Vagary
- **Etiolation Earring** (Perfidien in Outer Ra'Kaznar [U])

### Behemoth's Dominion
- **Defending Ring** (Sovereign Behemoth, rare)
- **Loricate Torque +1** (Sovereign Behemoth, OR Unity NPC upgrade)

### Unity
- **Loricate Torque +1** (upgrade Loricate Torque via Unity NPC)
- **Solstice Path D** R15 (you already did this)

### Geas Fete (Escha Ru'Aun)
- **Genmei Shield** (Genbu, with Genbu's Honor KI)
- **Eschan Stone** (random NM drop)

### Reisenjima Synergy Craft
- **Lifestream Cape** (GEO-only, Synergy)

### Aeonic / Mythic (multi-month grinds)
- **Daybreak** (Aeonic Club — Reisenjima Aeonic BCNMs)
- **Idris** (Mythic — Empyrean Aeonic-level grind, way past Daybreak)

### Smithing 115–120 + Clothcraft (HQ craft)
- **Ea +1 set** (5 pieces, requires Blacksmith's argentum tome KI)

### Norg Domain Points
- **Mimir Earring** (Enhancing skill+10)
- **Vor Earring** (Enfeebling skill+10)
- **Sanctity Necklace** (HP+35/MP+35/MAB+10/MAcc+10/Regen+2)
- **Embla Sash** (you already have)

### Oboro (Port Jeuno, Synergy augments)
- **Bagua Charm +2 Path A augment** (Luopan: Absorbs DT +10% — quick win)
- Augments for various +2 pieces

### Reisenjima Geas Fete + Oseem (Skirmish augment)
- **Merlinic** set augments — for nuke MAB/MAcc/MDmg, or FC rolls

### Alluvion Skirmish + Divainy-Gamainy
- **Telchine** set augments (Enh. duration) — only the Chasuble matters for GEO

---

## Unverified items (further research needed before chasing)

These had stats I couldn't fully verify from the BGWiki pages WebFetch returned. Verify before committing acquisition time:

- **Telchine augment ceiling values** (Enhancing duration % per piece, max augment levels)
- **Merlinic Dastanas "TH+2" augment** — Dark Matter route exists but max TH value not surfaced
- **Taranus's Cape** — possibly the GEO JSE cape from Omen, but I haven't verified its existence or stats. Could be an alternative to Nantosuelta. (Update: Nantosuelta IS the GEO Ambuscade cape, so Taranus is likely something else entirely — likely doesn't exist.)
- **Homiliary** — claimed Refresh+1 idle ammo from Limbus

---

## My known errors during this build (lessons for next time)

I had stat claims wrong on these items at various points and corrected them via BGWiki verification:

1. Conflated **Haste %** with **Fast Cast %** on Bagua Galero +2, Bagua Tunic +1, Bagua Pants +2, Bagua Sandals +2, Azimuth Hood +1 (all have Haste, none have generic FC — only Bagua Mitaines +2 has Elemental cast time reduction).
2. Claimed **Marin Staff** was a cure weapon — it's a Wind-element nuke staff with FC+2%.
3. Claimed **Mall. Chapeau/Cuffs/Clogs +2** had MBD II — they have Elemental cast time -6%, not MBD II.
4. Claimed **Jhakri Robe +2** had Magic Burst Damage — it doesn't (only Jhakri Pigaches +2 has MBD +7).
5. Multiple wrong sources (Witful Belt = Voidwatch not Reisenjima Synergy; Genmei Shield = Escha Ru'Aun not Reisenjima HM; Etiolation = Vagary not Reisenjima HM; Voltsurge = Cloister of Storms not Apex Bats).
6. Made up several items entirely (**Phillemot**, **Hesychast's Roundel**) — these do not exist on BGWiki.
7. Claimed several items GEO could equip when they're job-locked: **Sacro Gorget** (PLD/RUN), **Hermes' Sandals** (WAR/MNK/COR/PUP/RUN), **Carmine Cuisses +1** (RDM/PLD/etc.), **Skadi's Jambeaux +1** (THF/BST/etc.), **Tandava Crackows** (DNC), **Leyline Gloves** (not GEO), **Atrophy Tights +3** (RDM), **Inyanga +3** (WHM/BRD/SMN), **Bunzi** (WHM/RDM/BRD/SMN), **Naegling** (not GEO), **Cleric's Torque** (WHM), **Sucellos's Cape** (RDM), **Bookworm's Cape** (SCH).
8. Got pet-piece roles wrong: **Pixie Hairpin +1** is Dark MAB not pet, **Janniston Ring** is Cure pot II not pet, **Adamantite Armor** is generic DT not pet HP.

The rule from this build going forward: **never assume FFXI item stats; always WebFetch BGWiki first.** This file's stats are all verified except where flagged unverified.
