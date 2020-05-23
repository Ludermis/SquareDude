extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NextLevelButton_pressed():
	get_tree().paused = false
	$"../../../../WorldEnvironment".environment.dof_blur_near_enabled = false
	get_tree().change_scene(str("res://Prefabs/Levels/Level",Vars.currentLevel + 1,".tscn"))
