extends Sprite

var speed = 512 * 1.5
var dir : Vector2
var ownerNode : Node2D
var damage  = 0
var ownerGroup : Array
var stuckInto = null
var gravEnabled = false
var lifeTime : float = 10

func _ready():
	ownerGroup = ownerNode.get_groups()

func _process(delta):
	lifeTime -= delta
	if lifeTime <= 0:
		queue_free()
	
	position += dir * speed * delta
	if stuckInto != null && !is_instance_valid(stuckInto):
		stuckInto = null
		gravEnabled = true
	if gravEnabled:
		position += Vars.gravity * delta * 2

func _on_Area2D_body_entered(body : Node2D):
	if body != ownerNode:
		var node = null
		Vars.currentCamera.shake(0.2,15,4)
		if ownerGroup.has("Player") && body.is_in_group("Enemy"):
			$"../Sounds/BloodSound".play()
			body.takeDamage(ownerNode,damage)
			node = preload("res://Prefabs/Effects/BloodEffect.tscn").instance()
			node.position = position
			node.rotation = rotation - PI / 2
			node.get_node("AnimatedSprite").play("default")
			$"..".add_child(node)
			stuckInto = body

		elif ownerGroup.has("Enemy") && body.is_in_group("Player"):
			$"../Sounds/BloodSound".play()
			body.takeDamage(ownerNode,damage)
			node = preload("res://Prefabs/Effects/BloodEffect.tscn").instance()
			node.position = position
			node.rotation = rotation - PI / 2
			node.get_node("AnimatedSprite").play("default")
			$"..".add_child(node)
			stuckInto = body
		else:
#			node = preload("res://Prefabs/Effects/BulletImpact.tscn").instance()
#			node.position = position
#			node.rotation = rotation - PI / 2
#			node.get_node("AnimatedSprite").play("default")
			$"../Sounds/BulletImpactSound".play()
			$"..".add_child(node)
			gravEnabled = false
		speed = 0
