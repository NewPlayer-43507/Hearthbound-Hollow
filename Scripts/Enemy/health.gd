extends Node

var health = 1
var max_health = 1

signal Damaged

signal Death

func _ready() -> void:
	max_health = get_parent().EnemyRes.Health
	health = max_health

func Damage(amt):
	Damaged.emit()
	health -= amt
	if health <= 0:
		Death.emit()
		get_parent().queue_free()
