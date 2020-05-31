extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	var we : WorldEnvironment = $"../../WorldEnvironment"
	$Label2.text = str(int((Vars.time() - Vars.levelStarted) / 1000 / 60),".",int((Vars.time() - Vars.levelStarted) / 1000) % 60)
	we.environment.dof_blur_near_enabled = true
	
	var tween = get_node("Tween2")
	tween.interpolate_property(we.environment, "dof_blur_near_distance",
		1, 2, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	tween = get_node("Tween")
	tween.interpolate_property(self, "rect_position",
		Vector2(0, -1920 / 2), Vector2(0, 0), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
