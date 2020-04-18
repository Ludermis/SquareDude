extends KinematicBody2D

var velocity = Vector2.ZERO
var jumpHeight = 1024
var acceleration = 64
var maxSpeed = 384
var debugDraw = false
var wasOnFloor = false
var airJumpsMax = 1
var airJumpsLeft = airJumpsMax
var maxHealth : float = 100
var health : float = maxHealth

func _ready():
	set_physics_process(true)
	$Weapon.ownerNode = self

func _process(delta):
	$"Controls/AmmoLabel".text = str($Weapon.curAmmo, "/", $Weapon.maxAmmo)
	if $Weapon.reloading:
		$"Controls/ProgressBar".visible = true
		$"Controls/ProgressBar".get_material().set_shader_param('value',((Vars.time() - $Weapon.reloadStarted) / ($Weapon.reloadDelay)) * 100.0)
	else:
		$"Controls/ProgressBar".visible = false
	$"Controls/HealthFG".rect_size.x = (health / maxHealth) * 64.0
	update()

func takeDamage (attacker, damage):
	health -= damage
	if health <= 0:
		queue_free()

func _draw():
#	#Health Box
#	var pos = Vector2(-48,0)
#	var size = Vector2(8,64)
#	draw_rect(Rect2(pos - size / 2,size),Color.white)
#
#	pos = Vector2(-48,0)
#	size = Vector2(8,(health / maxHealth) * 64.0)
#	draw_rect(Rect2(pos - size / 2,size),Color.red)
	pass

func jump ():
	if is_on_floor():
		$JumpSound.pitch_scale = 1.0
		$JumpSound.play()
		velocity.y = -jumpHeight
		var node : AnimatedSprite = preload("res://JumpEffect.tscn").instance()
		node.position = position + get_floor_normal() * 32
		node.rotation = get_floor_normal().angle() + PI / 2
		node.playing = true
		$"..".add_child(node)
	elif airJumpsLeft > 0:
		$JumpSound.pitch_scale = 0.8
		$JumpSound.play()
		airJumpsLeft -= 1
		velocity.y = -jumpHeight
		var node : AnimatedSprite = preload("res://JumpEffect.tscn").instance()
		node.position = position
		node.rotation = 0
		node.playing = true
		$"..".add_child(node)

func _physics_process(delta):
	velocity += Vars.gravity
	if Input.is_action_pressed('right'):
		velocity.x = min(velocity.x + acceleration, maxSpeed)
	elif Input.is_action_pressed('left'):
		velocity.x = max(velocity.x - acceleration, -maxSpeed)
	else:
		velocity.x = lerp(velocity.x,0,Vars.friction)
	
	if Input.is_action_just_pressed('up'):
		jump()
	
	if is_on_floor():
		airJumpsLeft = airJumpsMax
		var normal = get_floor_normal()
		var angleDelta = normal.angle() - (rotation - PI)
		rotation = lerp(rotation,angleDelta + rotation,0.4)
	
	if Input.is_action_just_pressed("misc1"):
		var node = preload("res://Enemy.tscn").instance()
		node.position = get_global_mouse_position()
		$"..".add_child(node)
	
	if Input.is_action_just_pressed("reload") && $Weapon.curAmmo < $Weapon.maxAmmo:
		$Weapon.reload()

	if !is_on_floor():
		wasOnFloor = false

	velocity = move_and_slide(velocity,Vector2.UP)
	if get_global_mouse_position().x < position.x:
		$Weapon.flip_v = true
	else:
		$Weapon.flip_v = false
	$Weapon.look_at(get_global_mouse_position())
	
	if Input.is_action_pressed('shoot'):
		$Weapon.shoot(get_global_mouse_position())
