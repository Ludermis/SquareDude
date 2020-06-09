extends Sprite

var ownerNode : Node2D
var lastShoot = -100000
var shootDelay = 5.8
var damage = 100
var maxAmmo = 1
var curAmmo = maxAmmo
var reloadDelay = 1.25
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
	if reloading && reloadStarted + reloadDelay * 1000 <= Vars.time():
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
	
	if readyToShoot && !reloading && curAmmo > 0 && lastShoot + (1000.0 / shootDelay) <= Vars.time():
		$"../../Sounds/SniperAttackSound".play()
		canKill = true
		ownerNode.velocity.x -= (target - ownerNode.position).normalized().x * 25 * 50
		ownerNode.velocity.y -= (target - ownerNode.position).normalized().y * 25 * 50 / 2
		lastShoot = Vars.time()
		Vars.currentCamera.shake(0.2,15,4)
		curAmmo -= 1
		$LaserBeam2D.is_casting = true

func shootByAngle ():
	shoot(Vars.rotatePoint(global_position + Vector2(16,0),global_position,rotation + PI / 2))

func reload ():
	if ownerNode.is_in_group("Player"):
		$"../../Sounds/SniperReloadSound".play()
	reloadStarted = Vars.time()
	reloading = true
