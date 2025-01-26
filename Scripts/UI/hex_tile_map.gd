extends TileMap

const tile_map_layer = 0
const tile_map_atlas_id = 0


func find_connections():
	var possible = get_used_cells(tile_map_layer)
	possible = possible.filter(func(tile_pos:Vector2i): return get_cell_tile_data(tile_map_layer,tile_pos).get_custom_data("Occupied"))
	var connections_array = []
	while !possible.is_empty():
		var connections = hex_depth_first_search(possible[0])
		connections_array.append(connections)
		for c in connections:
			possible.erase(Vector2i(c))
	return connections_array


func hex_depth_first_search(tile_pos: Vector2):
	var stack : Array[Vector2] = [tile_pos]
	var visited : Array[Vector2] = []
	
	while !stack.is_empty():
		var pos = stack.pop_front()
		if !visited.has(pos):
			visited.append(pos)
			var neighbours = Methods.get_adjacent_hexes(pos)
			neighbours = neighbours.filter(func(tile_pos:Vector2): return get_cell_tile_data(tile_map_layer,tile_pos) and get_cell_tile_data(tile_map_layer,tile_pos).get_custom_data("Occupied"))
			for n in neighbours:
				if !visited.has(n):
					stack.append(n)
	
	return visited
	
