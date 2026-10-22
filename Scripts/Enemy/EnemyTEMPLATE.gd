extends CharacterBody2D

var EnemyRes:Enemy

@onready var Anim = $AnimatedSprite2D

var CurrentPlayer
var Lastdir:Vector2 = Vector2(1,0)


func _ready() -> void:
	Anim.sprite_frames = EnemyRes.SpriteSheet
	$Hitbox.body_entered.connect(_on_hitbox_body_entered)

func _physics_process(delta: float) -> void:
	var DistanceToPlayer = 1000000
	for i in GeneralGlobals.Players:
		var dis = global_position.distance_to(i.Body.global_position)
		if dis < DistanceToPlayer:
			DistanceToPlayer = dis
			CurrentPlayer = i
	if CurrentPlayer == null:
		return
	$NavigationAgent2D.target_position = CurrentPlayer.Body.global_position
	velocity = $NavigationAgent2D.get_next_path_position() - global_position
	velocity = velocity.normalized() * delta * 580 * EnemyRes.Speed
	move_and_slide()

#Animation
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

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.Damage(EnemyRes.Damage)

func GiveEffect(effect:Effect):
	var e = Node.new()
	e.set_script(effect.RunScript)
	$Effects.call_deferred("add_child", e)
