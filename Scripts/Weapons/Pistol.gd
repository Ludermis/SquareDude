extends Sprite

var ownerNode : Node2D
var lastShoot = -100000
var shootDelay = 1.85
var damage = 12.5
var maxAmmo = 13
var curAmmo = maxAmmo
var reloadDelay = 1
var reloading = false
var reloadStarted = 0
var weaponName = "Pistol"
var readyToShoot = false

func _ready():
	pass

func _process(delta):
	if reloading && reloadStarted + reloadDelay * 1000 <= Vars.time():
		curAmmo = maxAmmo
		reloading = false
	if global_position.distance_to(ownerNode.global_position) > 4:
		global_position = lerp(global_position,ownerNode.global_position,0.2)
	else:
		readyToShoot = true
		global_position = ownerNode.global_position

func shoot (target):
	
	if readyToShoot && !reloading && curAmmo > 0 && lastShoot + (1000.0 / shootDelay) <= Vars.time():
		$"../../Sounds/PistolAttackSound".play()
		ownerNode.velocity.x -= (target - ownerNode.position).normalized().x * 25
		lastShoot = Vars.time()
		var node = preload("res://Prefabs/Bullets/Bullet.tscn").instance()
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

func shootByAngle ():
	shoot(Vars.rotatePoint(global_position + Vector2(16,0),global_position,rotation + PI / 2))

func reload ():
	if ownerNode.is_in_group("Player"):
		$"../../Sounds/PistolReloadSound".play()
	reloadStarted = Vars.time()
	reloading = true
