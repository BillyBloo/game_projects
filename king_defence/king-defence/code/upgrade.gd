extends Node

class_name upgrade

var upgrade_name = ""
var given_units = {}

func set_data(nem, units):
	given_units = units
	upgrade_name = nem
