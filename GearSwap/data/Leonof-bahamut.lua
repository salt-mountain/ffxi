--  Modes:      [ F9 ]              Cycle Offense Modes
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ ALT+F9 ]          Cycle Ranged Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ WIN+W ]           Enable Roll sets* look binds section notes
 
function get_sets()
    mote_include_version = 2
    -- Load and initialize the include file.
    include('Mote-Include.lua')
    include('organizer-lib')
end
 
function job_setup()
     
    elemental_ws = S{"Aeolian Edge", "Cloudsplitter", "Shadow of Death", "Cataclysm", "Sanguine Blade"}
    Set1List = S{"Agwu's Claymore", "Laphria"}
    Set2List = S{"Ukonvasara", "Shining One", "Raetic Algol", "Bravura", "Xoanon"} 
    Set3List = S{"Quint Spear"}
    sub_weapons = S{"Sangarius +1", "Dolichenus", "Reikiko", "Naegling", "Infiltrator", "Fernagu", "Farsha", "Ikenga's Axe"}
    -- sam_sj = player.sub_job == 'SAM' or false
     
    update_combat_form()
    update_combat_weapon()
    update_melee_groups()
     
     
    -- lockstyleset = 18
     
    --these gear groups I normally have in my globals lua
    --Odyssean Gear
    gear.OdySTPlegs = { name="Odyssean Cuisses", augments={'Accuracy+28','"Store TP"+6',}}
     
    --Chirich Rings
    gear.ChirichL = {name="Chirich Ring +1", bag="wardrobe3"}
    gear.ChirichR = {name="Chirich Ring +1", bag="wardrobe4"}
     
    --Moonlight Rings
    gear.MoonlightL = {name="Moonlight Ring", bag="wardrobe3"}
    gear.MoonlightR = {name="Moonlight Ring", bag="wardrobe4"}
     
    --War jse back
    gear.CicholTP = { name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
    gear.CicholSTP = { name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
    gear.CicholWDA = { name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}}
    gear.CicholWSD = { name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}
    gear.CicholUPH = { name="Cichol's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
     
    gear.empty = {head=empty, body=empty, hands=empty, legs=empty, feet=empty}
     
    --Prevent gearinfo override
    no_swap_gear = S{"Warp Ring","Tavnazian Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)", "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring",
                    "Dev. Bul. Pouch", "Chr. Bul. Pouch", "Liv. Bul. Pouch"}
 
 
    abyprocws = S{"Cyclone", "Energy Drain", "Red Lotus Blade", "Seraph Blade", "Freezebite", "Shadow of Death", "Raiden Thrust", "Blade: Ei", "Tachi: Jinpi", "Tachi: Koki",
                "Seraph Strike", "Earth Crusher", "Sunburst"}
     
    --I have this in my my motes-mappings lua
    areas.Abyssea = S{
    "Abyssea - Konschtat",
    "Abyssea - La Theine",
    "Abyssea - Tahrongi",
    "Abyssea - Attohwa",
    "Abyssea - Misareaux",
    "Abyssea - Vunkerl",
    "Abyssea - Altepa",
    "Abyssea - Uleguerand",
    "Abyssea - Grauberg",
    "Abyssea - Empyreal Paradox"
    }
end
 
-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    -- Options: Override default values
    state.OffenseMode:options('Normal', 'Acc')                      
    state.HybridMode:options('Normal', 'PDT')                       
    state.WeaponskillMode:options('Normal', 'Atk')                          
    state.CastingMode:options('Normal')                             
    state.IdleMode:options('Normal')                                
    state.PhysicalDefenseMode:options('DT')     
    state.MagicalDefenseMode:options('Reraise')                     
     
     
    -- Additional local binds
    send_command('bind ^` input /ja "Hasso" <me>')                    --^ means ctrl
    send_command('bind !` input /ja "Seigan" <me>')                   --! means alt                   
    send_command('bind @w gs c toggle Roll')                        --@ means windows key
     
    --you need to add "state.Roll = M(false, 'Roll sets enabled')" 
    --to the define_global_sets() section of your globals lua to get the roll sets to work
    --dont ask me why
     
    select_default_macro_book()
    -- set_lockstyle()
     
    state.Auto_Kite = M(false, 'Auto_Kite')
    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
end
 
-- Called when this job file is unloaded (eg: job change)
function file_unload()
    send_command('unbind ^`')   
    send_command('unbind !=')
    send_command('unbind ^[')
    send_command('unbind ![')
    send_command('unbind @f9')
    send_command('unbind @w')
end
 
-- Define sets and vars used by this job file.
function init_gear_sets()
 
 
    sets.precast.JA['Mighty Strikes'] = {hands="Agoge Mufflers +2"}
    sets.precast.JA['Defender'] = {hands="Agoge Mufflers +2"}
    sets.precast.JA['Blood Rage'] = {body="Boii Lorica +3"}
    sets.precast.JA['Warcry'] = {head="Agoge Mask +3"}
    sets.precast.JA['Berserk'] = {body="Pumm. Lorica +3", feet="Agoge Calligae +3"}
    sets.precast.JA['Tomahawk'] = {feet="Agoge Calligae +3"}
    --sets.precast.JA["Warrior's Charge"] = {legs="Agoge Cuisses +3",}
    --sets.precast.JA['Restraint'] = {hands="Boii Mufflers +1"}
    --sets.precast.JA['Retaliation'] = {feet="Boii Calligae +3"}
    sets.precast.JA['Aggressor'] = {head="Pummeler's Mask +1", body="Agoge Lorica +3"}
    sets.precast.JA['Provoke'] = {
        ammo="Sapience Orb",
        neck="Moonlight Necklace",
        head="Halitus Helm",
        body="Emet Harness +1",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        left_ear="Trux Earring",
        left_ring="Petrov Ring",
        right_ring="Eihwaz Ring",
    }
     
    -- Magic sets
    -- Fast cast sets for spells
    sets.precast.FC = {
        ammo="Sapience Orb",
        head="Sakpata's Helm",
        body="Sacro Breastplate",
        hands="Leyline Gloves",
        legs="Arjuna Breeches",
        --feet="Odyssean Greaves",
        neck="Voltsurge Torque",
        waist="Audumbla Sash",
        left_ear="Loquac. Earring",
        right_ear="Etiolation Earring",
        left_ring="Gelatinous Ring +1",
        right_ring="Defending Ring",
        back="Solemnity Cape"
    }
 
    sets.midcast.FastRecast = set_combine(sets.precast.FC, {
        ammo="Staunch Tathlum +1",
        legs="Jokushu Haidate",
    })
     
 
    --WS sets
     
    --General WS set
    sets.precast.WS = {
        ammo="Coiste Bodhar",
        head="Sakpata's Helm",
        body="Sakpata's Breastplate",
        hands="Sakpata's Gauntlets",
        legs="Boii Cuisses +3",
        feet="Sakpata's Leggings",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Schere Earring",
        right_ear="Moonshade Earring",
        left_ring="Regal Ring",
        right_ring="Niqmaddu Ring",
        back=gear.CicholWDA
    }
     
    --Great Axe
    sets.precast.WS['Upheaval'] = {
        ammo="Knobkierrie",
        head="Sakpata's Helm",
        body="Sakpata's Breastplate",
        hands="Sakpata's Gauntlets",
        legs="Boii Cuisses +3",
        feet="Sakpata's Leggings",
        neck="Warrior's Bead Necklace +2",
        waist="Sailfi Belt +1",
        left_ear="Thrud Earring",
        right_ear="Moonshade Earring",
        left_ring="Sroda Ring",
        right_ring="Niqmaddu Ring",
        back=gear.CicholUPH
    }
    sets.precast.WS['Upheaval'].Atk = set_combine(sets.precast.WS['Upheaval'], {head="Agoge Mask +3", hands="Boii Mufflers +3", feet="Nyame Sollerets", left_ring="Regal Ring"})
     
    -- sets.precast.WS['Upheaval'].Acc = set_combine(sets.precast.WS['Upheaval'], {})
     
    sets.precast.WS["Ukko's Fury"] = {
        ammo="Yetshila +1",
        head="Boii Mask +3",
        body="Sakpata's Breastplate",
        hands="Sakpata's Gauntlets",
        legs="Boii Cuisses +3",
        feet="Boii Calligae +3",
        neck="Warrior's Bead Necklace +2",
        waist="Sailfi Belt +1",
        left_ear="Schere Earring",
        right_ear="Boii Earring +1",
        left_ring="Lehko Habhoka's Ring",
        right_ring="Niqmaddu Ring",
        back=gear.CicholWSD
    }
    sets.precast.WS["Ukko's Fury"].Atk = set_combine(sets.precast.WS["Ukko's Fury"], {hands="Boii Mufflers +3"})
     
    sets.precast.WS["King's Justice"] = {
        ammo="Knobkierrie",
        head="Agoge Mask +3",
        body="Sakpata's Breastplate",
        hands="Boii Mufflers +3",
        legs="Boii Cuisses +3",
        feet="Nyame Sollerets",
        neck="Warrior's Bead Necklace +2",
        waist="Sailfi Belt +1",
        left_ear="Thrud Earring",
        right_ear="Moonshade Earring",
        left_ring="Sroda Ring",
        right_ring="Niqmaddu Ring",
        back=gear.CicholWSD
    }
    sets.precast.WS["King's Justice"].Atk = set_combine(sets.precast.WS["King's Justice"], {body="Nyame Mail", left_ring="Regal Ring"})
     
    -- sets.precast.WS["King's Justice"].Acc = set_combine(sets.precast.WS["King's Justice"], {})
     
    sets.precast.WS["Raging Rush"] = sets.precast.WS["Ukko's Fury"]
    sets.precast.WS['Steel Cyclone'] = sets.precast.WS["King's Justice"]
    sets.precast.WS['Metatron Torment'] = sets.precast.WS["King's Justice"]
    sets.precast.WS['Fell Cleave'] = sets.precast.WS["King's Justice"]
     
    sets.precast.WS['Full Break'] = {
        ammo="Pemphredo Tathlum",
        head="Boii Mask +3",
        body="Boii Lorica +3",
        hands="Boii Mufflers +3",
        legs="Boii Cuisses +3",
        feet="Boii Calligae +3",
        neck="Sanctity Necklace",
        waist="Eschan Stone",
        left_ear="Dignitary's Earring",
        right_ear="Moonshade Earring",
        left_ring="Flamma Ring",
        right_ring="Niqmaddu Ring",
        back=gear.CicholWSD
    }
     
    sets.precast.WS['Armor Break'] = sets.precast.WS['Full Break']
    sets.precast.WS['Weapon Break'] = sets.precast.WS['Full Break']
    sets.precast.WS['Shield Break'] = sets.precast.WS['Full Break']
    sets.precast.WS['Disaster'] = sets.precast.WS["King's Justice"]
     
    --Axe
    sets.precast.WS['Decimation'] = set_combine(sets.precast.WS, {right_ear="Boii Earring +1",})
    sets.precast.WS['Ruinator'] = sets.precast.WS['Decimation']
    sets.precast.WS['Mistral Axe'] = sets.precast.WS["King's Justice"]
    sets.precast.WS['Bora Axe'] = sets.precast.WS["King's Justice"]
    sets.precast.WS['Calamity'] = sets.precast.WS["King's Justice"]
    sets.precast.WS['Smash Axe'] = sets.precast.WS['Full Break']
     
    sets.precast.WS['Cloudsplitter'] = set_combine(sets.precast.WS, {
        ammo="Seething Bomblet +1",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Sanctity Necklace",
        waist="Eschan Stone",
        left_ear="Friomisi Earring",
        right_ear="Moonshade Earring",
        left_ring="Regal Ring",
        right_ring="Niqmaddu Ring",
        back=gear.CicholWSD
    })
     
    sets.precast.WS['Rampage'] = {
        ammo="Yetshila +1",
        head="Boii Mask +3",
        body="Sakpata's Breastplate",
        hands="Sakpata's Gauntlets",
        legs="Boii Cuisses +3",
        feet="Boii Calligae +3",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Schere Earring",
        right_ear="Moonshade Earring",
        left_ring="Lehko Habhoka's Ring",
        right_ring="Niqmaddu Ring",
        back=gear.CicholWDA
    }
     
    --Great Sword
    sets.precast.WS['Resolution'] = set_combine(sets.precast.WS, {left_ring="Sroda Ring"})  
    sets.precast.WS['Groundstrike'] = sets.precast.WS["King's Justice"]
    sets.precast.WS['Shockwave'] = sets.precast.WS['Full Break']
     
    --Scythe
    sets.precast.WS['Spiral Hell'] = sets.precast.WS["King's Justice"]
    -- sets.precast.WS['Entropy'] = sets.precast.WS
     
    sets.precast.WS['Shadow of Death'] = set_combine(sets.precast.WS, {
        ammo="Knobkierrie",
        head="Pixie Hairpin +1",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Sibyl Scarf",
        waist="Eschan Stone",
        left_ear="Friomisi Earring",
        right_ear="Moonshade Earring",
        left_ring="Regal Ring",
        right_ring="Archon Ring",
        back=gear.CicholWSD
    })
     
    sets.precast.WS['Infernal Scythe'] = sets.precast.WS['Shadow of Death']
     
    --Staff
    sets.precast.WS['Retribution'] = sets.precast.WS["King's Justice"]
    sets.precast.WS['Cataclysm'] = sets.precast.WS['Shadow of Death']
    sets.precast.WS['Shell Crusher'] = sets.precast.WS['Full Break']
     
    --Sword
    sets.precast.WS['Savage Blade'] = sets.precast.WS["King's Justice"]
    sets.precast.WS['Savage Blade'].Atk = sets.precast.WS["King's Justice"].Atk
    -- sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {})
     
    sets.precast.WS['Vorpal Blade'] = sets.precast.WS['Rampage']
    sets.precast.WS['Sanguine Blade'] = sets.precast.WS['Shadow of Death']
    sets.precast.WS['Flat Blade'] = sets.precast.WS['Full Break']
     
    --Club
    sets.precast.WS['Judgment'] = sets.precast.WS["King's Justice"]
    sets.precast.WS['Black Halo'] = sets.precast.WS["King's Justice"]
    sets.precast.WS['Hexa Strike'] = sets.precast.WS['Rampage']
    sets.precast.WS['Brainshaker'] = sets.precast.WS['Full Break']
    sets.precast.WS['Realmrazer'] = set_combine(sets.precast.WS, {left_ear="Schere Earring", right_ear="Thrud Earring", back=gear.CicholWSD})
 
    --Dagger
    sets.precast.WS['Aeolian Edge'] = sets.precast.WS['Cloudsplitter']
    sets.precast.WS['Evisceration'] = sets.precast.WS['Rampage']
    -- sets.precast.WS['Extenterator'] = sets.precast.WS
 
    --Polearm
    sets.precast.WS['Impulse Drive'] = set_combine(sets.precast.WS["King's Justice"], {
        ammo="Yetshila +1", 
        head="Blistering Sallet +1", 
        feet="Boii Calligae +3",
        left_ring="Lehko Habhoka's Ring",
    })
    sets.precast.WS['Stardiver'] = set_combine(sets.precast.WS, {
        ammo="Yetshila +1", 
        head="Blistering Sallet +1", 
        feet="Boii Calligae +3",
        left_ring="Lehko Habhoka's Ring",
    })
    sets.precast.WS['Leg Sweep'] = sets.precast.WS['Full Break']
    sets.precast.WS['Sonic Thrust'] = sets.precast.WS["King's Justice"]
     
    --H2H 
    sets.precast.WS['Combo'] = set_combine(sets.precast.WS, {neck="Warrior's Bead Necklace +2", waist="Sailfi Belt +1"})
    sets.precast.WS['Shoulder Tackle'] = sets.precast.WS['Full Break']
    sets.precast.WS['Dragon Kick'] = sets.precast.WS['Combo']
    sets.precast.WS['Tornado Kick'] = sets.precast.WS['Combo']
    sets.precast.WS['Raging Fists'] = sets.precast.WS['Combo']
    sets.precast.WS['Asuran Fists'] = sets.precast.WS['Realmrazer']
     
    --Other
    --no longer needed after master levels, the pretarget parts are also untested
    -- sets.pretarget.WS['Blade: Ei'] = {neck="Yarak Torque"}
    -- sets.precast.WS['Blade: Ei'] = {neck="Yarak Torque"}
    -- sets.pretarget.WS['Tachi: Jinpu'] = {neck="Agelast Torque"}
    -- sets.precast.WS['Tachi: Jinpu'] = {neck="Agelast Torque"}
    -- sets.pretarget.WS['Tachi: Koki'] = {head="Kengo Hachimaki", neck="Agelast Torque"}
    -- sets.precast.WS['Tachi: Koki'] = {head="Kengo Hachimaki", neck="Agelast Torque"}
     
    sets.MS = {
        ammo="Yetshila +1",
        feet="Boii Calligae +3",
    }
 
     
--Idle Sets
 
    sets.idle = {
        ammo="Staunch Tathlum +1",
        head="Sakpata's Helm",
        body="Sacro Breastplate",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        neck="Loricate Torque +1",
        waist="Engraved Belt",
        left_ear="Genmei Earring",
        right_ear="Odnowa Earring +1",
        left_ring=gear.ChirichL,
        right_ring=gear.ChirichR,
        back=gear.CicholTP,
    }
 
    sets.idle.Regen = { 
        ammo="Staunch Tathlum +1",
        head="Sakpata's Helm",
        body="Sacro Breastplate",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        neck="Bathy Choker +1",
        waist="Flume Belt",
        left_ear="Genmei Earring",
        right_ear="Odnowa Earring +1",
        left_ring=gear.ChirichL,
        right_ring=gear.ChirichR,
        back=gear.CicholTP,
    }
     
    sets.idle.Town = set_combine(sets.idle, {feet="Hermes' Sandals +1"})
    sets.idle.Field = sets.idle
    sets.idle.Weak = sets.idle
 
    --Damage Taken sets
     
    sets.defense.DT = {
        ammo="Staunch Tathlum +1",
        head="Sakpata's Helm",
        body="Sacro Breastplate",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        neck="Loricate Torque +1",
        waist="Engraved Belt",
        left_ear="Genmei Earring",
        right_ear="Odnowa Earring +1",
        left_ring=gear.ChirichL,
        right_ring=gear.ChirichR,
        back=gear.CicholTP,
    }
     
    sets.defense.Reraise = set_combine(sets.defense.DT, {
        head="Twilight Helm",
        body="Twilight Mail",
        left_ring=gear.MoonlightL,
        right_ring=gear.MoonlightR,
    })
     
    --TP sets
    sets.engaged = {
        ammo="Coiste Bodhar",
        head="Sakpata's Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Boii Cuisses +3",
        feet="Pumm. Calligae +3",
        neck="Warrior's Bead Necklace +2",
        waist="Ioskeha Belt +1",
        left_ear="Schere Earring",
        right_ear="Boii Earring +1",
        left_ring="Lehko Habhoka's Ring",
        right_ring="Niqmaddu Ring",
        back=gear.CicholSTP,
    }
     
    -- sets.engaged.Acc = set_combine(sets.engaged, {})
    sets.engaged.Sam = set_combine(sets.engaged, {
        body="Tatenashi Haramaki +1",
        legs=gear.OdySTPlegs,
        left_ear="Dedition Earring",
    })
    sets.engaged.War = set_combine(sets.engaged, {
        body="Tatenashi Haramaki +1",
        legs=gear.OdySTPlegs,
        feet="Flamma Gambieras +2",
        left_ear="Dedition Earring",
    })
    sets.engaged.Sam.War = set_combine(sets.engaged, {
        body="Tatenashi Haramaki +1",
        legs=gear.OdySTPlegs,
        waist="Sailfi Belt +1",
        left_ear="Dedition Earring",
    })
     
    sets.engaged.PDT = set_combine(sets.engaged, {
        legs="Sakpata's Cuisses",
        left_ring=gear.MoonlightL,
    })
     
    -- sets.engaged.PDT.Acc = set_combine(sets.engaged.PDT, {})
    sets.engaged.PDT.Sam = set_combine(sets.engaged.PDT, {
        body="Boii Lorica +3",
        legs=gear.OdySTPlegs,
        left_ear="Dedition Earring",
        right_ring=gear.MoonlightR,
    })
    sets.engaged.PDT.War = set_combine(sets.engaged.PDT, {
        body="Boii Lorica +3",
        legs=gear.OdySTPlegs,
        left_ear="Dedition Earring",
        right_ring=gear.MoonlightR,
    })
    sets.engaged.PDT.Sam.War = set_combine(sets.engaged.PDT, {
        body="Boii Lorica +3",
        legs=gear.OdySTPlegs,
        waist="Sailfi Belt +1",
        left_ear="Dedition Earring",
        right_ring=gear.MoonlightR,
    })
     
 
    -- sets.engaged.SUB = {}
    -- sets.engaged.SUB.Acc = {}
    -- sets.engaged.SUB.PDT = {}
     
    sets.engaged.Set1 = set_combine(sets.engaged, {left_ear="Dedition Earring"})
    sets.engaged.Set1.Sam = sets.engaged.Sam
    sets.engaged.Set1.War = sets.engaged.War
    sets.engaged.Set1.Sam.War = sets.engaged.Sam.War
     
    sets.engaged.Set1.PDT = set_combine(sets.engaged.PDT, {left_ear="Dedition Earring"})
    sets.engaged.Set1.Sam = sets.engaged.PDT.Sam
    sets.engaged.Set1.War = sets.engaged.PDT.War
    sets.engaged.Set1.Sam.War = sets.engaged.PDT.Sam.War
     
    sets.engaged.Set2 = { --niqmaddu after schere r25
        ammo="Coiste Bodhar",
        head="Sakpata's Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Boii Cuisses +3",
        feet="Pumm. Calligae +3",
        neck="Warrior's Bead Necklace +2",
        waist="Ioskeha Belt +1",
        left_ear="Schere Earring",
        right_ear="Boii Earring +1",
        left_ring="Lehko Habhoka's Ring",
        right_ring=gear.ChirichR,
        back=gear.CicholSTP,
    }
     
    sets.engaged.Set2.Sam = set_combine(sets.engaged.Set2, {})
     
    sets.engaged.Set2.War = set_combine(sets.engaged.Set2, {
        legs=gear.OdySTPlegs,
        feet="Flamma Gambieras +2",
        waist="Sailfi Belt +1",
        left_ear="Dedition Earring",
        right_ring="Niqmaddu Ring",
    })
     
    sets.engaged.Set2.Sam.War = set_combine(sets.engaged.Set2, {})
     
    sets.engaged.Set2.PDT = set_combine(sets.engaged.Set2, {
        legs="Sakpata's Cuisses",
    })
     
    sets.engaged.Set2.PDT.Sam = set_combine(sets.engaged.Set2.PDT, {})
     
    sets.engaged.Set2.PDT.War = set_combine(sets.engaged.Set2.PDT, {
        feet="Flamma Gambieras +2",
        waist="Sailfi Belt +1",
        left_ear="Dedition Earring",
        right_ear="Telos Earring",
    })
     
    sets.engaged.Set2.PDT.Sam.War = set_combine(sets.engaged.Set2.PDT, {
        feet="Flamma Gambieras +2",
        waist="Sailfi Belt +1",
        left_ear="Dedition Earring",
        right_ear="Telos Earring",
    })
     
    sets.engaged.Set2.AM3 = {
        ammo="Yetshila +1",
        head="Sakpata's Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Boii Cuisses +3",
        feet="Boii Calligae +3",
        neck="Warrior's Bead Necklace +2",
        waist="Ioskeha Belt +1",
        left_ear="Schere Earring",
        right_ear="Boii Earring +1",
        left_ring="Lehko Habhoka's Ring",
        right_ring="Niqmaddu Ring",
        back=gear.CicholTP,
    }
     
    sets.engaged.Set2.AM3.Sam = set_combine(sets.engaged.Set2.AM3, {})
     
    sets.engaged.Set2.AM3.War = set_combine(sets.engaged.Set2.AM3, {
        waist="Sailfi Belt +1",
        left_ear="Dedition Earring",
        right_ring=gear.ChirichR,
        back=gear.CicholSTP,
    })
     
    sets.engaged.Set2.AM3.Sam.War = set_combine(sets.engaged.Set2.AM3.War, {right_ring="Niqmaddu Ring"})
     
    sets.engaged.Set2.PDT.AM3 = set_combine(sets.engaged.Set2.AM3, {
        legs="Sakpata's Cuisses",
    })
     
    sets.engaged.Set2.PDT.AM3.Sam = set_combine(sets.engaged.Set2.PDT.AM3, {})
     
    sets.engaged.Set2.PDT.AM3.War = set_combine(sets.engaged.Set2.PDT.AM3, {
        waist="Sailfi Belt +1",
        left_ear="Dedition Earring",
        back=gear.CicholSTP,
    })
     
    sets.engaged.Set2.PDT.AM3.Sam.War = set_combine(sets.engaged.Set2.PDT.AM3, {})
     
     
    -- sets.engaged.SUB.Set2 = set_combine(sets.engaged.Set2, {})
    -- sets.engaged.SUB.Set2.PDT = set_combine(sets.engaged.SUB.Set2, {})
     
    sets.engaged.Set3 = {
        ammo="Seething Bomblet +1",
        head="Sulevia's Mask +2",
        body="Hjarrandi Breast.",
        hands="Tatena. Gote +1",
        legs=gear.OdySTPlegs,
        feet="Pumm. Calligae +3",
        neck="Vim Torque +1",
        waist="Ioskeha Belt +1",
        left_ear="Dedition Earring",
        right_ear="Telos Earring",
        left_ring="Lehko Habhoka's Ring",
        right_ring=gear.ChirichR,
        back=gear.CicholSTP,
    }
     
    sets.engaged.Set3.PDT = set_combine(sets.engaged.Set3, {
        left_ring=gear.MoonlightL,
        right_ring=gear.MoonlightR,
    })
     
    --Dual Wield TP sets  --add dw fighters roll set
    sets.engaged.DW = set_combine(sets.engaged, {
        ammo="Coiste Bodhar",
        head="Sakpata's Helm",
        body="Tatenashi Haramaki +1",
        hands="Emicho Gauntlets +1",
        legs="Boii Cuisses +3",
        feet="Pumm. Calligae +3",
        neck="Warrior's Bead Necklace +2",
        waist="Ioskeha Belt +1",
        left_ear="Suppanomimi",
        right_ear="Boii Earring +1",
        left_ring="Lehko Habhoka's Ring",
        right_ring="Niqmaddu Ring",
        back=gear.CicholSTP,
    })
     
    sets.engaged.DW.AM3 = sets.engaged.Set2.AM3
      
    sets.engaged.DW.PDT = set_combine(sets.engaged.DW, {
        body="Sakpata's Plate",
        legs="Sakpata's Cuisses",
        left_ring=gear.MoonlightL,
        right_ring=gear.MoonlightR,
    })
     
    sets.engaged.DW.PDT.AM3 = sets.engaged.Set2.PDT.AM3
     
    sets.engaged.OneHand = set_combine(sets.engaged, {
        ammo="Coiste Bodhar",
        head="Hjarrandi Helm",
        body="Tatenashi Haramaki +1",
        hands="Sakpata's Gauntlets",
        legs="Tatenashi Haidate +1", 
        feet="Pumm. Calligae +3",
        neck="Warrior's Bead Necklace +2",
        waist="Ioskeha Belt +1",
        left_ear="Schere Earring",
        right_ear="Boii Earring +1",
        left_ring="Lehko Habhoka's Ring",
        right_ring="Niqmaddu Ring",
        back=gear.CicholSTP,
    })
     
     
    sets.engaged.OneHand.Sam = set_combine(sets.engaged.OneHand, {
        legs="Pummeler's Cuisses +3",
        right_ear="Dedition Earring",
        back=gear.CicholTP,
    })
     
    sets.engaged.OneHand.War = set_combine(sets.engaged.OneHand, {
        waist="Sailfi Belt +1",
    })
     
    sets.engaged.OneHand.Sam.War = set_combine(sets.engaged.OneHand, {
        feet="Flamma Gambieras +2",
        right_ear="Dedition Earring",
    })
     
    sets.engaged.OneHand.AM3 =  sets.engaged.Set2.AM3   
 
    sets.engaged.OneHand.PDT = set_combine(sets.engaged.OneHand, { 
        body="Boii Lorica +3",
        legs="Pummeler's Cuisses +3",
        right_ring=gear.MoonlightR,
    })
     
    sets.engaged.OneHand.PDT.Sam = set_combine(sets.engaged.OneHand.PDT, { 
        right_ear="Dedition Earring",
        back=gear.CicholTP,
    })
 
    sets.engaged.OneHand.PDT.War = set_combine(sets.engaged.OneHand.PDT, {
        head="Boii Mask +3",
        legs="Sakpata's Cuisses",
        waist="Sailfi Belt +1",
        left_ear="Telos Earring",
        right_ear="Dedition Earring",
    })
     
    sets.engaged.OneHand.PDT.Sam.War = set_combine(sets.engaged.OneHand, {
        legs="Sakpata's Cuisses", 
        feet="Flamma Gambieras +2",
        waist="Sailfi Belt +1",
        right_ear="Dedition Earring",
    })
 
    sets.engaged.OneHand.PDT.AM3 = sets.engaged.Set2.PDT.AM3    
 
    sets.Kiting = {feet="Hermes' Sandals +1"}
     
    sets.buff.Doom = {
        -- neck="Nicander's Necklace",
        waist="Gishdubar Sash",
        -- left_ring={name="Eshmun's Ring", bag="wardrobe3"},
        -- right_ring={name="Eshmun's Ring", bag="wardrobe4"},
        right_ring="Eshmun's Ring",
        }
 
end
 
 
 
-- Called before the Include starts constructing melee/idle/resting sets.
-- Can customize state or custom melee class values at this point.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_handle_equipping_gear(playerStatus, eventArgs)
    update_combat_form()
    update_combat_weapon()
    update_melee_groups()
    -- determine_haste_group()
    check_moving()
    check_gear()
    -- sam_sj = player.sub_job == 'SAM' or false
end
 
function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
end
 
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.hpp < 90 then
        idleSet = set_combine(idleSet, sets.idle.Regen)
    end
    -- if state.HybridMode.current == 'PDT' then
        -- idleSet = set_combine(idleSet, sets.defense.PDT)
    -- end
    if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
    end
     
    return idleSet
end
 
function job_post_precast(spell, action, spellMap, eventArgs)  
    if spell.type == 'WeaponSkill' then
        if buffactive["Mighty Strikes"] then
            equip(sets.MS)
        elseif areas.Abyssea:contains(world.area) and abyprocws:contains(spell.english) then
            equip(gear.empty)
        end
    end
    if elemental_ws:contains(spell.name) then
        -- Matching double weather (w/o day conflict).
        if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
            equip({waist="Hachirin-no-Obi"})
        -- Target distance under 1.7 yalms.
        -- elseif spell.target.distance < (1.7 + spell.target.model_size) then
            -- equip({waist="Orpheus's Sash"})
        -- Matching day and weather.
        elseif spell.element == world.day_element and spell.element == world.weather_element then
            equip({waist="Hachirin-no-Obi"})
        -- Target distance under 8 yalms.
        -- elseif spell.target.distance < (8 + spell.target.model_size) then
            -- equip({waist="Orpheus's Sash"})
        -- Match day or weather.
        elseif spell.element == world.day_element or spell.element == world.weather_element then
            equip({waist="Hachirin-no-Obi"})
        end
    end
end
     
function job_buff_change(buff, gain)
 
    if state.Buff[buff] ~= nil then
        handle_equipping_gear(player.status)
    end
    --AM
    if buff:startswith('Aftermath') then
        if player.equipment.main == 'Ukonvasara' or player.equipment.main == 'Farsha' then
            classes.CustomMeleeGroups:clear()
 
            if (buff == "Aftermath: Lv.3" and gain) or buffactive['Aftermath: Lv.3'] then
                update_melee_groups()
                add_to_chat(8, '-------------Empy AM3 Up---------------')
            elseif (buff == "Aftermath: Lv.3" and not gain) then
                add_to_chat(8, '-------------Empy AM3 Down-------------')
                update_melee_groups()
            end
 
            if not midaction() then
                handle_equipping_gear(player.status)
            end
        -- else
            -- classes.CustomMeleeGroups:clear()
 
            -- if buff == "Aftermath" and gain or buffactive.Aftermath then
                -- classes.CustomMeleeGroups:append('AM')
            -- end
        end
        --read binds section roll sets
    -- elseif (buff == "Samurai Roll") then
        -- classes.CustomMeleeGroups:clear()
         
        -- if (buff == "Samurai Roll" and gain) then
            -- update_melee_groups()
            -- add_to_chat(8, '-------------Samurai Roll Up---------------')
        -- elseif (buff == "Samurai Roll" and not gain) then
            -- add_to_chat(8, '-------------Samurai Roll Down-------------')
            -- update_melee_groups()
        -- end  
         
        -- if not midaction() then
            -- handle_equipping_gear(player.status)
        -- end
    -- elseif (buff == "Fighter's Roll") then
        -- classes.CustomMeleeGroups:clear()
         
        -- if (buff == "Fighter's Roll" and gain) then
            -- update_melee_groups()
            -- add_to_chat(8, '-------------Fighters Roll Up---------------')
        -- elseif (buff == "Fighter's Roll" and not gain) then
            -- add_to_chat(8, '-------------Fighters Roll Down-------------')
            -- update_melee_groups()
        -- end  
         
        -- if not midaction() then
            -- handle_equipping_gear(player.status)
        -- end
    end
    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /p Doomed.')
            disable('right_ring','waist')
        else
            enable('right_ring','waist')
            handle_equipping_gear(player.status)
        end
    end
end
 
-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
 
 
function update_combat_form()
    state.CombatForm:reset()
    if S{'NIN', 'DNC'}:contains(player.sub_job) and sub_weapons:contains(player.equipment.sub) then
        state.CombatForm:set("DW")
    elseif S{"Blurred Shield +1"}:contains(player.equipment.sub) then
        state.CombatForm:set("OneHand")
    -- elseif not sam_sj then
        -- state.CombatForm:set("SUB")
    -- else
        -- state.CombatForm:reset()
    end
end
 
function update_combat_weapon()
    state.CombatWeapon:reset()
    if Set1List:contains(player.equipment.main) then
        state.CombatWeapon:set("Set1")
    elseif Set2List:contains(player.equipment.main) then
        state.CombatWeapon:set("Set2")
    elseif Set3List:contains(player.equipment.main) then
        state.CombatWeapon:set("Set3")
    end
end
 
function update_melee_groups()
 
    classes.CustomMeleeGroups:clear()
    -- Empy AM  
    if buffactive['Aftermath: Lv.3'] then   
        if player.equipment.main == 'Ukonvasara' or player.equipment.main == 'Farsha' then
            classes.CustomMeleeGroups:append('AM3')
        end
    end
    --read binds section for roll sets
    -- if state.Roll.value == true then 
        -- if buffactive["Samurai Roll"] then
            -- classes.CustomMeleeGroups:append('Sam')
        -- end
        -- if buffactive["Fighter's Roll"] then
            -- classes.CustomMeleeGroups:append('War')
        -- end
    -- end
end
 
function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)  
end
 
