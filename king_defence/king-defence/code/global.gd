extends Node

var actors = []
func get_actors_by_type():
	var actor_set = {0:[],1:[],2:[]}
	for i in actors:
		if !actor_set.has(i.type):
			actor_set[i.type] = [i]
		else:
			actor_set[i.type].append(i)
	return actor_set
