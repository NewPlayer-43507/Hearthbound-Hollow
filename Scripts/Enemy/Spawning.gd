extends Node

var EnemyNode:PackedScene = preload("res://Scenes/enemy.tscn")
var EnemyResources:Array = ["res://Resources/Enemies/Normal/Runner.tres"]

var enemyamt = 2

func _ready() -> void:
	GeneralGlobals.SpawnNode = self

func Spawn(Spawnpoints:Array[Vector2]):
	$"..".DoorsLocked = true
	for i in enemyamt:
		var e = EnemyNode.instantiate()
		var res = load(EnemyResources.pick_random())
		e.set_script(res.CustomScript)
		e.EnemyRes = res
		var SpawnPosition = Spawnpoints.pick_random()
		Spawnpoints.erase(SpawnPosition)
		e.global_position = SpawnPosition
		call_deferred("add_child", e)

func _process(_delta: float) -> void:
	if get_child_count() <= 1:
		$"..".DoorsLocked = false
