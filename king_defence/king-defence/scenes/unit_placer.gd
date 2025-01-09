extends Node2D

var min = 2
var max = 13

func _physics_process(delta: float) -> void:
	if Global.get_state_string() != "place_units":
		Stats.selected_stat = null
	else:
		if Global.held_actor != null:
			if !Input.is_action_pressed("m1"):
				Global.held_actor = null
				return
			var pos = get_global_mouse_position()
			
			pos = Vector2(round(pos.x / Navigator.cell_width),round(pos.y / Navigator.cell_width)) * Navigator.cell_width
			pos.x = clamp(pos.x / Navigator.cell_width,min,max)*Navigator.cell_width
			pos.y = clamp(pos.y / Navigator.cell_width,min,max)*Navigator.cell_width
				
			Global.held_actor.target_pos = pos
			Global.held_actor.position = lerp(Global.held_actor.position,pos,0.3)
			Global.held_actor.pos = Global.held_actor.position
		else:
			if Input.is_action_pressed("m1"):
				if Stats.selected_stat != null:
					var pos = get_global_mouse_position()
					if !pos_in_bounds(pos):
						return
					var actors = Global.get_actors_by_cell()
					if actors.has(get_cell(pos)):
						return
					if Stats.selected_stat.value <= 0:
						return
					var unit : actor = load("res://scenes/actors/" + Stats.selected_stat.stat_name + ".tscn").instantiate()
					unit.type = 1
					unit.position = pos
					get_tree().get_root().add_child(unit)
					Stats.update()
func pos_in_bounds(pos : Vector2):
	var cell = (pos) / Navigator.cell_width
	cell.x = round(cell.x)
	cell.y = round(cell.y)
	if cell.x < min or cell.x > max or cell.y < min or cell.y > max:
		return false
	return true
func get_cell(pos : Vector2):
	return Vector2(round(pos.x / Navigator.cell_width), round(pos.y / Navigator.cell_width))
