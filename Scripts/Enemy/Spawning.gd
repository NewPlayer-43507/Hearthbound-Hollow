extends Node

var EnemyNode:PackedScene = preload("res://Scenes/enemy.tscn")
var EnemyResources:Array = ["res://Resources/Enemies/Normal/Runner.tres"]

var enemyamt = 8

func Spawn(Spawnpoints:Array[Vector2]):
	$"..".DoorsLocked = true
	for i in enemyamt:
		var e = EnemyNode.instantiate()
		e.EnemyRes = load(EnemyResources.pick_random())
		var SpawnPosition = Spawnpoints.pick_random()
		Spawnpoints.erase(SpawnPosition)
		e.global_position = SpawnPosition
		e.connect("Death", ChildDeath)
		add_child(e)

func ChildDeath():
	if get_child_count() <= 1:
		$"..".DoorsLocked = false
