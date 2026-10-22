extends Node

var PedastolItems:Array = []

func _ready() -> void:
	var dir := DirAccess.open("res://Resources/PedastolItems/ActiveItems/")
	if dir:
		for file_name in dir.get_files():
			if file_name.ends_with(".remap"):
				file_name = file_name.trim_suffix(".remap")
			var res_path = "res://Resources/PedastolItems/ActiveItems/" + file_name
			PedastolItems.append(res_path)
	dir = DirAccess.open("res://Resources/PedastolItems/PassiveItems/")
	if dir:
		for file_name in dir.get_files():
			if file_name.ends_with(".remap"):
				file_name = file_name.trim_suffix(".remap")
			var res_path = "res://Resources/PedastolItems/PassiveItems/" + file_name
			PedastolItems.append(res_path)
