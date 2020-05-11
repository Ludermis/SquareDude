extends KinematicBody2D

var velocity = Vector2.ZERO
var positionY = null
var startFloating = null
var health = 50

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	if positionY == null:
		velocity += Vars.gravity
	
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


func _on_Area2D_body_entered(body : Node2D):
	if body.is_in_group("Player"):
		if body.health != body.maxHealth:
			body.health = min(body.health + health,body.maxHealth)
			queue_free()
