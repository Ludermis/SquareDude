extends Sprite

var ownerNode : Node2D
var lastShoot = -100000
var shootDelay = 175
var damage = 100
var maxAmmo = 1
var curAmmo = maxAmmo
var reloadDelay = 2000
var reloading = false
var reloadStarted = 0
var weaponName = "Sniper"
var readyToShoot = false
var canKill = false

func _ready():
	pass

func _process(delta):
	if flip_v && $LaserBeam2D.position.y == -2:
		$LaserBeam2D.position.y = 2
	elif !flip_v && $LaserBeam2D.position.y != -2:
		$LaserBeam2D.position.y = -2
	
	if reloading && reloadStarted + 100 <= Vars.time():
		$LaserBeam2D.is_casting = false
	if reloading && reloadStarted + reloadDelay <= Vars.time():
		curAmmo = maxAmmo
		reloading = false
	if global_position.distance_to(ownerNode.global_position) > 4:
		global_position = lerp(global_position,ownerNode.global_position,0.2)
	else:
		readyToShoot = true
		global_position = ownerNode.global_position
	if canKill && $LaserBeam2D.is_casting && $LaserBeam2D.get_collider() != null && $LaserBeam2D.get_collider().is_in_group("Enemy"):
			$LaserBeam2D.get_collider().takeDamage(ownerNode,damage)
			if $LaserBeam2D.get_collider().health > 0:
				canKill = false

func shoot (target):
	
	if readyToShoot && !reloading && curAmmo > 0 && lastShoot + shootDelay <= Vars.time():
		$"../../Sounds/RifleAttackSound".play()
		canKill = true
		ownerNode.velocity.x -= (target - ownerNode.position).normalized().x * 25 * 50
		lastShoot = Vars.time()
		Vars.currentCamera.shake(0.2,15,4)
		curAmmo -= 1
		$LaserBeam2D.is_casting = true

func reload ():
	if ownerNode.is_in_group("Player"):
		$"../../Sounds/RifleReloadSound".play()
	reloadStarted = Vars.time()
	reloading = true
