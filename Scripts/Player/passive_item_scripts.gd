extends Node

@onready var PlayerNode = $".."

func AddScript(PItem):
	var newitem = Node.new()
	newitem.set_script(PItem.ItemScript)
	add_child(newitem)
	if PItem.HasSetup:
		newitem.Setup()
