extends Resource

class_name Character

@export_category("General")
@export var Name:String = "NA"
@export var Alias:String = "NA"
@export var Age:int = 1
@export var Male:bool = true
@export var Description:String = "NA"

@export_category("Stats")
@export var Health:int = 3
@export var ResistToKnockback:int = 2
@export var MainWeapon:int
@export var Speed:int = 5
@export var SpecialAbility:int
@export var Strength:int = 4
@export var ProjSpeed:float = 1
@export var Quotes:Array[String] = ["Hey, get some quotes"]

@export_category("Sprites")
@export var Sprite:CompressedTexture2D
@export var Spritesheet:CompressedTexture2D
