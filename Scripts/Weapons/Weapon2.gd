extends AnimatedSprite

var ownerNode : Node2D
var lastShoot = -100000
var shootDelay = 790
var damage = 10
var maxAmmo = 5
var curAmmo = maxAmmo
var reloadDelay = 1000
var reloading = false
var reloadStarted = 0
var weaponName = "Weapon2"
var readyToShoot = false

func _ready():
	pass

func _process(delta):
	if reloading && reloadStarted + reloadDelay <= Vars.time():
		curAmmo = maxAmmo
		reloading = false
	if global_position.distance_to(ownerNode.global_position) > 4:
		global_position = lerp(global_position,ownerNode.global_position,0.2)
	else:
		readyToShoot = true
		global_position = ownerNode.global_position

func _draw():
#	var target = get_global_mouse_position()
#	var target2 = get_global_mouse_position() - ownerNode.global_position
#	target2 = target2.normalized()
#	target2 *= 16
#	target2 += ownerNode.global_position
#	target2 = Vars.rotatePoint(target2,ownerNode.global_position,-PI / 36)
#
#	draw_circle(to_local(target),10,Color.blue)
#	draw_circle(to_local(target2),10,Color.red)
	pass

func shoot (target):

	
	if !reloading && curAmmo > 0 && lastShoot + shootDelay <= Vars.time():
		frame = 0
		play()
		$"../../Sounds/ShotgunBlastSound".play()
		ownerNode.velocity.x -= (target - ownerNode.position).normalized().x * 25
		lastShoot = Vars.time()
		
		#Bullet 1
		
		var node1 = preload("res://Prefabs/Bullets/Bullet.tscn").instance()
		node1.position = to_global(Vars.rotatePoint(position + Vector2(16,0),position,get_angle_to(target)))
		node1.dir = target - ownerNode.position
		node1.dir = node1.dir.normalized()
		node1.look_at(target)
		node1.ownerNode = $".."
		node1.damage = damage * ownerNode.damageMultiplier
		if ownerNode.is_in_group("Enemy"):
			node1.modulate = Color.red
		$"../..".add_child(node1)
		
		#Bullet 2
		
		var node2 = preload("res://Prefabs/Bullets/Bullet.tscn").instance()
		
		var target2 = target - ownerNode.global_position
		target2 = target2.normalized()
		target2 *= 16
		target2 += ownerNode.global_position
		target2 = Vars.rotatePoint(target2,ownerNode.global_position,-PI / 36)
		
		node2.position = to_global(Vars.rotatePoint(position + Vector2(16,0),position,get_angle_to(target2)))
		node2.dir = target2 - ownerNode.position
		node2.dir = node2.dir.normalized()
		node2.look_at(target2)
		node2.rotation += PI
		node2.ownerNode = $".."
		node2.damage = damage * ownerNode.damageMultiplier
		if ownerNode.is_in_group("Enemy"):
			node2.modulate = Color.red
		$"../..".add_child(node2)
		
		# Bullet 3
		var node3 = preload("res://Prefabs/Bullets/Bullet.tscn").instance()
		
		var target3 = target - ownerNode.global_position
		target3 = target3.normalized()
		target3 *= 16
		target3 += ownerNode.global_position
		target3 = Vars.rotatePoint(target3,ownerNode.global_position,PI / 36)
		
		node3.position = to_global(Vars.rotatePoint(position + Vector2(16,0),position,get_angle_to(target3)))
		node3.dir = target3 - ownerNode.position
		node3.dir = node3.dir.normalized()
		node3.look_at(target3)
		node3.rotation += PI
		node3.ownerNode = $".."
		node3.damage = damage * ownerNode.damageMultiplier
		if ownerNode.is_in_group("Enemy"):
			node3.modulate = Color.red
		$"../..".add_child(node3)
		
		Vars.currentCamera.shake(0.2,15,4)
		curAmmo -= 1

func reload ():
	reloadStarted = Vars.time()
	reloading = true
