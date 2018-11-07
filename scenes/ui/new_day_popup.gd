extends WindowDialog

func _ready():
	pass 


func _on_button_ok_pressed():
	var glasses = $MarginContainer/VBoxContainer/GridContainer/glasses.text
	var signs = $MarginContainer/VBoxContainer/GridContainer/signs.text
	var glass_price = $MarginContainer/VBoxContainer/GridContainer/glass_price.text
	
	if glasses == "" or signs == "" or glass_price == "":
		return
	
	sim.supply_for_new_day(int(glasses), int(signs), float(glass_price))
	hide()
