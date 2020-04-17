extends Sprite

var ownerNode
var lastShoot = 0
var shootDelay = 100
var damage = 10

func _ready():
	pass

func _process(delta):
	pass

func shoot (target):
	if lastShoot + shootDelay <= Vars.time():
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
