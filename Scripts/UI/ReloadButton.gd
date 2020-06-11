extends TouchScreenButton

var type = "reload"

func _ready():
	pass

func _process(delta):
	var nearestPickup = Vars.getNearestPickup(get_tree().root.get_node("Main/Player").position)
	if nearestPickup != null && nearestPickup.position.distance_to(get_tree().root.get_node("Main/Player").position) < get_tree().root.get_node("Main/Player").maxUseRange:
		if nearestPickup.is_in_group("WeaponPickup") && type != "use":
			normal = preload("res://Sprites/UI/swapbutton.png")
			type = "use"
			visible = true
	elif get_tree().root.get_node("Main/Player").has_node("Weapon") && get_tree().root.get_node("Main/Player/Weapon").curAmmo != get_tree().root.get_node("Main/Player/Weapon").maxAmmo && get_tree().root.get_node("Main/Player/Weapon").reloading == false:
		if type != "reload":
			normal = preload("res://Sprites/UI/reloadbutton.png")
			type = "reload"
			visible = true
	else:
		if type != "empty":
			type = "empty"
			visible = false

func _on_ReloadButton_pressed():
	if type == "empty":
		return
	Input.action_press(type)


func _on_ReloadButton_released():
	if type == "empty":
		return
	Input.action_release(type)
