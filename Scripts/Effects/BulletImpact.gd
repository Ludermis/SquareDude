extends Node2D

func _ready():
	pass

#func _process(delta):
#	pass


func _on_AnimatedSprite_animation_finished():
	queue_free()
