extends TextureButton

export var itemCategory = ""
export var itemName = ""

func _ready():
	$TextureRect.texture = load("res://Sprites/Cosmetics/" + itemCategory + "/" + itemName + ".png")
	$MoneyLabel.text = str(Vars.cosmeticsPrice[itemName])

func _process(delta):
	pass


func _on_ItemCase_pressed():
	if Vars.money < Vars.cosmeticsPrice[itemName]:
		return
	var tmp = preload("res://Prefabs/Overlays/ConfirmationOverlay.tscn").instance()
	tmp.itemCategory = itemCategory
	tmp.itemName = itemName
	get_tree().root.get_node("Main").add_child(tmp)
