/mob/living/carbon/hitby(atom/movable/AM, skipcatch, hitpush = 1, blocked = 0)
	if(!skipcatch)
		if(in_throw_mode && canmove && !restrained())  //Makes sure player is in throw mode
			if(!istype(AM,/obj/item) || !isturf(AM.loc))
				return FALSE
			if(get_active_hand())
				return FALSE
			if(istype(AM, /obj/item/twohanded))
				if(get_inactive_hand())
					return FALSE
			put_in_active_hand(AM)
			visible_message("<span class='warning'>[src] catches [AM]!</span>")
			throw_mode_off()
			return TRUE
	..()

/mob/living/carbon/water_act(volume, temperature, source)
	if(volume > 10) //anything over 10 volume will make the mob wetter.
		wetlevel = min(wetlevel + 1,5)
	..()


/mob/living/carbon/attackby(obj/item/I, mob/user, params)
	if(lying && surgeries.len)
		if(user != src && user.a_intent == INTENT_HELP)
			for(var/datum/surgery/S in surgeries)
				if(S.next_step(user, src))
					return 1
	return ..()

/mob/living/carbon/attack_hand(mob/living/carbon/human/user)
	if(!iscarbon(user))
		return

	for(var/thing in viruses)
		var/datum/disease/D = thing
		if(D.IsSpreadByTouch())
			user.ContractDisease(D)

	for(var/thing in user.viruses)
		var/datum/disease/D = thing
		if(D.IsSpreadByTouch())
			ContractDisease(D)

	if(lying && surgeries.len)
		if(user.a_intent == INTENT_HELP)
			for(var/datum/surgery/S in surgeries)
				if(S.next_step(user, src))
					return 1
	return 0

/mob/living/carbon/attack_slime(mob/living/carbon/slime/M)
	if(..())
		var/power = M.powerlevel + rand(0,3)
		Weaken(power)
		Stuttering(power)
		Stun(power)
		var/stunprob = M.powerlevel * 7 + 10
		if(prob(stunprob) && M.powerlevel >= 8)
			adjustFireLoss(M.powerlevel * rand(6,10))
			updatehealth("slime attack")
		return 1

/mob/living/carbon/is_mouth_covered(head_only = FALSE, mask_only = FALSE)
	if((!mask_only && head && (head.flags_cover & HEADCOVERSMOUTH)) || (!head_only && wear_mask && (wear_mask.flags_cover & MASKCOVERSMOUTH)))
		return TRUE

/mob/living/carbon/damage_clothes(damage_amount, damage_type = BRUTE, damage_flag = 0, def_zone)
	var/bodypart_bit = 0
	if(def_zone)
		bodypart_bit = body_zone2body_parts_covered(def_zone)
	for(var/X in get_equipped_items())
		var/obj/item/I = X
		if(I.body_parts_covered & bodypart_bit)
			I.take_damage(0.5*damage_amount, damage_type, damage_flag, 0)
			//0.5 multiplier for balance reason, we don't want clothes to be too easily destroyed
