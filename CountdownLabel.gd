extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if Vars.FASTFORDEBUG:
		$"..".queue_free()
	else:
		$"../Timer".pause_mode = PAUSE_MODE_PROCESS
		pause_mode = PAUSE_MODE_PROCESS
		get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	text = str(int(text) - 1)
	if text == "0":
		get_tree().paused = false
		$"..".queue_free()
