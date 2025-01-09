extends Control


func _ready() -> void:
	Global.upgrade_handler = self
	visible = false

func open():
	visible = true
