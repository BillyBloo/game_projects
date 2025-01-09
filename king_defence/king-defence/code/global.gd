extends Node

enum states {
	place_units,
	battle,
	pick_upgrades,
	menu
}
var state : states = states.place_units
func get_state_string():
	match state:
		states.place_units:
			return "place_units"
		states.battle:
			return "battle"
		states.pick_upgrades:
			return "pick_upgrades"
		states.menu:
			return "menu"
	return "other"

var upgrade_handler : Control
func ping_state():
	match state:
		states.pick_upgrades:
			upgrade_handler.open()

var origin_pos : Vector2

var held_actor : actor = null
var actors = []
func get_actors_by_type():
	var actor_set = {0:[],1:[],2:[]}
	for i in range(actors.size()-1,-1,-1):
		var act : actor = actors[i]
		if act.dead:
			continue
		if !actor_set.has(act.type):
			actor_set[act.type] = [act]
		else:
			actor_set[act.type].append(act)
	return actor_set

func get_actors_by_cell():
	var actor_set = {}
	for i in actors.size():
		var act : actor = actors[i]
		if act.dead:
			continue
		var cell : Vector2 = act.get_cell()
		if !actor_set.has(cell):
			actor_set[cell] = [act]
		else:
			actor_set[cell].append(act)
	return actor_set

func cull():
	for i in range(actors.size()-1,-1,-1):
		var act : actor = actors[i]
		if act.dead:
			act.kill()

func is_day():
	for i in actors:
		if i.type == 2:
			return false
	return true
