extends Node

var gravity = Vector2(0,98 / 2)
var friction = 0.2
var FASTFORDEBUG = true
var enemyAIType = 2
var enemyRemaining = 0
var currentLevel = -1
var countdownSeconds = 1
var currentCamera : Camera2D
var cosmeticTypes = ["Hat"]
var allCosmetics = {"Hat": ["none","cowboyhat","testhat"]}
var ownedCosmetics = {"Hat": ["none"]}
var currentCosmetics = {"Hat": 0}
var cosmeticsPrice = {"cowboyhat": 100,"testhat": 350}
var money = 100
var crystal = 5

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

func saveGame ():
	var dict = {
		"money": money,
		"crystal": crystal,
		"ownedCosmetics": ownedCosmetics,
		"currentCosmetics": currentCosmetics
	}
	var save = File.new()
	save.open("user://save1.save",File.WRITE)
	save.store_line(to_json(dict))

func loadGame ():
	var save = File.new()
	if not save.file_exists("user://save1.save"):
		return
	save.open("user://save1.save", File.READ)
	var data = parse_json(save.get_line())
	money = data["money"]
	crystal = data["crystal"]
	ownedCosmetics = data["ownedCosmetics"]
	currentCosmetics = data["currentCosmetics"]
	save.close()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST || what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		print("quit")
		saveGame()

func _ready():
	loadGame()


func _process(delta):
	pass
