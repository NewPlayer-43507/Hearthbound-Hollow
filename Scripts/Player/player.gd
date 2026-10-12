extends Node2D

@onready var Char:Character = load("res://Resources/Characters/Main/JT.tres")
@onready var AItem:ActiveItem = load("res://Resources/ActiveItems/Drumsticks.tres")
@onready var Body = $Body

var projectile = preload("res://Scenes/projectile.tscn")
var AbleToAttack:bool = true

var health:int

#CHARACTER STATS
var max_health:int
var Speed:float
var CooldownTime:float = 0.5
var ResistanceToKnockback:int
var Strength:int
var ProjectileSpeed:float

#WEAPON STATS
var Damage:int
var Chargable:bool
var TimeCharging:float
var MaxDamage:int

func _ready() -> void:
	AItem = Char.MainWeapon
	max_health = Char.Health
	Speed = Char.Speed
	health = max_health
	ResistanceToKnockback = Char.ResistToKnockback
	Strength = Char.Strength
	ProjectileSpeed = Char.ProjSpeed
	Damage = AItem.Damage
	Chargable = AItem.Chargable
	TimeCharging = AItem.time
	MaxDamage = AItem.MaxDamage

	GeneralGlobals.Players.append(self)

func _physics_process(delta: float) -> void:
# Input
	Body.velocity = Vector2(Input.get_axis("Left","Right"), Input.get_axis("Up", "Down"))
	Body.velocity = Body.velocity.normalized() * delta * 580 * Speed
	Body.Animate()

## Attacking
func _input(_event: InputEvent) -> void:
	var projvelocity:Vector2
	if Input.is_action_pressed("AttackDown"):
		projvelocity = Vector2(0,1)
	elif Input.is_action_pressed("AttackUp"):
		projvelocity = Vector2(0,-1)
	elif Input.is_action_pressed("AttackLeft"):
		projvelocity = Vector2(-1,0)
	elif Input.is_action_pressed("AttackRight"):
		projvelocity = Vector2(1,0)
	if projvelocity != Vector2.ZERO:
		if not AbleToAttack:
			return
		var proj = projectile.instantiate()
		proj.velocity = projvelocity * ProjectileSpeed
		proj.Damage = Damage
		proj.TimeBeforeFall = float(Strength) / float(8)
		proj.Sprite = AItem.Projectile
		proj.global_position = Body.global_position
		proj.PlayerProj = true
		get_parent().add_child(proj)
		AbleToAttack = false
		get_tree().create_timer(CooldownTime).timeout.connect(AllowShooting)

## For Normal Hearts
func Damage(amt):
	health -= amt
	if health <= 0:
		get_tree().quit()

## Switches AbleToAttack to true
func AllowShooting():
	AbleToAttack = true
