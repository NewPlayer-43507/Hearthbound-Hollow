extends Area2D

var Name:String
var Description:String

@export var IsPassiveItem:bool = false
@export var PItem:PassiveItem
@export var IsActiveItem:bool = false
@export var AItem:ActiveItem

func _ready() -> void:
	if IsPassiveItem:
		Name = PItem.Name
		Description = PItem.Description
		$Sprite2D.texture = PItem.Sprite
	if IsActiveItem:
		Name = AItem.Name
		Name = AItem.Description
		$Sprite2D.texture = AItem.Sprite

func Collect(body):
	if IsPassiveItem:
		body.AddPassiveItem(PItem)
	if IsActiveItem:
		body.AddActiveItem(AItem)
	queue_free()
