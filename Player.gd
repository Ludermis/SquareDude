extends KinematicBody2D

var velocity = Vector2.ZERO
var jumpHeight = 1024
var acceleration = 64
var maxSpeed = 384
var debugDraw = false

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
	
	if Input.is_action_pressed('up') && is_on_floor():
		velocity.y = -jumpHeight
	
	if is_on_floor():
		var normal = get_floor_normal()
		#get_tree().root.get_node("Node2D/DebugPanel/Control/Panel/Label").text = str(normal)
		if true:
			var angleDelta = normal.angle() - (rotation - PI)
			rotation = lerp(rotation,angleDelta + rotation,0.1)
		else:
			rotation = lerp(rotation,0,0.1)
	
	if Input.is_action_pressed('ui_right'):
		$"../Wall1".rotation += delta
	if Input.is_action_pressed('ui_left'):
		$"../Wall1".rotation -= delta
	velocity = move_and_slide(velocity,Vector2.UP)
