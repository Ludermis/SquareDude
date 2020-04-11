extends AnimatedSprite

func _ready():
	pass

#func _process(delta):
#	pass


func _on_JumpEffect_animation_finished():
	queue_free()
