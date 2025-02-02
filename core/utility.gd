extends Node
class_name Utility
# Common helper functions


static func get_random_microgame(microgame_definitions : Array) -> MicrogameDefinition:
	return microgame_definitions[randi() % microgame_definitions.size()]


static func find_by_class(node: Node, className: String, result: Array) -> void:
	if node.is_class(className):
		result.push_back(node)
	for child in node.get_children():
		find_by_class(child, className, result)


static func find_microgame_definitions_in_dir(directory_to_search : String = "res://microgames/") -> Array:
	var microgame_defs := []

	for file in list_all_files(directory_to_search, "tres"):
		var definition: Resource = load(file)
		if definition is MicrogameDefinition:
			microgame_defs.append(definition)
	return microgame_defs


static func get_definition_from_microgame_scene(scene_path) -> MicrogameDefinition:
	return find_microgame_definitions_in_dir(scene_path.get_base_dir())[0]


static func list_all_files(path: String, extension: String = "") -> Array:
	path = path.trim_suffix("/")

	var filter: bool = extension != ""
	var files: Array = []

	var dir: Directory = Directory.new()
	if dir.open(path) != OK:
		return files
	dir.list_dir_begin(true, true)

	while true:
		var file: String = dir.get_next()
		var is_directory: bool = dir.current_is_dir()
		if file == "":
			break
		file = "%s/%s" % [path, file]
		if is_directory:
			files.append_array(list_all_files(file, extension))
		elif not filter or file.get_extension() == extension:
			files.append(file)

	dir.list_dir_end()

	return files
