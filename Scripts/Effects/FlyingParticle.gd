extends KinematicBody2D

var velocity = Vector2.ZERO
var lifeLeft : float
var initLifeLeft : float = 5

func _ready():
	set_physics_process(true)
	lifeLeft = initLifeLeft


func _process(delta):
	pass

func _physics_process(delta):
	velocity += Vars.gravity
	if is_on_floor():
		var normal = get_floor_normal()
		var angleDelta = normal.angle() - (rotation - PI)
		rotation = lerp(rotation,angleDelta + rotation,0.4)
		velocity.x = lerp(velocity.x,0,Vars.friction)
	
	velocity = move_and_slide(velocity,Vector2.UP)
	lifeLeft -= delta
	$Sprite.modulate.a = (lifeLeft / initLifeLeft)
	if lifeLeft <= 0:
		queue_free()
