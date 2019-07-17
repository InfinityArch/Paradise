//Languages/species/whitelist. //Languages and species fit with mobs right
GLOBAL_LIST_EMPTY(all_species)
GLOBAL_LIST_EMPTY(all_languages)
GLOBAL_LIST_EMPTY(language_keys)					// Table of say codes for all languages
GLOBAL_LIST_EMPTY(all_superheroes)
GLOBAL_LIST_INIT(whitelisted_species, list())

GLOBAL_LIST_INIT(clients, list())							//list of all clients
GLOBAL_LIST_INIT(admins, list())							//list of all clients whom are admins
GLOBAL_LIST_INIT(deadmins, list())							//list of all clients who have used the de-admin verb.
GLOBAL_LIST_INIT(directory, list())							//list of all ckeys with associated client
GLOBAL_LIST_INIT(stealthminID, list())						//reference list with IDs that store ckeys, for stealthmins

//Since it didn't really belong in any other category, I'm putting this here
//This is for procs to replace all the goddamn 'in world's that are chilling around the code

GLOBAL_LIST_INIT(player_list, list())				//List of all mobs **with clients attached**. Excludes /mob/new_player
GLOBAL_LIST_INIT(mob_list, list())					//List of all mobs, including clientless
GLOBAL_LIST_INIT(silicon_mob_list, list())			//List of all silicon mobs, including clientless
GLOBAL_LIST_INIT(spirits, list())					//List of all the spirits, including Masks
GLOBAL_LIST_INIT(living_mob_list, list())			//List of all alive mobs, including clientless. Excludes /mob/new_player
GLOBAL_LIST_INIT(dead_mob_list, list())				//List of all dead mobs, including clientless. Excludes /mob/new_player
GLOBAL_LIST_INIT(respawnable_list, list())			//List of all mobs, dead or in mindless creatures that still be respawned.
GLOBAL_LIST_INIT(non_respawnable_keys, list())	//List of ckeys that are excluded from respawning for remainder of round.
GLOBAL_LIST_INIT(simple_animals, list(list(), list(), list(), list()))			//One for each AI_* status define, List of all simple animals, including clientless
GLOBAL_LIST_INIT(bots_list, list()) 					//List of all bots(beepsky, medibots,etc)

GLOBAL_LIST_INIT(med_hud_users, list())
GLOBAL_LIST_INIT(sec_hud_users, list())
GLOBAL_LIST_INIT(antag_hud_users, list())
GLOBAL_LIST_INIT(surgeries_list, list())
GLOBAL_LIST_INIT(hear_radio_list, list())			//Mobs that hear the radio even if there's no client
GLOBAL_LIST_EMPTY(mob_config_movespeed_type_lookup)

/proc/update_config_movespeed_type_lookup(update_mobs = TRUE)
	var/list/movespeeds = list()
	var/value = 0
	for(var/paths in config.multiplicative_movespeeds)
		value = config.multiplicative_movespeeds[paths]
		for(var/P in typesof(paths))
			movespeeds[P] = value
	GLOB.mob_config_movespeed_type_lookup = movespeeds
	if(update_mobs)
		update_mob_config_movespeeds()
/proc/update_mob_config_movespeeds()
	for(var/i in GLOB.mob_list)
		var/mob/M = i
		M.update_config_movespeed()