function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then
        if type(tonumber(cmdParams[2])) == 'number' then
            if tonumber(cmdParams[2]) ~= DW_needed then
            DW_needed = tonumber(cmdParams[2])
            DW = true
            end
        elseif type(cmdParams[2]) == 'string' then
            if cmdParams[2] == 'false' then
                DW_needed = 0
                DW = false
            end
        end
        if type(tonumber(cmdParams[3])) == 'number' then
            if tonumber(cmdParams[3]) ~= Haste then
                Haste = tonumber(cmdParams[3])
            end
        end
        if type(cmdParams[4]) == 'string' then
            if cmdParams[4] == 'true' then
                moving = true
            elseif cmdParams[4] == 'false' then
                moving = false
            end
        end
        if not midaction() then
            job_update()
        end
    end
end
 
--prevents gearinfo from overriding a piece of gear you are trying to use
function check_gear()
    if no_swap_gear:contains(player.equipment.left_ring) then
        disable("left_ring")
    else
        enable("left_ring")
    end
    if no_swap_gear:contains(player.equipment.right_ring) then
        disable("right_ring")
    else
        enable("right_ring")
    end
    if no_swap_gear:contains(player.equipment.waist) then
        disable("waist")
    else
        enable("waist")
    end
end
 
windower.register_event('zone change',
    function()
        if no_swap_gear:contains(player.equipment.left_ring) then
            enable("left_ring")
            equip(sets.idle)
        end
        if no_swap_gear:contains(player.equipment.right_ring) then
            enable("right_ring")
            equip(sets.idle)
        end
        if no_swap_gear:contains(player.equipment.waist) then
            enable("waist")
            equip(sets.idle)
        end
    end
)
 
function check_moving()
    if state.DefenseMode.value == 'None'  and state.Kiting.value == false then
        if state.Auto_Kite.value == false and moving then
            state.Auto_Kite:set(true)
        elseif state.Auto_Kite.value == true and moving == false then
            state.Auto_Kite:set(false)
        end
    end
end
 
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(1, 9)
    elseif player.sub_job == 'SAM' then
        set_macro_page(1, 9)
    else
        set_macro_page(1, 9)
    end
end
 
-- function set_lockstyle()
    -- send_command('wait 3; input /lockstyleset ' .. lockstyleset)
-- end