extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$WorldEnvironment.environment.dof_blur_near_enabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Level2_tree_entered():
	Vars.currentLevel = 2
	Vars.countdownSeconds = 3
