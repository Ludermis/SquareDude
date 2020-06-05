extends Node2D

func _ready():
	$WorldEnvironment.environment.dof_blur_near_enabled = false
	AudioServer.set_bus_effect_enabled(1,0,false)
	Vars.levelStarted = Vars.time()

func _process(delta):
	if $Music.playing == false:
		$Music.play(5.30)

func _on_Main_tree_entered():
	Vars.currentLevel = 4
	Vars.countdownSeconds = 3
	$Music.play(5.30)
