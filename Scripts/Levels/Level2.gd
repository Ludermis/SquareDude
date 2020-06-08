extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$WorldEnvironment.environment.dof_blur_near_enabled = false
	AudioServer.set_bus_effect_enabled(1,0,false)
	Vars.levelStarted = Vars.time()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	if $Music.playing == false:
#		$Music.play(5.30)
	pass

func _on_Main_tree_entered():
	Vars.currentLevel = 2
	Vars.countdownSeconds = 3
	#$Music.play(5.30)
