extends Node2D



func _on_up_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$"..".RoomSetup(Vector2i(0,-1), body)


func _on_down_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$"..".RoomSetup(Vector2i(0,1), body)


func _on_left_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$"..".RoomSetup(Vector2i(-1,0), body)

func _on_right_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$"..".RoomSetup(Vector2i(1,0), body)
