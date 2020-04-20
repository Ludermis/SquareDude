extends Node

var gravity = Vector2(0,98 / 2)
var friction = 0.2
var FASTFORDEBUG = false
var enemyAIType = 2
var enemyRemaining = 0
var currentLevel = -1

func rotatePoint(point,center,angle) -> Vector2:
	var newX = cos(angle) * (point.x - center.x) - sin(angle) * (point.y - center.y) + center.x
	var newY = sin(angle) * (point.x - center.x) + cos(angle) * (point.y - center.y) + center.y
	return Vector2(newX,newY)

func time() -> float:
	return float(OS.get_ticks_msec())

func _ready():
	pass


func _process(delta):
	pass
