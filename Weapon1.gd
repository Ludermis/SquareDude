extends Sprite

var ownerNode
var lastShoot = 0
var shootDelay = 100
var damage = 10
var maxAmmo = 20
var curAmmo = maxAmmo
var reloadDelay = 1000
var reloading = false
var reloadStarted = 0

func _ready():
	pass

func _process(delta):
	if reloading && reloadStarted + reloadDelay <= Vars.time():
		curAmmo = maxAmmo
		reloading = false

func shoot (target):

	
	if !reloading && curAmmo > 0 && lastShoot + shootDelay <= Vars.time():
		#$ShootSound.pitch_scale = rand_range(1.3,1.5)
		$ShootSound.play()
		ownerNode.velocity.x -= (target - ownerNode.position).normalized().x * 25
		lastShoot = Vars.time()
		var node = preload("res://Bullet.tscn").instance()
		node.position = to_global(Vars.rotatePoint(position + Vector2(16,0),position,get_angle_to(target)))
		node.dir = target - ownerNode.position
		node.dir = node.dir.normalized()
		node.look_at(target)
		node.ownerNode = $".."
		node.damage = damage
		$"../..".add_child(node)
		$"../../Camera2D".shake(0.2,15,4)
		curAmmo -= 1

func reload ():
	reloadStarted = Vars.time()
	reloading = true
