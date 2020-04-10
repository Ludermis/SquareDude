extends KinematicBody2D

var velocity = Vector2.ZERO
var jumpHeight = 1024
var acceleration = 64
var maxSpeed = 384

func _ready():
	pass

func _process(delta):
	velocity += Vars.gravity
	if Input.is_action_pressed('right'):
		velocity.x = min(velocity.x + acceleration, maxSpeed)
	elif Input.is_action_pressed('left'):
		velocity.x = max(velocity.x - acceleration, -maxSpeed)
	else:
		velocity.x = lerp(velocity.x,0,Vars.friction)
	
	if Input.is_action_pressed('up') && is_on_floor():
		velocity.y = -jumpHeight
	velocity = move_and_slide(velocity,Vector2.UP)
