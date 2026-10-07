extends Resource

class_name ActiveItem

@export var Name:String = "NA"
@export var Description:String = "NA"
@export var Damage:int = 1

@export_category("Charge")
@export var Chargable:bool = false
@export var time:float = 0.0
@export var MaxDamage:int = 0

@export_category("Specials")
@export var Chance:int = 100
@export var Effect:int
@export var damage:int = 0

@export_category("Sprites")
@export var Sprite:CompressedTexture2D
@export var SpriteSheet:CompressedTexture2D
@export var Frames:Vector2 = Vector2(1,1)
@export var Projectile:CompressedTexture2D
