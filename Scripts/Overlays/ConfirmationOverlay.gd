extends Control

export var itemCategory = ""
export var itemName = ""

func _ready():
	$Panel/Item.texture = load("res://Sprites/Cosmetics/" + itemCategory + "/" + itemName + ".png")

func _process(delta):
	pass


func _on_YesButton_pressed():
	Vars.ownedCosmetics[itemCategory].append(itemName)
	Vars.money -= Vars.cosmeticsPrice[itemName]
	get_tree().root.get_node("Main").reloadItems()
	queue_free()


func _on_NoButton_pressed():
	queue_free()
