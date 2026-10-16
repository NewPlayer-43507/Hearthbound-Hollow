extends Resource

class_name Enemy

@export var Name:String = "NA"
@export var Health:int = 2
@export var Speed:int = 4
@export var Damage:int = 1

@export_category("Sprite")
@export var SpriteSheet:SpriteFrames

@export_category("Script")
@export var CustomScript:GDScript
