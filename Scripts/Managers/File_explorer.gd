extends Node

func traverse_directory(dir_path:String):
	
	var dir = DirAccess.open(dir_path)
	var ret = []
	dir.list_dir_begin() # needs to close with list_dir_end()
	var element_name = dir.get_next()
	
	while element_name != "": # automatically closes when this is true
		
		var file_path = dir_path + "/" + element_name
		
		if dir.current_is_dir():
			ret.append_array(traverse_directory(file_path))
		else:
			ret.append(file_path)
		
		element_name = dir.get_next()
	
	return ret
