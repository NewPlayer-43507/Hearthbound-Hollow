extends Control

@onready var Main = $"Main Menu"
@onready var Settings = $Settings


func _on_start_pressed() -> void:
	GeneralGlobals.Players.clear()
	var scene = load("res://Scenes/Main.tscn")
	scene = scene.instantiate()
	$Between.show()
	var t = get_tree().create_tween()
	t.tween_property($Between, "modulate", Color(0.0, 0.0, 0.0, 1.0), 1)
	await get_tree().create_timer(1).timeout
	get_tree().get_root().add_child(scene)
	queue_free()
	

func _on_settings_pressed() -> void:
	$"Main Menu".hide()
	$Settings.show()


func _on_back_pressed() -> void:
	$Settings.hide()
	$"Main Menu".show()


func _on_quit_pressed() -> void:
	get_tree().quit(0)
