extends KinematicBody2D

export var weaponName : String
var velocity = Vector2.ZERO
var positionY = null
var startFloating = null
var curAmmo = -1

func init (name):
	weaponName = name
	$Sprite.texture = load("res://Sprites/Weapons/" + weaponName + ".png")

func _ready():
	set_physics_process(true)
	$Sprite.texture = load("res://Sprites/Weapons/" + weaponName + ".png")

func _physics_process(delta):
	if positionY == null:
		velocity += Vars.gravity * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)
	if velocity.y != 0:
		velocity.x = lerp(velocity.x,0,Vars.friction / 10)
	else:
		velocity.x = lerp(velocity.x,0,Vars.friction / 3)
	
	if velocity.y == 0 && abs(velocity.x) < 64 && positionY == null:
		positionY = position.y
		startFloating = Vars.time()

	if positionY != null:
		position.y = positionY - (1 + sin((Vars.time() - startFloating) / 384)) * 8

func _process(delta):
	pass
