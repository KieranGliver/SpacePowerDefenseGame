extends Node

# returns 5 closest nodes in group tag to position as an array of Vector2
func find_closest(tag: String, pos: Vector2):
	var enemy_position = get_tree().get_nodes_in_group(tag).map(func(n: Node2D): return n.global_position)
	var closest: Array[Vector2] = [Vector2.INF, Vector2.INF, Vector2.INF, Vector2.INF, Vector2.INF]
	
	for p in enemy_position:
		for i in closest.size():
			if pos.distance_to(p) < pos.distance_to(closest[i]):
				var array_end = closest.slice(i,-1)
				closest.resize(i)
				closest.append(p)
				closest.append_array(array_end)
				break
	
	return closest

func get_adjacent_hexes(tile_pos: Vector2):
	var i = tile_pos.x
	var j = tile_pos.y
	if fmod(i, 2) == 0:
		return [Vector2(i-1,j-1), Vector2(i,j-1), Vector2(i+1,j-1), Vector2(i+1,j), Vector2(i,j+1), Vector2(i-1,j)]
	else:
		return [Vector2(i-1,j), Vector2(i,j-1), Vector2(i+1,j), Vector2(i+1,j+1), Vector2(i,j+1), Vector2(i-1,j+1)]
