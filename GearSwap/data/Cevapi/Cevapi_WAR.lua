function user_setup()

    state.Auto_Kite = M(false, 'Auto_Kite')  
    Haste = 0
    DW_needed = 0  
    DW = false  
    moving = false  
    update_combat_form()  
    determine_haste_group()  
  
  end 
  
  function job_handle_equipping_gear(playerStatus, eventArgs)
      
      update_combat_form()
      determine_haste_group()
      check_moving()
  
  end
    
  function customize_idle_set(idleSet) 
      if state.Auto_Kite.value == true then  
         idleSet = set_combine(idleSet, sets.Kiting)  
      end  
      return idleSet  
  end
  
  function job_update(cmdParams, eventArgs) 
    handle_equipping_gear(player.status)  
  end
  
  function update_combat_form()  
      if DW == true then  
          state.CombatForm:set('DW')  
      elseif DW == false then  
          state.CombatForm:reset()  
      end  
  end
  
  function check_moving()
      if state.DefenseMode.value == 'None'  and state.Kiting.value == false then
          if state.Auto_Kite.value == false and moving then
              state.Auto_Kite:set(true)
          elseif state.Auto_Kite.value == true and moving == false then
              state.Auto_Kite:set(false)
          end
      end
  end

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
        ammo= "Coiste Bodhar",
        head="Flam. Zucchetto +2",
        body="Flamma Korazin +2",
        hands="Sulev. Gauntlets +2",
        legs="Pumm. Cuisses +2",
        feet="Flam. Gambieras +2",
        neck={ name="War. Beads +1", augments={'Path: A',}},
        waist="Sailfi belt +1",
        left_ear="Brutal Earring",
        right_ear="Mache Earring +1",
        left_ring="Chirich Ring +1",
        right_ring="Chirich Ring +1",
        back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
    }
    sets.precast.fastcast = {}
    sets.midcast.cure = {}

    sets.ja.Berserk = set_combine(sets.idle.normal,
     {
        body="Pumm. Lorica +2",
        --sub="Diamond aspis",
        --feet="Agoge Calligae +1"
    })
    sets.ja.Aggressor = set_combine(sets.idle.normal, 
    {
        --head="Pumm. Mask +1", 
        --sub="Diamond aspis",
        body="Agoge Lorica +1"
    })
    sets.ja.Warcry = set_combine(sets.idle.normal, 
    {
        head="Agoge Mask +3",
        -- sub="Diamond aspis",
    })
    sets.ja.Tomahawk = set_combine(sets.idle.normal, {
        ammo="Thr. Tomahawk",
        --feet="Agoge Calligae +1"
    })

    sets.ws['Savage Blade'] = {
        main="Naegling",
        sub="Blurred Shield +1",
        ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
        head="Agoge Mask +3",
        body="Pumm. Lorica +2",
        hands="Sulev. Gauntlets +2",
        legs="Sulev. Cuisses +2",
        feet="Sulev. Leggings +2",
        neck={ name="War. Beads +1", augments={'Path: A',}},
        waist="Sailfi belt +1",
        left_ear="Thrud Earring",
        right_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
        left_ring="Rajas Ring",
        right_ring="Flamma Ring",
        back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
    }
    sets.ws['Requiescat'] = {
        main="Naegling",
        sub="Blurred Shield +1",
        ammo="Coiste Bodhar",
        head="Agoge Mask +3",
        body="Pumm. Lorica +2",
        hands="Sulev. Gauntlets +2",
        legs="Sulev. Cuisses +2",
        feet="Sulev. Leggings +2",
        neck={ name="War. Beads +1", augments={'Path: A',}},
        waist="Sailfi belt +1",
        left_ear="Thrud Earring",
        right_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
        left_ring="Rajas Ring",
        right_ring="Petrov Ring",
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
    idle()
end