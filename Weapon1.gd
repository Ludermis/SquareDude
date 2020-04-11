extends Sprite

var ownerNode
var lastShoot = 0
var shootDelay = 100

func _ready():
	pass

func _process(delta):
	pass

func shoot ():
	if lastShoot + shootDelay <= Vars.time():
		lastShoot = Vars.time()
		var node = preload("res://Bullet.tscn").instance()
		node.position = to_global(Vars.rotatePoint(position + Vector2(16,0),position,get_angle_to(get_global_mouse_position())))
		node.dir = get_global_mouse_position() - ownerNode.position
		node.dir = node.dir.normalized()
		node.look_at(get_global_mouse_position())
		node.ownerNode = $".."
		$"../..".add_child(node)
		$"../../Camera2D".shake(0.2,15,4)
