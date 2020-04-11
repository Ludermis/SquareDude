extends Sprite

var speed = 512 * 1.5
var dir : Vector2
var ownerNode

func _ready():
	pass

func _process(delta):
	position += dir * speed * delta


func _on_Area2D_body_entered(body):
	if body != ownerNode:
		queue_free()
