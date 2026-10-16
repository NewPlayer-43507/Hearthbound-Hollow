extends Area2D

var PlayerProj:bool = false
var velocity:Vector2

var Sprite = "res://Sprite/Projectiles/Drumstick.png"
var Damage:int = 0

var TimeBeforeFall:float = 1

func _ready() -> void:
	if Sprite is String:
		$Sprite2D.texture = load(Sprite)
	elif Sprite is CompressedTexture2D:
		$Sprite2D.texture = Sprite
	get_tree().create_timer(TimeBeforeFall).timeout.connect(Erase)

func _physics_process(delta: float) -> void:
	if velocity == null:
		queue_free()
		return
	rotate(0.1)
	global_position += velocity * delta * 200


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and PlayerProj:
		return
	if body.is_in_group("Enemy") and !PlayerProj:
		body.Damage(Damage)
	queue_free()

func Erase():
	for i in 10:
		scale *= 0.9
		await get_tree().process_frame
	queue_free()
