extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	$"Level1/WorldEnvironment".queue_free()
	$"CanvasLayer/BackButton".visible = false
	add_child(preload("res://Prefabs/Misc/BlurEnvironment.tscn").instance())


func _process(delta):
	pass
