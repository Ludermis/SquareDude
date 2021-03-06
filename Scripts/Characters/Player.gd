extends KinematicBody2D

var velocity = Vector2.ZERO
var jumpHeight = 1024
var acceleration = 64
var maxSpeed = 384
var debugDraw = false
var wasOnFloor = false
var jumpsMax = 2
var jumpsLeft = jumpsMax
var maxHealth : float = 200
var maxArmor : float = 100
var armor : float = 0
var health : float = maxHealth
var maxUseRange = 192
var damageMultiplier = 1

# Buff Vars
var speedBoostTimeLeft : float = -1
var attackBoostTimeLeft : float = -1

func _ready():
	set_physics_process(true)
	if has_node("Weapon"):
		$Weapon.ownerNode = self
	
	# Cosmetics
	if Vars.currentCosmetics["Hat"] != 0:
		$Hat.visible = true
		$Hat.texture = load("res://Sprites/Cosmetics/Hat/" + Vars.ownedCosmetics["Hat"][Vars.currentCosmetics["Hat"]] + ".png")
		$Controls.position.x -= 32

func use ():
	var nearestPickup = Vars.getNearestPickup(position)
	if nearestPickup != null && nearestPickup.position.distance_to(position) < maxUseRange:
		if nearestPickup.is_in_group("WeaponPickup"):
			if has_node("Weapon"):
				throwWeapon()
			
			$"../Sounds/WeaponPickupSound".play()
			var newNode = load(str("res://Prefabs/Weapons/",nearestPickup.weaponName,".tscn")).instance()
			newNode.name = "Weapon"
			newNode.ownerNode = self
			if nearestPickup.curAmmo == -1:
				newNode.curAmmo = newNode.maxAmmo
			else:
				newNode.curAmmo = nearestPickup.curAmmo
			newNode.position = to_local(nearestPickup.position)
			add_child(newNode)
			nearestPickup.queue_free()

func boostHandler (delta):
	if speedBoostTimeLeft >= 0:
		$GhostTrail.visible = true
		$Controls/ProgressBar2.visible = true
		$"Controls/ProgressBar2".get_material().set_shader_param('value',(speedBoostTimeLeft / 15.0) * 100.0)
		speedBoostTimeLeft -= delta
		if speedBoostTimeLeft <= 0:
			$GhostTrail.visible = false
			maxSpeed /= 1.5
			$Controls/ProgressBar2.visible = false
			speedBoostTimeLeft = -1
	
	if attackBoostTimeLeft >= 0:
		$Controls/ProgressBar3.visible = true
		$"Controls/ProgressBar3".get_material().set_shader_param('value',(attackBoostTimeLeft / 10.0) * 100.0)
		attackBoostTimeLeft -= delta
		if attackBoostTimeLeft <= 0:
			damageMultiplier = 1
			$Controls/ProgressBar3.visible = false
			attackBoostTimeLeft = -1

func _process(delta):
	if Input.is_action_just_pressed('esc'):
		get_tree().change_scene("res://Prefabs/Scenes/MainMenuScene.tscn")
	boostHandler(delta)
	if has_node("Weapon"):
		$"Controls/AmmoLabel".visible = true
		if $Weapon.curAmmo == 0 && $Weapon.reloading == false:
			$Weapon.reload()
			
		$"Controls/AmmoLabel".text = str($Weapon.curAmmo, "/", $Weapon.maxAmmo)
		
		if $Weapon.reloading:
			$"Controls/ProgressBar".visible = true
			$"Controls/ProgressBar".get_material().set_shader_param('value',((Vars.time() - $Weapon.reloadStarted) / ($Weapon.reloadDelay * 1000)) * 100.0)
		else:
			$"Controls/ProgressBar".visible = false
	else:
		$"Controls/AmmoLabel".visible = false
		$"Controls/ProgressBar".visible = false
	
	$"Controls/HealthFG".rect_size.x = (health / maxHealth) * 64.0
	$"Controls/ArmorFG".rect_size.x = (armor / maxArmor) * 64.0
	update()

func takeDamage (attacker, damage):
	var leftOverDamage = damage
	if armor > 0:
		armor -= damage
		if armor < 0:
			leftOverDamage = abs(armor)
			armor = 0
		else:
			leftOverDamage = 0
	
	health -= leftOverDamage
	$"Controls/HealthFG".rect_size.x = (health / maxHealth) * 64.0
	$"Controls/ArmorFG".rect_size.x = (health / maxHealth) * 64.0
	if health <= 0:
		$"../CanvasLayer".add_child(preload("res://Prefabs/Overlays/GameOverScene.tscn").instance())

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
	if jumpsLeft > 0:
		if jumpsLeft == jumpsMax:
			$"../Sounds/JumpSound".pitch_scale = 1.0
		else:
			$"../Sounds/JumpSound".pitch_scale = 0.8
		$"../Sounds/JumpSound".play()
		jumpsLeft -= 1
		velocity.y = -jumpHeight
		var node : AnimatedSprite = preload("res://Prefabs/Effects/JumpEffect.tscn").instance()
		node.position = position + get_floor_normal() * 32
		node.rotation = rotation - PI / 2
		node.playing = true
		$"..".add_child(node)

func throwWeapon ():
	var weaponName = $Weapon.weaponName
	var curAmmo = $Weapon.curAmmo
	$Weapon.free()
	var node = preload("res://Prefabs/Pickups/WeaponPickup.tscn").instance()
	node.init(weaponName)
	node.position = position
	node.curAmmo = curAmmo
	node.velocity = (get_global_mouse_position() - position).normalized() * 1024
	get_tree().root.get_node("Main").add_child(node)

func _physics_process(delta):
	velocity += Vars.gravity * delta
	if Input.is_action_pressed('right'):
		velocity.x = min(velocity.x + acceleration, maxSpeed)
	elif Input.is_action_pressed('left'):
		velocity.x = max(velocity.x - acceleration, -maxSpeed)
	else:
		velocity.x = lerp(velocity.x,0,Vars.friction)
	
	if is_on_floor():
		jumpsLeft = jumpsMax
		var normal = get_floor_normal()
		var angleDelta = normal.angle() - (rotation - PI)
		rotation = lerp(rotation,angleDelta + rotation,0.4)
	
	if Input.is_action_just_pressed('up'):
		jump()
	
	if Input.is_action_just_pressed("misc1"):
		var node = preload("res://Prefabs/Characters/TeleportingEnemy.tscn").instance()
		node.position = get_global_mouse_position()
		$"..".add_child(node)
	
	if has_node("Weapon"):
		if Input.is_action_just_pressed("reload") &&  $Weapon.reloading == false && $Weapon.curAmmo < $Weapon.maxAmmo:
			$Weapon.reload()
		$Weapon.rotation = Vars.joyStickRotation - PI / 2
		#print(str($Weapon.rotation_degrees))
		if $Weapon.rotation < -PI || ($Weapon.rotation > 0 && $Weapon.rotation < PI / 2):
			$Weapon.flip_v = true
		else:
			$Weapon.flip_v = false
		if Input.is_action_pressed('shoot'):
			$Weapon.shootByAngle()
		if Input.is_action_just_pressed('throw_weapon'):
			throwWeapon()
	
	if Input.is_action_just_pressed('use'):
		use()

	if !is_on_floor():
		wasOnFloor = false

	velocity = move_and_slide(velocity,Vector2.UP)
	
	if Vars.enemyRemaining == 0:
		$"../CanvasLayer".add_child(preload("res://Prefabs/Overlays/LevelCompletedScene.tscn").instance())
