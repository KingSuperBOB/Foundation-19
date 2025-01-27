
/obj/structure/deity/pylon
	name = "pylon"
	desc = "A crystal platform used to communicate with the deity."
	build_cost = 400
	icon_state = "pylon"
	var/list/intuned = list()

/obj/structure/deity/pylon/attack_deity(mob/living/deity/D)
	if(D.pylon == src)
		D.leave_pylon()
	else
		D.possess_pylon(src)

/obj/structure/deity/pylon/Destroy()
	if(linked_god && linked_god.pylon == src)
		linked_god.leave_pylon()
	return ..()

/obj/structure/deity/pylon/attack_hand(mob/living/L)
	if(!linked_god)
		return
	if(L in intuned)
		remove_intuned(L)
	else
		add_intuned(L)

/obj/structure/deity/pylon/proc/add_intuned(mob/living/L)
	if(L in intuned)
		return
	to_chat(L, SPAN_NOTICE("You place your hands on \the [src], feeling yourself intune to its vibrations."))
	intuned += L
	GLOB.destroyed_event.register(L,src,TYPE_PROC_REF(/obj/structure/deity/pylon, remove_intuned))

/obj/structure/deity/pylon/proc/remove_intuned(mob/living/L)
	if(!(L in intuned))
		return
	to_chat(L, SPAN_WARNING("You no longer feel intuned to \the [src]."))
	intuned -= L
	GLOB.destroyed_event.unregister(L, src)


/obj/structure/deity/pylon/hear_talk(mob/M as mob, text, verb, datum/language/speaking)
	if(!linked_god)
		return
	if(linked_god.pylon != src)
		if(!(M in intuned))
			return
		for(var/obj/structure/deity/pylon/P in linked_god.structures)
			if(P == src || linked_god.pylon == P)
				continue
			P.audible_message("<b>\The [P]</b> resonates, \"[text]\"")
	to_chat(linked_god, "\icon[src] <span class='game say'><span class='name'>[M]</span> (<A href='?src=\ref[linked_god];jump=\ref[src];'>P</A>) [verb], [linked_god.pylon == src ? "<b>" : ""]<span class='message'><span class='body'>\"[text]\"</span></span>[linked_god.pylon == src ? "</b>" : ""]</span>")
