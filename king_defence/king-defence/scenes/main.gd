extends Node

func _ready() -> void:
	update()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("step"):
		play = !play
		if !play:
			update()

var play = false

var frame = 0
func _physics_process(delta: float) -> void:
	if !play:
		return
	frame += 1
	if frame % 16 == 0:
		Navigator.step_movement()
	if frame % 60 == 0:
		update()

func update():
	var posses = Navigator.update_navmaps()
	return
	for i in $Node.get_children():
		i.queue_free()
	for i in posses:
		var icon = preload("res://icon.tscn").instantiate()
		$Node.add_child(icon)
		icon.position = i*Navigator.cell_width
