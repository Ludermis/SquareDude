extends TouchScreenButton


func _ready():
	pass

func _on_LeftButton_pressed():
	Input.action_press('left')


func _on_LeftButton_released():
	Input.action_release('left')
