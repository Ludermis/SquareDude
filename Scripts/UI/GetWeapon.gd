extends TouchScreenButton


func _ready():
	pass


func _on_GetWeapon_pressed():
	Input.action_press('use')

func _on_GetWeapon_released():
	Input.action_release('use')
