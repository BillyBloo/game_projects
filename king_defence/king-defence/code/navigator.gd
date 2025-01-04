extends Node

var cell_width = 32

var tl : Vector2
var br : Vector2
var boundary = 1

var navmap_to_friendlies : navmap 
var navmap_to_enemies : navmap

func update_navmaps():
	#navmap_to_friendlies.queue_free()
	#navmap_to_enemies.queue_free()
	
	tl = Vector2(1000,1000)
	br = Vector2(-1000,-1000)
	var actors = Global.get_actors_by_type()
	var solid = get_cells(actors[0])
	var friendly = get_cells(actors[1])
	var enemy = get_cells(actors[2])
	
	tl -= Vector2(boundary,boundary)
	br += Vector2(boundary,boundary)
	
	navmap_to_friendlies = generate_navmap(friendly,solid+enemy,get_cells(actors[2]),60)
	navmap_to_enemies = generate_navmap(enemy,solid+friendly,get_cells(actors[1]),60)
	
	return navmap_to_enemies.map.keys() + navmap_to_friendlies.map.keys()

func step_movement():
	var actors = Global.get_actors_by_type()
	var solid = get_cells(actors[0])
	var friendly = get_cells(actors[1])
	var enemy = get_cells(actors[2])
	var taken_cells = {}
	taken_cells = move_with(actors[1], navmap_to_enemies, taken_cells)
	taken_cells = move_with(actors[2], navmap_to_friendlies, taken_cells)

func move_with(actors, map, taken_cells):
	for i in actors:
		var cell = i.get_cell()
		if !map.map.has(cell):
			continue
		var target_cell = cell + map.map[cell]
		if map.best_dists[cell] > 1.5 and !taken_cells.has(target_cell):
			i.move(map.map[cell])
			taken_cells[target_cell] = i
	return taken_cells

func get_cells(actors):
	var out = []
	for i in actors:
		var cell = i.get_cell()
		tl = Vector2(min(tl.x,cell.x), min(tl.y,cell.y))
		br = Vector2(max(br.x,cell.x), max(br.y,cell.y))
		out.append(cell)
	return out

#func get_cells_by_type(actors, type):
	#var out = []
	#for i in actors:
		#if (i as actor).type == type:
			#out.append(i.get_cell())
	#return out

func generate_navmap(zero_set, solid_set, terminal_set,d):
	var nav = navmap.new()
	for i in zero_set:
		nav.add(i,Vector2.ZERO)
	return add_neighbours(nav,solid_set, terminal_set,d)

const NEIGHBOURS = [Vector2(-1,-1), Vector2(0,-1), Vector2(1,-1),
					Vector2(-1,0), Vector2(1,0),
					Vector2(-1,1), Vector2(0,1), Vector2(1,1)]
#const NEIGHBOURS = [Vector2(0,-1),
					#Vector2(-1,0), Vector2(1,0),
					#Vector2(0,1)]
func add_neighbours(nav : navmap, solid_set, terminal_set, d):
	var unchecked = nav.unchecked.keys()
	if unchecked.size() == 0:
		return nav
	for u in min(unchecked.size(),terminal_set.size()):
		var best = 0
		for i in unchecked.size():
			if nav.best_dists[unchecked[i]] < nav.best_dists[unchecked[best]]:
				best = i
		var from_cell = unchecked[best]
		unchecked.remove_at(best)
		nav.check(from_cell)
		if from_cell in terminal_set:
			terminal_set.erase(from_cell)
			if terminal_set.size() == 0:
				break
		if solid_set.has(from_cell):
			continue
		for j in NEIGHBOURS:
			var cell : Vector2 = from_cell - j
			if nav.map.has(cell) and nav.best_dists[cell] < nav.best_dists[from_cell]+j.length():
				continue
			if cell.x < tl.x or cell.y < tl.y or cell.x > br.x or cell.y > br.y:
				continue
			nav.add(cell,j)
	if d == 0 or terminal_set.size() == 0:
		return nav
	else:
		return add_neighbours(nav, solid_set, terminal_set, d-1)

func eval(goal_dir, i_dir):
	var val = 0
	if pos(goal_dir.x) * pos(i_dir.x) > 0:
		val += 1
	if pos(goal_dir.y) * pos(i_dir.y) > 0:
		val += 1
	return val
func pos(a):
	if a > 0:
		return 1
	elif a < 0:
		return -1
	return 0
