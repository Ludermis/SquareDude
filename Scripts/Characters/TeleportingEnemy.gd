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
var lastJumpTime = 0
var jumpCooldown = 200
var damageMultiplier = 1

var teleporting = false
var teleportingCooldown : float = 10
var nextTeleporting : float = -1

# AI Type 2 Vars
var aiNextMove = -1
var aiLastCalculated = 0
var aiMoveCalculateDelay = 500

func _ready():
	set_physics_process(true)
	$Weapon.ownerNode = self
	Vars.enemyRemaining += 1
	nextTeleporting = Vars.time() + teleportingCooldown * 1000
	$Particles2D.emitting = false
	$Weapon.shootDelay /= 2

func teleport ():
	$Particles2D.preprocess = 2
	$Particles2D.emitting = true
	teleporting = true
	$Sprite.play("teleporting");
	$Controls.visible = false
	$Weapon.visible = false

func _process(delta):
	if nextTeleporting <= Vars.time():
		
		teleport()
		nextTeleporting = Vars.time() + teleportingCooldown * 1000
	
	$"Controls/HealthFG".rect_size.x = (health / maxHealth) * 64.0
	if $Weapon.reloading:
		$"Controls/ProgressBar".visible = true
		$"Controls/ProgressBar".get_material().set_shader_param('value',((Vars.time() - $Weapon.reloadStarted) / ($Weapon.reloadDelay * 1000)) * 100.0)
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
	if teleporting:
		return
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
	velocity += Vars.gravity * delta
	
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
	Vars.money += (randi() % 20) + 10
	for i in range(1,10):
		var node = preload("res://Prefabs/Effects/FlyingParticle.tscn").instance()
		
		var sclRnd = rand_range(1.5,2)
		node.get_node("Sprite").texture = $Sprite.frames.get_frame("default",0)
		node.scale.x = sclRnd
		node.scale.y = sclRnd
		node.initLifeLeft = rand_range(3,5)
		node.velocity.y = rand_range(-700,-1400)
		node.velocity.x = rand_range(-600,600)
		node.position = position
		node.position.x = rand_range(position.x - 32, position.x + 32)
		get_tree().root.get_node("Main").call_deferred("add_child",node)


func _on_Sprite_animation_finished():
	randomize()
	if $Sprite.animation == "teleporting":
		$Sprite.play("spawning")
		var arr = get_tree().root.get_node("Main").get_children()
		var rndArr = []
		for i in arr:
			if "Floor" in i.name:
				rndArr.append(i)
		var nodeToTeleport = rndArr[randi() % rndArr.size()]
		while nodeToTeleport.position.distance_to(get_tree().root.get_node("Main/Player").position) > 1920:
			nodeToTeleport = rndArr[randi() % rndArr.size()]
		position.x = nodeToTeleport.position.x
		position.y = nodeToTeleport.position.y - 32
	elif $Sprite.animation == "spawning":
		teleporting = false
		$Weapon.visible = true
		$Controls.visible = true
		$Particles2D.emitting = false
