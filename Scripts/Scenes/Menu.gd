extends Control

@onready var Main = $"Main Menu"
@onready var Settings = $Settings

var PlayerScenes = preload("res://Scenes/player_button.tscn")

var CurrentSelections:Dictionary[int, Character] = {}

func _ready() -> void:
	GeneralGlobals.Characters.clear()
	var dir := DirAccess.open("res://Resources/Characters/Main/")
	if dir:
		for file_name in dir.get_files():
			if file_name.ends_with(".remap"):
				file_name = file_name.trim_suffix(".remap")
			var res_path = "res://Resources/Characters/Main/" + file_name
			var res = load(res_path)
			if res:
				var P = PlayerScenes.instantiate()
				P.pressed.connect(Selection.bind(res))
				P.icon = res.Sprite
				P.text = res.Alias
				$CharacterSelect/Players.add_child(P)

func Selection(Res):
	var n:int = 0
	for i in CurrentSelections:
		n += 1
	CurrentSelections.set(n, Res)

func Start():
	GeneralGlobals.Players.clear()
	GeneralGlobals.Characters.append(CurrentSelections.get(0))
	var scene = load("res://Scenes/Main.tscn")
	scene = scene.instantiate()
	$Between.show()
	var t = get_tree().create_tween()
	t.tween_property($Between, "modulate", Color(0.0, 0.0, 0.0, 1.0), 1)
	await get_tree().create_timer(1).timeout
	get_tree().get_root().add_child(scene)
	queue_free()
	

func _on_start_pressed() -> void:
	Main.hide()
	$CharacterSelect.show()

func _on_settings_pressed() -> void:
	Main.hide()
	Settings.show()


func _on_back_pressed() -> void:
	Settings.hide()
	Main.show()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_charcter_start_pressed() -> void:
	Start()


func _on_character_back_pressed() -> void:
	Main.show()
	$CharacterSelect.hide()
