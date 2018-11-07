extends Node2D

const MAX_SURFACES = 5

var nb_liquids = 0
var detail_percentage_scn = preload("res://scenes/recipe_creator/detail_precentages/HBoxContainer.tscn")
var array_liquids_values = []

func _on_Plus_pressed():
	if nb_liquids < MAX_SURFACES:
		nb_liquids += 1
		$Glass.set_liquids_number(nb_liquids)
		$Number.text = str(nb_liquids)

func _on_Moins_pressed():
	if $Glass.liquids_number >= 0:
		nb_liquids -= 1
		$Glass.set_liquids_number(nb_liquids)
		$Number.text = str(nb_liquids)


func _on_Glass_surface_created(surface):
	printt("SURFACE CREATED!", surface)
	var new_detail_percentage_scn = detail_percentage_scn.instance()
	$elementsList.add_child(new_detail_percentage_scn)
	for hbox in $elementsList.get_children():
		hbox.get_node("value").text = str(100 / nb_liquids) + " %"
	
	var liquid_value_dict = {}
	liquid_value_dict.id = nb_liquids
	liquid_value_dict.object = new_detail_percentage_scn
	liquid_value_dict.value = 100 / nb_liquids
	array_liquids_values.append(liquid_value_dict)
	recalculate_all_percents()

func _on_Glass_surface_moved(surface, offset):
	printt("SURFACE MOVED!", surface, offset)
	update_percent(surface, offset)

func _on_Glass_surface_removed(surface):
	printt("SURFACE REMOVED!", surface)
	
	var dict_found
	for liquid_value_dict in array_liquids_values:
		if liquid_value_dict.object == surface:
			dict_found = liquid_value_dict
			break;
	array_liquids_values.erase(dict_found)
	recalculate_all_percents()



func update_percent(surface, offset):
	for liquid_value_dict in array_liquids_values:
		if liquid_value_dict.object == surface:
			liquid_value_dict.value -= offset
			break;
	printt(array_liquids_values)
	update_ui()

func recalculate_all_percents():
	for liquid_value_dict in array_liquids_values:
		liquid_value_dict.value = 100 / nb_liquids
	update_ui()

func update_ui():
	for liquid_value_dict in array_liquids_values:
		var val = str(array_liquids_values[liquid_value_dict.id-1].value) + " %"
	
		for hbox in $elementsList.get_children():
			if hbox.get_node("id_liquid").text == str(liquid_value_dict.id):
				hbox.get_node("value").text = val
				break
		