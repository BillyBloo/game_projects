extends Node2D

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("start"):
		Global.state = Global.states.battle
		Stats.update()
var frame = 0
var can_update = true
func _physics_process(delta: float) -> void:
	if !Global.get_state_string() == "battle":
		return
	
	Stats.selected_stat == null
	frame += 1
	if frame % 4 == 0:
		Navigator.push_apart(5)
	if frame % 8 == 0:
		Navigator.step_movement()
	if frame % 15 == 0:
		var actors = Global.get_actors_by_type()
		if actors[1].size() == 0 or actors[2].size() == 0:
			Global.state = Global.states.pick_upgrades
			Global.ping_state()
	if can_update:
		update()

func update():
	can_update = false
	var posses = await Navigator.update_navmaps()
	#for i in $Node.get_children():
		#i.queue_free()
	#for i in posses:
		#var icon = preload("res://icon.tscn").instantiate()
		#$Node.add_child(icon)
		#icon.position = i*Navigator.cell_width
	can_update = true
