extends Area2D

var Name:String
var Description:String

@export var Item:Resource = null

var pos

func _ready() -> void:

	Name = Item.Name
	Description = Item.Description
	$Sprite2D.texture = Item.Sprite


func Collect(body):
	if Item is PassiveItem:
		body.AddPassiveItem(Item)
	if Item is ActiveItem:
		body.AddActiveItem(Item)
	if Item is SingleUse:
		body.AddSingleItem(Item)
	queue_free()
