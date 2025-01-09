extends Node2D

class_name stat

var stat_name = ""
var value = 0

func update(stat_name, value):
	$sprite.play(stat_name)
	self.stat_name = stat_name
	self.value = value
	$name.text = str(stat_name).capitalize()
	$num.text = str(value)
	position.x = 8 if Stats.selected_stat == self else 0


func _on_but_pressed() -> void:
	if Stats.selected_stat == self:
		Stats.selected_stat = null
	elif value > 0:
		Stats.selected_stat = self
	Stats.update()
