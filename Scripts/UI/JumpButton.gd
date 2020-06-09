extends TouchScreenButton


func _ready():
	pass


func _on_JumpButton_pressed():
	Input.action_press('up')


func _on_JumpButton_released():
	Input.action_release('up')
