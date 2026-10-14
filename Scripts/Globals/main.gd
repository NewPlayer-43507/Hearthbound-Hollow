extends Node2D

@onready var Tileset:TileMapLayer = $TileMapLayer
@onready var UpArea:Area2D = $Room/Up
@onready var DownArea:Area2D = $Room/Down
@onready var LeftArea:Area2D = $Room/Left
@onready var RightArea:Area2D = $Room/Right

var Pickup = preload("res://Scenes/item_pickup.tscn")

var EnteredRooms:Array[Vector2i] = []
var currentroom:Vector2i = Vector2i(0,0)
var roomgrid:Dictionary[Vector2i, int] = {}
var lastcords:Vector2i = Vector2i(0,0)
var roomamt:int = 8
var RoomPickups:Dictionary[Vector2i, Dictionary] = {}
var DoorsLocked:bool = false

func _ready() -> void:
	RoomGridCreation()

func RoomGridCreation():
	EnteredRooms.clear()
	currentroom = Vector2i(0,0)
	roomgrid.clear()
	roomgrid.set(Vector2i(0,0), 0)
	var cords = Vector2i(0,0)
	lastcords = Vector2i(0,0)
	for i in roomamt:
		var rang = randi_range(1,2)
		if rang == 1:
			cords = Vector2i(lastcords.x, lastcords.y + randi_range(-1,1))
		else:
			cords = Vector2i(lastcords.x + randi_range(-1,1), lastcords.y)
		RoomCheck(cords)
	print(roomgrid)
	RoomSetup(Vector2i(0,0))

func RoomCheck(cords):
	var fail = false
	for i in roomgrid:
		if i == cords:
			fail = true
	if fail:
		var rang = randi_range(1,2)
		var vector = roomgrid.keys().pick_random()
		if rang == 1:
			cords = Vector2i(vector.x, vector.y + randi_range(-1,1))
		else:
			cords = Vector2i(vector.x + randi_range(-1,1), vector.y)
		RoomCheck(cords)
	if !fail:
		if roomgrid.size() == roomamt:
			roomgrid.set(cords, 1)
		else:
			roomgrid.set(cords, randi_range(0,1))
		lastcords = cords

func RoomSetup(Direction:Vector2i, Player:CharacterBody2D = null):
# Check if can change room
	if DoorsLocked:
		return
# Save Pickups
	if not RoomPickups.has(currentroom):
		RoomPickups.get_or_add(currentroom, {})
	for i in $Room/Pickups.get_children():
		RoomPickups.get(currentroom).set(i.global_position, i.Item)
		i.queue_free()

# Change Rooms
	currentroom += Direction
	GeneralGlobals.RoomChanged.emit(EnteredRooms.has(currentroom))
	if not EnteredRooms.has(currentroom):
		var Spawnpoints:Array[Vector2] = []
		for i in Tileset.get_used_cells():
			var data = Tileset.get_cell_tile_data(i)
			data = data.get_custom_data("SpawnPoint")
			if data == true:
				Spawnpoints.append(Tileset.map_to_local(i))
		$Spawner.Spawn(Spawnpoints)
	EnteredRooms.append(currentroom)

# Setup Room Pattern
	Tileset.clear()
	Tileset.set_pattern(Vector2i(0,1), Tileset.tile_set.get_pattern(roomgrid.get(currentroom)))

# Find Needed Doors
	var DownDoor = false
	var UpDoor = false
	var LeftDoor = false
	var RightDoor = false
	if roomgrid.has(Vector2i(currentroom.x + 1, currentroom.y)):
		RightDoor = true
	if roomgrid.has(Vector2i(currentroom.x - 1, currentroom.y)):
		LeftDoor = true
	if roomgrid.has(Vector2i(currentroom.x, currentroom.y + 1)):
		DownDoor = true
	if roomgrid.has(Vector2i(currentroom.x, currentroom.y - 1)):
		UpDoor = true

# Get Door Position
	var DownDoorPosition
	var UpDoorPosition
	var LeftDoorPosition
	var RightDoorPosition
	for i in Tileset.get_used_cells():
		var data = Tileset.get_cell_tile_data(i)
		data = data.get_custom_data("Doorway")
		if data == 1:
			UpDoorPosition = i
		if data == 2:
			LeftDoorPosition = i
		if data == 3:
			DownDoorPosition = i
		if data == 4:
			RightDoorPosition = i

# Put Player In Position
	if Player != null:
		if Direction == Vector2i(1,0):
			Player.global_position = Tileset.map_to_local(Vector2(LeftDoorPosition.x + 1, LeftDoorPosition.y))
		elif Direction == Vector2i(-1,0):
			Player.global_position = Tileset.map_to_local(Vector2(RightDoorPosition.x - 1, RightDoorPosition.y))
		elif Direction == Vector2i(0,1):
			Player.global_position = Tileset.map_to_local(Vector2(UpDoorPosition.x, UpDoorPosition.y + 1))
		elif Direction == Vector2i(0,-1):
			Player.global_position = Tileset.map_to_local(Vector2(DownDoorPosition.x, DownDoorPosition.y -1 ))

# Setup Doorways
	if DownDoor:
		DownArea.position = Tileset.map_to_local(DownDoorPosition)
		DownArea.set_deferred("monitoring", true)
	else:
		DownArea.set_deferred("monitoring", false)
		Tileset.set_cell(DownDoorPosition, 0, Vector2i(9,3))
	if UpDoor:
		UpArea.position = Tileset.map_to_local(UpDoorPosition)
		UpArea.set_deferred("monitoring", true)
	else:
		UpArea.set_deferred("monitoring", false)
		Tileset.set_cell(UpDoorPosition, 0, Vector2i(10,0))
	if LeftDoor:
		LeftArea.position = Tileset.map_to_local(LeftDoorPosition)
		LeftArea.set_deferred("monitoring", true)
	else:
		LeftArea.set_deferred("monitoring", false)
		Tileset.set_cell(LeftDoorPosition, 0, Vector2i(8,1))
	if RightDoor:
		RightArea.position = Tileset.map_to_local(RightDoorPosition)
		RightArea.set_deferred("monitoring", true)
	else:
		RightArea.set_deferred("monitoring", false)
		Tileset.set_cell(RightDoorPosition, 0, Vector2i(11,2))

# Item Pickups
	if not RoomPickups.has(currentroom):
		RoomPickups.get_or_add(currentroom, {})
	for i in RoomPickups.get(currentroom):
		var p = Pickup.instantiate()
		p.Item = RoomPickups.get(currentroom).get(i)
		p.global_position = i
		$Room/Pickups.call_deferred("add_child",p)
