function get_sets()

	sets.idle = {} 					-- Leave this empty
    sets.melee = {}                 -- Leave this empty
    sets.ws = {}                    -- Leave this empty
    sets.ja = {}                    -- Leave this empty
	sets.precast = {}               -- leave this empty    
    sets.midcast = {}               -- leave this empty    
    sets.aftercast = {}             -- leave this empty

    --[[sets.idle.normal = {
        main="Naegling",
        sub="Blurred Shield +1",
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head="Flam. Zucchetto +2",
        body="Flamma Korazin +2",
        hands="Sulev. Gauntlets +2",
        legs="Sulev. Cuisses +2",
        feet="Flam. Gambieras +2",
        neck={ name="War. Beads +1", augments={'Path: A',}},
        waist="Ioskeha Belt",
        left_ear="Brutal Earring",
        right_ear="Mache Earring +1",
        left_ring="Rajas Ring",
        right_ring="Flamma Ring",
        back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
    }]]
    sets.idle.normal = {
        main="Xiphos",
        sub="Aspis",
        body="Tarutaru Kaftan",
        hands="Tarutaru Mitts",
        legs="Tarutaru Braccae",
        feet="Tarutaru Clomps",
        left_ear="Raising Earring",
        left_ring=empty,
        right_ring=empty,
    }
    sets.precast.fastcast = {}
    sets.midcast.cure = {
        main="Xiphos",
        sub="Aspis",
        body="Tarutaru Kaftan",
        hands="Tarutaru Mitts",
        legs="Tarutaru Braccae",
        feet="Tarutaru Clomps",
        left_ear="Raising Earring",
        left_ring="Windurstian Ring",
        right_ring="Empress Band",
    }

end

function precast(spell)
	if  spell.type ~= 'JobAbility' then
        equip(sets.precast.casting)
    elseif sets.ja[spell.name] then
        equip(sets.ja[spell.name])        
    elseif sets.ws[spell.name] then
        equip(sets.ws[spell.name])        
    end         
end

function midcast(spell)
    if spell.type == "WhiteMagic" then
            if spell.skill == "Healing Magic" then
                equip(sets.midcast.cure)
            end
    else
        -- do something for when I cast non whitemagic spell
    end
end

function aftercast(spell)
    idle()
end

function idle()
    equip(sets.idle.normal)

end
 
function status_change(new,old)

end