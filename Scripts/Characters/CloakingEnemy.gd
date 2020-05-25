extends KinematicBody2D

export var startCloaked = false
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
var lastJumpTime = 0
var jumpCooldown = 200
var damageMultiplier = 1

var invisibleRemaining : float = -1
var invisibleTime : float = 3
var invisibleCooldown : float = 5
var nextInvisible : float = -1

# AI Type 2 Vars
var aiNextMove = -1
var aiLastCalculated = 0
var aiMoveCalculateDelay = 500

var faded : float = 0

func _ready():
	set_physics_process(true)
	$Weapon.ownerNode = self
	Vars.enemyRemaining += 1
	nextInvisible = Vars.time() + invisibleCooldown * 1000
	if startCloaked:
		nextInvisible = Vars.time()

func shadering (delta):
	var r = 0.1
	if invisibleRemaining != -1:
		r = randf()
		faded = min(faded + delta * 1.5,0.7)
	else:
		r = 0
		faded = max(faded - delta * 1.5,0)
	$Sprite.get_material().set_shader_param('intensity',faded)
	$Sprite.get_material().set_shader_param('rnd',r)
	if is_instance_valid($Weapon):
		$Weapon.get_material().set_shader_param('intensity',faded)
		$Weapon.get_material().set_shader_param('rnd',r)

func _process(delta):
	if nextInvisible <= Vars.time():
		$Controls.visible = false
		invisibleRemaining = invisibleTime
		nextInvisible = Vars.time() + invisibleTime + invisibleCooldown * 1000
	
	if invisibleRemaining > 0:
		invisibleRemaining -= delta
		if invisibleRemaining <= 0:
			$Controls.visible = true
			invisibleRemaining = -1
	
	shadering(delta)
	$"Controls/HealthFG".rect_size.x = (health / maxHealth) * 64.0
	if $Weapon.reloading:
		$"Controls/ProgressBar".visible = true
		$"Controls/ProgressBar".get_material().set_shader_param('value',((Vars.time() - $Weapon.reloadStarted) / ($Weapon.reloadDelay)) * 100.0)
	else:
		$"Controls/ProgressBar".visible = false
	update()

func jump ():
	if lastJumpTime + jumpCooldown <= Vars.time():
		lastJumpTime = Vars.time()
		if is_on_floor():
			$"../Sounds/JumpSound".pitch_scale = 1.0
			$"../Sounds/JumpSound".play()
			velocity.y = -jumpHeight
			var node : AnimatedSprite = preload("res://Prefabs/Effects/JumpEffect.tscn").instance()
			node.position = position + get_floor_normal() * 32
			node.rotation = get_floor_normal().angle() + PI / 2
			node.playing = true
			$"..".add_child(node)
		elif airJumpsLeft > 0:
			$"../Sounds/JumpSound".pitch_scale = 0.8
			$"../Sounds/JumpSound".play()
			airJumpsLeft -= 1
			velocity.y = -jumpHeight
			var node : AnimatedSprite = preload("res://Prefabs/Effects/JumpEffect.tscn").instance()
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

func aiMove () -> void:	
	randomize()
	if $Weapon.curAmmo == 0 && $Weapon.reloading == false:
		$Weapon.reload()
	if Vars.enemyAIType == 1:
		if $"../Player".position.distance_to(position) > 1920 / 2:
			return
		if $RayCast2D.get_collider() != null && $RayCast2D.get_collider() is Node2D && $RayCast2D.get_collider().is_in_group("Player"):
			$Weapon.shoot($"../Player".position)
		else:
			if $"../Player".position.x < position.x:
				goLeft()
			else:
				goRight()
			if $"../Player".position.y < position.y:
				jump()
	elif Vars.enemyAIType == 2:
		if $"../Player".position.distance_to(position) > 1920 / 2:
			return
		if aiLastCalculated + aiMoveCalculateDelay <= Vars.time():
			aiNextMove = randi() % 100 + 1
			aiLastCalculated = Vars.time()
		
		if $RayCast2D.get_collider() != null && $RayCast2D.get_collider() is Node2D && $RayCast2D.get_collider().is_in_group("Player"):
			$Weapon.shoot($"../Player".position)
		elif aiNextMove >= 1 && aiNextMove <= 45:
			goLeft()
		elif aiNextMove >= 46 && aiNextMove <= 90:
			goRight()
		elif aiNextMove >= 91 && aiNextMove <= 100:
			jump()
			#aiLastCalculated += aiMoveCalculateDelay - 100

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


func _on_Enemy_tree_exiting():
	Vars.enemyRemaining -= 1
	for i in range(1,10):
		var node = preload("res://Prefabs/Effects/FlyingParticle.tscn").instance()
		
		var sclRnd = rand_range(1.5,2)
		node.scale.x = sclRnd
		node.scale.y = sclRnd
		node.initLifeLeft = rand_range(3,5)
		node.velocity.y = rand_range(-700,-1400)
		node.velocity.x = rand_range(-600,600)
		node.global_position = global_position
		node.global_position.x = rand_range(global_position.x - 32, global_position.x + 32)
		$"..".add_child(node)
