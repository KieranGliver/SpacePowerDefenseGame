extends Node

# returns 5 closest nodes in group tag to position
func find_closest(tag: String, origin: Vector2):
	var node_group = get_tree().get_nodes_in_group(tag)
	var closest_nodes: Array[Node] = [null, null, null, null, null]
	var closest_position : Array[Vector2] = [Vector2.INF, Vector2.INF, Vector2.INF, Vector2.INF, Vector2.INF]
	
	for node in node_group:
		for index in closest_nodes.size():
			if origin.distance_to(node.global_position) < origin.distance_to(closest_position[index]):
				closest_nodes = array_insert_push(index, closest_nodes, node)
				closest_position = array_insert_push(index, closest_position, node.global_position)
				break
	
	return closest_nodes

func array_insert_push(index: int, base_array, item):
	var new_array = base_array
	var array_end = new_array.slice(index,-1)
	new_array.resize(index)
	new_array.append(item)
	new_array.append_array(array_end)
	return new_array

func get_adjacent_hexes(tile_pos: Vector2):
	var i = tile_pos.x
	var j = tile_pos.y
	if fmod(i, 2) == 0:
		return [Vector2(i-1,j-1), Vector2(i,j-1), Vector2(i+1,j-1), Vector2(i+1,j), Vector2(i,j+1), Vector2(i-1,j)]
	else:
		return [Vector2(i-1,j), Vector2(i,j-1), Vector2(i+1,j), Vector2(i+1,j+1), Vector2(i,j+1), Vector2(i-1,j+1)]
