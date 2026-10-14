extends Button


func _on_pressed() -> void:
	var scene = load("res://Scenes/menu.tscn")
	scene = scene.instantiate()
	get_tree().get_root().add_child(scene)
	get_node("/root/Main").queue_free()
