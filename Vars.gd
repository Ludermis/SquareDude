extends Node

var gravity = Vector2(0,98 / 2)
var friction = 0.2
var FASTFORDEBUG = false
var enemyAIType = 3
var enemyRemaining = 0
var currentLevel = -1
var countdownSeconds = 1
var currentCamera : Camera2D

func rotatePoint(point,center,angle) -> Vector2:
	var newX = cos(angle) * (point.x - center.x) - sin(angle) * (point.y - center.y) + center.x
	var newY = sin(angle) * (point.x - center.x) + cos(angle) * (point.y - center.y) + center.y
	return Vector2(newX,newY)

func time() -> float:
	return float(OS.get_ticks_msec())

func getNearestPickup (pos) -> Node2D:
	var pickups = get_tree().get_nodes_in_group("Pickup")
	if pickups.size() == 0:
		return null
	var returner = pickups[0]
	for pickup in pickups:
		if pickup.global_position.distance_to(pos) < returner.global_position.distance_to(pos):
			returner = pickup
	return returner

func _ready():
	pass


func _process(delta):
	pass
