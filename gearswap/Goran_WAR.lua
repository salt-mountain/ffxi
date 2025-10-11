function get_sets()

	sets.idle = {} 					-- Leave this empty
    sets.melee = {}                 -- Leave this empty
    sets.ws = {}                    -- Leave this empty
    sets.ja = {}                    -- Leave this empty
	sets.precast = {}               -- leave this empty    
    sets.midcast = {}               -- leave this empty    
    sets.aftercast = {}             -- leave this empty

    sets.idle.normal = {
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
    }
    sets.precast.fastcast = {}
    sets.midcast.cure = {}

    sets.ja.Berserk = set_combine(sets.idle.normal,
     {
        body="Pumm. Lorica +1",
        sub="Diamond aspis",
        --feet="Agoge Calligae +1"
    })
    --[[sets.ja.Aggressor = set_combine(sets.idle.normal, 
    {
        head="Pumm. Mask +1", 
        sub="Diamond aspis",
        body="Agoge Lorica +1"
    })]]
    sets.ja.Warcry = set_combine(sets.idle.normal, 
    {
        head="Agoge Mask +1",
        sub="Diamond aspis",
    })
    sets.ja.Tomahawk = set_combine(sets.idle.normal, {
        ammo="Thr. Tomahawk",
        --feet="Agoge Calligae +1"
    })

    sets.ws['Savage Blade'] = {
        main="Naegling",
        sub="Blurred Shield +1",
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head="Flam. Zucchetto +2",
        body="Pumm. Lorica +1",
        hands="Sulev. Gauntlets +2",
        legs="Sulev. Cuisses +2",
        feet="Sulev. Leggings +2",
        neck={ name="War. Beads +1", augments={'Path: A',}},
        waist="Ioskeha Belt",
        left_ear="Thrud Earring",
        right_ear="Mache Earring +1",
        left_ring="Rajas Ring",
        right_ring="Flamma Ring",
        back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
    }

end

function precast(spell)
    if spell.type == 'WeaponSkill' and sets.ws[spell.english] then
        equip(sets.ws[spell.english])
        return
    end

    if spell.type == 'JobAbility' and sets.ja[spell.english] then
        equip( set_combine(sets.idle.normal, sets.ja[spell.english]) )
    end
end

function midcast(spell)

end

function aftercast(spell)
    idle()
end

function idle()
    equip(sets.idle.normal)
end
 
function status_change(new,old)


end
