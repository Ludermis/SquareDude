extends KinematicBody2D

var velocity = Vector2.ZERO
var jumpHeight = 1024
var acceleration = 64
var maxSpeed = 384
var debugDraw = false
var wasOnFloor = false
var airJumpsMax = 1
var airJumpsLeft = airJumpsMax
var health = 100

func _ready():
	set_physics_process(true)
	$Weapon.ownerNode = self

func _process(delta):
	pass

func jump ():
	if is_on_floor():
			velocity.y = -jumpHeight
			var node : AnimatedSprite = preload("res://JumpEffect.tscn").instance()
			node.position = position + get_floor_normal() * 32
			node.rotation = get_floor_normal().angle() + PI / 2
			node.playing = true
			$"..".add_child(node)
	elif airJumpsLeft > 0:
		airJumpsLeft -= 1
		velocity.y = -jumpHeight
		var node : AnimatedSprite = preload("res://JumpEffect.tscn").instance()
		node.position = position
		node.rotation = 0
		node.playing = true
		$"..".add_child(node)

func goRight ():
	velocity.x = min(velocity.x + acceleration, maxSpeed)

func goLeft ():
	velocity.x = max(velocity.x - acceleration, -maxSpeed)

func idle():
	velocity.x = lerp(velocity.x,0,Vars.friction)

func takeDamage (attacker, damage):
	health -= damage
	if health <= 0:
		queue_free()

func aiMove ():
	if $RayCast2D.get_collider() != null && $RayCast2D.get_collider() is Node2D && $RayCast2D.get_collider().is_in_group("Player"):
		$Weapon.shoot($"../Player".position)
	elif $"../Player".position.x < position.x:
		goLeft()
	else:
		goRight()

func _physics_process(delta):
	velocity += Vars.gravity
	
	idle()
	
	if is_on_floor():
		airJumpsLeft = airJumpsMax
		var normal = get_floor_normal()
		if true:
			var angleDelta = normal.angle() - (rotation - PI)
			rotation = lerp(rotation,angleDelta + rotation,0.4)
		else:
			rotation = lerp(rotation,0,0.4)

	if !is_on_floor():
		wasOnFloor = false

	velocity = move_and_slide(velocity,Vector2.UP)
	if $"../Player".position.x < position.x:
		$Weapon.flip_v = true
	else:
		$Weapon.flip_v = false
	$Weapon.look_at($"../Player".position)
	$RayCast2D.cast_to = to_local($"../Player".position)
	aiMove()
