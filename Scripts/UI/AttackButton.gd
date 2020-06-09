extends TouchScreenButton


func _ready():
	pass


func _on_AttackButton_pressed():
	Input.action_press('shoot')


func _on_AttackButton_released():
	Input.action_release('shoot')
