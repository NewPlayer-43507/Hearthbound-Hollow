extends Node2D

@onready var Char:Character = load("res://Resources/Characters/Main/JT.tres")

@onready var Body = $Body

func _physics_process(delta: float) -> void:
#Input
	Body.velocity = Vector2(Input.get_axis("Left","Right"), Input.get_axis("Up", "Down"))
	Body.velocity = Body.velocity.normalized() * delta * Char.Speed * 300
	Body.move_and_slide()
	print(Body.velocity)
