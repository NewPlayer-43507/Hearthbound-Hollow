extends Area2D

var Name
var Description

var Item:Resource = load("res://Resources/PedastolItems/PassiveItems/BrokenGoldfish.tres")

func _ready() -> void:
	Item = load(ItemPools.PedastolItems.pick_random())
	Name = Item.Name
	Description = Item.Description
	$Sprite2D2.texture = Item.Sprite


func Collect(body):
	if Item == null:
		return
	if Item is PassiveItem:
		body.AddPassiveItem(Item)
	if Item is ActiveItem:
		body.AddActiveItem(Item)
	if Item is SingleUse:
		body.AddSingleItem(Item)
	$Sprite2D2.queue_free()
	Item = null
	remove_from_group("ItemPickup")
