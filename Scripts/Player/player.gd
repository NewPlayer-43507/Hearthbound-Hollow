extends Node2D

#ONREADY VARIABLES
@onready var Char:Character = load("res://Resources/Characters/Main/JT.tres")
@onready var AItem:ActiveItem = load("res://Resources/ActiveItems/Drumsticks.tres")
@onready var Body = $Body

#PROJECTILES
var projectile = preload("res://Scenes/projectile.tscn")
var AbleToAttack:bool = true

#HEALTH
var health:int

#ITEMS
var CurrentPickup:Area2D = null
var PassiveItemInventory:Array[PassiveItem] = []

#CHARACTER STATS
var max_health:int
var Speed:float
var CooldownTime:float = 0.5
var ResistanceToKnockback:int
var Strength:int
var ProjectileSpeed:float

#WEAPON STATS
var damage:int
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
	damage = AItem.Damage
	Chargable = AItem.Chargable
	TimeCharging = AItem.time
	MaxDamage = AItem.MaxDamage

	GeneralGlobals.Players.append(self)
	$Camera2D/Health/Normal/TextureProgressBar.value = health

func _input(_event: InputEvent) -> void:
# Set UI
	$Camera2D/Health/Normal/Sprite2D.scale.x = 1
	for i in max_health:
		$Camera2D/Health/Normal/Sprite2D.scale.x -= 0.05
	if CurrentPickup == null:
		$Camera2D/ItemUI/Pickup/Name.text = ""
		$Camera2D/ItemUI/Pickup/Description.text = ""
# Attacking
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
		proj.Damage = damage
		proj.TimeBeforeFall = float(Strength) / float(8)
		proj.Sprite = AItem.Projectile
		proj.global_position = Body.global_position
		proj.PlayerProj = true
		get_parent().add_child(proj)
		AbleToAttack = false
		get_tree().create_timer(CooldownTime).timeout.connect(AllowShooting)

# Pickup Item
	if Input.is_action_just_pressed("Interact"):
		if CurrentPickup != null:
			CurrentPickup.Collect(self)
			$Camera2D/ItemUI/Pickup/Name.text = ""
			$Camera2D/ItemUI/Pickup/Description.text = ""

## For Normal Hearts
func Damage(amt):
	health -= amt
	if health <= 0:
		$Camera2D/Death/Quote.text = Char.Quotes.pick_random()
		$Camera2D/Death.show()
		process_mode = Node.PROCESS_MODE_DISABLED
	$Camera2D/Health/Normal/TextureProgressBar.value = health

## Switches AbleToAttack to true
func AllowShooting():
	AbleToAttack = true

func AddPassiveItem(PItem):
	max_health += PItem.Health
	Speed += PItem.Speed
	ResistanceToKnockback += PItem.ResistToKnockback
	Strength += PItem.Strength
	ProjectileSpeed += PItem.ProjectileSpeed
	damage += PItem.Damage
	MaxDamage += PItem.Damage
	CooldownTime += PItem.AttackCooldownTime
	if PItem.HasScript:
		$PassiveItemScripts.AddScript(PItem)
	PassiveItemInventory.append(PItem)

func AddSingleItem(SItem):
	health += SItem.Health
	$Camera2D/Health/Normal/TextureProgressBar.value = health
	Speed += SItem.Speed
	ResistanceToKnockback += SItem.ResistToKnockback
	Strength += SItem.Strength
	ProjectileSpeed += SItem.ProjectileSpeed
	damage += SItem.Damage
	MaxDamage += SItem.Damage
	CooldownTime += SItem.AttackCooldownTime

func AddActiveItem(_aItem):
	pass

func _on_item_pickup_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("ItemPickup"):
		CurrentPickup = area
		$Camera2D/ItemUI/Pickup/Name.text = area.Name
		$Camera2D/ItemUI/Pickup/Description.text = area.Description
		

func _on_item_pickup_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("ItemPickup"):
		CurrentPickup = null
