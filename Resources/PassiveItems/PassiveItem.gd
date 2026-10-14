extends Resource

class_name PassiveItem

@export var Name:String = "NA"
@export var Description:String = "NA"

@export_category("Stats")
@export var Health:int = 0
@export var ResistToKnockback:int = 0
@export var Speed:int = 0
@export var Strength:int = 0
@export var ProjectileSpeed:float = 0.0
@export var AttackCooldownTime:float = 0.0
@export var Damage:int = 0

@export_category("Sprite")
@export var Sprite:CompressedTexture2D

@export_category("Scripts")
@export var HasScript:bool = false
@export var ItemScript:Script
