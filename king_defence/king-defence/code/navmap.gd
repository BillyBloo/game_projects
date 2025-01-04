extends Node

class_name navmap

var map = {}
var best_dists = {}
var unchecked = {}

func add(cell, dir):
	map[cell] = dir
	var from_cell = cell + dir
	var from_dist = best_dists[from_cell] if best_dists.has(from_cell) else 0
	if best_dists.has(from_cell):
		best_dists[cell] = best_dists[from_cell] + dir.length()
	else:
		best_dists[cell] = dir.length()
	unchecked[cell] = null

func check(cell):
	unchecked.erase(cell)
