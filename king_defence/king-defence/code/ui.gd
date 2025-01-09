extends CanvasLayer



func _on_play_pressed() -> void:
	Global.state = Global.states.place_units
	Stats.update()
