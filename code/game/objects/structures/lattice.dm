/obj/structure/lattice
	name = "lattice"
	desc = "A lightweight support lattice."
	icon = 'icons/obj/smooth_structures/lattice.dmi'
	icon_state = "lattice"
	density = FALSE
	anchored = TRUE
	armor = list(melee = 50, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0, fire = 80, acid = 50)
	
	max_integrity = 50
	layer = LATTICE_LAYER //under pipes
	plane = FLOOR_PLANE
	var/number_of_rods = 1
	canSmoothWith = list(/obj/structure/lattice,
						/turf/simulated/floor,
						/turf/simulated/wall,
						/obj/structure/falsewall)
	smooth = SMOOTH_MORE

/obj/structure/lattice/Initialize(mapload)
	. = ..()
	for(var/obj/structure/lattice/LAT in loc)
		if(LAT != src)
			QDEL_IN(LAT, 0)

/obj/structure/lattice/examine(mob/user)
	..()
	deconstruction_hints(user)

/obj/structure/lattice/proc/deconstruction_hints(mob/user)
	to_chat(user, "<span class='notice'>The rods look like they could be <b>cut</b>. There's space for more <i>rods</i> or a <i>tile</i>.</span>")

/obj/structure/lattice/attackby(obj/item/C, mob/user, params)
	if(resistance_flags & INDESTRUCTIBLE)
		return
	if(istype(C, /obj/item/wirecutters))
		to_chat(user, "<span class='notice'>Slicing [name] joints...</span>")
		deconstruct()
	else
		var/turf/T = get_turf(src)
		return T.attackby(C, user) //hand this off to the turf instead (for building plating, catwalks, etc)

/obj/structure/lattice/deconstruct(disassembled = TRUE)
	if(!(resistance_flags & INDESTRUCTIBLE))
		new /obj/item/stack/rods(get_turf(src), number_of_rods)
	qdel(src)

/obj/structure/lattice/attackby(obj/item/C as obj, mob/user as mob, params)
	if(istype(C, /obj/item/stack/tile/plasteel) || istype(C, /obj/item/stack/rods))
		var/turf/T = get_turf(src)
		T.attackby(C, user) //BubbleWrap - hand this off to the underlying turf instead
		return
	if(istype(C, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = C
		if(WT.remove_fuel(0, user))
			to_chat(user, "<span class='notice'>Slicing lattice joints...</span>")
			deconstruct(TRUE)

/obj/structure/lattice/deconstruct(disassembled = TRUE)
	if(!(flags & NODECONSTRUCT))
		new /obj/item/stack/rods(src.loc)
	qdel(src)

/obj/structure/lattice/catwalk
	name = "catwalk"
	desc = "A catwalk for easier EVA maneuvering and cable placement."
	icon = 'icons/obj/smooth_structures/catwalk.dmi'
	icon_state = "catwalk"
	number_of_rods = 2
	smooth = SMOOTH_TRUE
	canSmoothWith = null

/obj/structure/lattice/catwalk/deconstruction_hints(mob/user)
	to_chat(user, "<span class='notice'>The supporting rods look like they could be <b>cut</b>.</span>")

/obj/structure/lattice/catwalk/Move()
	var/turf/T = loc
	for(var/obj/structure/cable/C in T)
		C.deconstruct()
	..()

/obj/structure/lattice/singularity_pull(S, current_size)
	if(current_size >= STAGE_FOUR)
		deconstruct()
		
/obj/structure/lattice/catwalk/deconstruct()
	var/turf/T = loc
	for(var/obj/structure/cable/C in T)
		C.deconstruct()
	..()
