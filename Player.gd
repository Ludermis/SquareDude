extends KinematicBody2D

var velocity = Vector2.ZERO
var jumpHeight = 1024
var acceleration = 64
var maxSpeed = 384
var debugDraw = false
var wasOnFloor = false
var airJumpsMax = 1
var airJumpsLeft = airJumpsMax

func _ready():
	set_physics_process(true)

func _process(delta):
	pass

func _draw():
	if debugDraw:
		draw_rect(Rect2(-32,-32,64,64),Color.red,false)

func _physics_process(delta):
	velocity += Vars.gravity
	if Input.is_action_pressed('right'):
		velocity.x = min(velocity.x + acceleration, maxSpeed)
	elif Input.is_action_pressed('left'):
		velocity.x = max(velocity.x - acceleration, -maxSpeed)
	else:
		velocity.x = lerp(velocity.x,0,Vars.friction)
	
#	# TODO : Ground Fall Impact
#	if is_on_floor() && wasOnFloor == false:
#		wasOnFloor = true
#		var node : AnimatedSprite = preload("res://ImpactEffect.tscn").instance()
#		node.position = position + get_floor_normal() * 32
#		node.rotation = get_floor_normal().angle() + PI / 2
#		node.playing = true
#		$"..".add_child(node)
	
	if Input.is_action_just_pressed('up'):
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
	
	if is_on_floor():
		airJumpsLeft = airJumpsMax
		var normal = get_floor_normal()
		if true:
			var angleDelta = normal.angle() - (rotation - PI)
			rotation = lerp(rotation,angleDelta + rotation,0.4)
		else:
			rotation = lerp(rotation,0,0.4)
	
	if Input.is_key_pressed(KEY_C):
		rotation = 0
		velocity = Vector2.ZERO
		position = Vector2(836,502)
		
#	if Input.is_action_pressed('ui_right'):
#		$"../Wall1".rotation += delta
#	if Input.is_action_pressed('ui_left'):
#		$"../Wall1".rotation -= delta

	if !is_on_floor():
		wasOnFloor = false

	velocity = move_and_slide(velocity,Vector2.UP)
