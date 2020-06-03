extends Area2D


func _ready():
	pass


func _on_Area2D_body_entered(body):
	if body.name == "Player" && body.has_node("Weapon"):
		body.get_node("Weapon").queue_free()
