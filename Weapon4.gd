extends Sprite

var ownerNode : Node2D
var lastShoot = -100000
var shootDelay = 500
var damage = 15
var maxAmmo = 13
var curAmmo = maxAmmo
var reloadDelay = 1000
var reloading = false
var reloadStarted = 0
var weaponName = "Weapon4"
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

func shoot (target):
	
	if readyToShoot && !reloading && curAmmo > 0 && lastShoot + shootDelay <= Vars.time():
		$"../../Sounds/ShootSound".play()
		ownerNode.velocity.x -= (target - ownerNode.position).normalized().x * 25
		lastShoot = Vars.time()
		var node = preload("res://Bullet.tscn").instance()
		node.position = to_global(Vars.rotatePoint(position + Vector2(16,0),position,get_angle_to(target)))
		node.dir = target - ownerNode.position
		node.dir = node.dir.normalized()
		node.look_at(target)
		node.ownerNode = $".."
		node.damage = damage * ownerNode.damageMultiplier
		if ownerNode.is_in_group("Enemy"):
			node.modulate = Color.red
		$"../..".add_child(node)
		Vars.currentCamera.shake(0.2,15,4)
		curAmmo -= 1

func reload ():
	reloadStarted = Vars.time()
	reloading = true
