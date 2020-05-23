extends Node2D

func _ready():
	reloadItems()

func reloadItems ():
	$MoneyPanel/MoneyLabel.text = str(Vars.money)
	$MoneyPanel/CrystalLabel.text = str(Vars.crystal)
	for child in $ScrollContainer/VScrollBar.get_children():
		child.queue_free()
	var itemCount = 0
	for i in Vars.cosmeticTypes:
		for j in Vars.allCosmetics[i]:
			if Vars.ownedCosmetics[i].has(j):
				continue
			itemCount += 1
	var cases = []
	var curCase = 0
	var curCaseItem = 0
	var neededCases = int(ceil(itemCount / 3.0))
	for i in range(neededCases):
		var tmp = preload("res://Prefabs/UI/HBoxContainer1.tscn").instance()
		cases.append(tmp)
		$ScrollContainer/VScrollBar.add_child(tmp)
	for i in Vars.cosmeticTypes:
		for j in Vars.allCosmetics[i]:
			if Vars.ownedCosmetics[i].has(j):
				continue
			if curCaseItem == 3:
				curCaseItem = 0
				curCase += 1
			var tmp = preload("res://Prefabs/UI/ItemCase.tscn").instance()
			tmp.itemCategory = i
			tmp.itemName = j
			cases[curCase].add_child(tmp)
			curCaseItem += 1

func _process(delta):
	pass
