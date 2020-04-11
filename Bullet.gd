extends Sprite

var speed = 512 * 1.5
var dir : Vector2
var ownerNode : Node2D
var damage  = 0

func _ready():
	pass

func _process(delta):
	position += dir * speed * delta

func _on_Area2D_body_entered(body):
	if body != ownerNode:
		queue_free()
		$"../Camera2D".shake(0.2,15,4)
		if ownerNode.is_in_group("Player") && body.is_in_group("Enemy"):
			body.takeDamage(ownerNode,damage)
