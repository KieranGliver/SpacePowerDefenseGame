extends TileMap

const outer_rim = [Vector2(0,-3), Vector2(1,-3), Vector2(2,-2), Vector2(3,-2), Vector2(3,-1), Vector2(3,0), Vector2(3,1), Vector2(2,2), Vector2(1,2), Vector2(0,3), Vector2(-1,2), Vector2(-2,2), Vector2(-3,1), Vector2(-3,0), Vector2(-3,-1), Vector2(-3,-2), Vector2(-2,-2), Vector2(-1,-3)]
var ore_tiles = {}

func _ready():
	add_ore()

func add_ore():
	var possible_tiles = outer_rim.duplicate()
	for i in 5:
		var picked_tile = possible_tiles.pick_random()
		set_cell(Data.TILE_MAP_LAYER, picked_tile, Data.TILE_MAP_ATLAS_ID, Vector2(Data.hex_ids.ORE, 0))
		possible_tiles.erase(picked_tile)
		ore_tiles.merge({picked_tile: 10.1})

func is_building(tile_pos:Vector2):
	return get_cell_tile_data(Data.TILE_MAP_LAYER,tile_pos) and get_cell_tile_data(Data.TILE_MAP_LAYER,tile_pos).get_custom_data("Occupied")
	

func find_connections():
	var possible = get_used_cells(Data.TILE_MAP_LAYER).filter(is_building)
	var connections_array = []
	while !possible.is_empty():
		var connections = hex_depth_first_search(possible[0])
		# must make sure that each connection being check does contain a building
		var connected_buildings = connections.map(Methods.find_building)
		
		connections_array.append(connected_buildings)
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
			neighbours = neighbours.filter(is_building)
			for n in neighbours:
				if !visited.has(n):
					stack.append(n)
	
	return visited
	
