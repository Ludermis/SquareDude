extends TouchScreenButton


func _ready():
	pass


func _on_RightButton_pressed():
	Input.action_press('right')

func _on_RightButton_released():
	Input.action_release('right')
