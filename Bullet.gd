extends Sprite

var speed = 512 * 1.5
var dir : Vector2
var ownerNode : Node2D
var damage  = 0
var ownerGroup : Array

func _ready():
	ownerGroup = ownerNode.get_groups()

func _process(delta):
	position += dir * speed * delta

func _on_Area2D_body_entered(body : Node2D):
	if body != ownerNode:
		var node = null
		$"../Camera2D".shake(0.2,15,4)
		if ownerGroup.has("Player") && body.is_in_group("Enemy"):
			$"../Sounds/BloodSound".play()
			body.takeDamage(ownerNode,damage)
			node = preload("res://BloodEffect.tscn").instance()
			node.position = position
			node.rotation = rotation - PI / 2
			node.get_node("AnimatedSprite").play("default")
			$"..".add_child(node)

		elif ownerGroup.has("Enemy") && body.is_in_group("Player"):
			$"../Sounds/BloodSound".play()
			body.takeDamage(ownerNode,damage)
			node = preload("res://BloodEffect.tscn").instance()
			node.position = position
			node.rotation = rotation - PI / 2
			node.get_node("AnimatedSprite").play("default")
			$"..".add_child(node)
		else:
			node = preload("res://BulletImpact.tscn").instance()
			node.position = position
			node.rotation = rotation - PI / 2
			node.get_node("AnimatedSprite").play("default")
			$"../Sounds/BulletImpactSound".play()
			$"..".add_child(node)
		queue_free()
