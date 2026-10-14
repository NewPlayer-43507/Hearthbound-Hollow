extends CharacterBody2D

@onready var Anim = $PlayerSprite

var Lastdir:Vector2 = Vector2(1,0)

func _physics_process(delta: float) -> void:
# Movement
	velocity = Vector2(Input.get_axis("Left","Right"), Input.get_axis("Up", "Down"))
	velocity = velocity.normalized() * delta * 600 * get_parent().Speed
	move_and_slide()

	if velocity.x != 0:
		Anim.play("right_walk")
		if velocity.x > 0:
			Anim.flip_h = false
			Lastdir = Vector2(1,0)
		elif velocity.x < 0:
			Anim.flip_h = true
			Lastdir = Vector2(-1,0)
	elif velocity.y != 0:
		if velocity.y > 0:
			Anim.play("down_walk")
			Lastdir = Vector2(0,1)
		elif velocity.y < 0:
			Anim.play("up_walk")
			Lastdir = Vector2(0,-1)
	else:
		if Lastdir.x != 0:
			Anim.play("right_idle")
		if Lastdir == Vector2(0,1):
			Anim.play("down_idle")
		if Lastdir == Vector2(0,-1):
			Anim.play("up_idle")

func Damage(amt):
	get_parent().Damage(amt)
