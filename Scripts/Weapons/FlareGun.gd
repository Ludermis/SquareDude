extends Sprite

var ownerNode : Node2D
var lastShoot = -100000
var shootDelay = 2
var damage = 15
var maxAmmo = 1
var curAmmo = maxAmmo
var reloadDelay = 1
var reloading = false
var reloadStarted = 0
var weaponName = "FlareGun"
var readyToShoot = false

func _ready():
	pass

func _process(delta):
	if reloading && reloadStarted + reloadDelay * 1000 <= Vars.time():
		curAmmo = maxAmmo
		reloading = false
	if global_position.distance_to(ownerNode.position) > 4:
		global_position = lerp(global_position,ownerNode.position,0.2)
	else:
		readyToShoot = true
		global_position = ownerNode.position

func shoot (target):
	
	if readyToShoot && !reloading && curAmmo > 0 && lastShoot + (1000.0 / shootDelay) <= Vars.time():
		$"../../Sounds/FlareGunAttackSound".play()
		ownerNode.velocity.x -= (target - ownerNode.position).normalized().x * 25
		lastShoot = Vars.time()
		var node = preload("res://Prefabs/Bullets/Flare.tscn").instance()
		node.position = to_global(Vars.rotatePoint(position + Vector2(16,0),position,get_angle_to(target)))
		node.dir = target - ownerNode.position
		node.dir = node.dir.normalized()
		node.rotation = (target - ownerNode.position).angle()
		node.ownerNode = $".."
		node.damage = damage * ownerNode.damageMultiplier
		if ownerNode.is_in_group("Enemy"):
			node.modulate = Color.red
		$"../..".add_child(node)
		Vars.currentCamera.shake(0.2,15,4)
		curAmmo -= 1

func shootByAngle ():
	shoot(Vars.rotatePoint(global_position + Vector2(16,0),global_position,rotation + PI / 2))

func reload ():
	if ownerNode.is_in_group("Player"):
		$"../../Sounds/ReloadSound".play()
	reloadStarted = Vars.time()
	reloading = true
