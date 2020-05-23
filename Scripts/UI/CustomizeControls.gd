extends Control

var hatsIndex = 0
var hatChanging = 0
var changeSpeed = 1600

func _ready():
	hatsIndex = Vars.currentCosmetics["hat"]
	$Hats/Hat.texture = load(str("res://Sprites/Cosmetics/Hat/",Vars.ownedCosmetics["hat"][hatsIndex],".png"))
	$"../Player/Hat".texture = load(str("res://Sprites/Cosmetics/Hat/",Vars.ownedCosmetics["hat"][hatsIndex],".png"))

func _process(delta):
	if hatChanging == 1:
		$"../Player/Hat".position.y -= changeSpeed * delta
		if $"../Player/Hat".position.y < -315:
			$"../Player/Hat".position.y = 300
			$"../Player/Hat".texture = load(str("res://Sprites/Cosmetics/Hat/",Vars.ownedCosmetics["hat"][hatsIndex],".png"))
			hatChanging = 2
	elif hatChanging == 2:
		$"../Player/Hat".position.y -= changeSpeed * delta
		if $"../Player/Hat".position.y <= 0:
			$"../Player/Hat".position.y = 0
			hatChanging = 0

func _on_HatLeftButton_pressed():
	if hatChanging != 0 || hatsIndex == 0:
		return
	hatsIndex = max(0,hatsIndex - 1)
	Vars.currentCosmetics["hat"] = hatsIndex
	hatChanging = 1
	$Hats/Hat.texture = load(str("res://Sprites/Cosmetics/Hat/",Vars.ownedCosmetics["hat"][hatsIndex],".png"))

func _on_HatRightButton_pressed():
	if hatChanging != 0 || hatsIndex == Vars.ownedCosmetics["hat"].size() - 1:
		return
	hatsIndex = min(hatsIndex + 1,Vars.ownedCosmetics["hat"].size() - 1)
	Vars.currentCosmetics["hat"] = hatsIndex
	hatChanging = 1
	$Hats/Hat.texture = load(str("res://Sprites/Cosmetics/Hat/",Vars.ownedCosmetics["hat"][hatsIndex],".png"))
