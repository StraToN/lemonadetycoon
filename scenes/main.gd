extends Node2D

func _ready():
	sim.connect("time_tick", self, "_on_simulation_time_tick")
	sim.connect("stock_update", self, "_on_simulation_stock_update")
	
	var work_day_start_hour = ProjectSettings.get_setting("game/time/work_day_start_time").split(":")[0]
	var work_day_start_minutes = ProjectSettings.get_setting("game/time/work_day_start_time").split(":")[1]
	$ui/ui_time_control/time.text = work_day_start_hour.pad_zeros(2) + ":" + work_day_start_minutes.pad_zeros(2)
	
	var starting_money = ProjectSettings.get_setting("game/money/starting_money")
	$ui/ui_stock/hbox_money/money_amount.text = str(starting_money)
	$ui/new_day_popup.popup()


func _on_simulation_time_tick(hours, minutes):
	$ui/ui_time_control/time.text = str(hours).pad_zeros(2) + ":" + str(minutes).pad_zeros(2)


func _on_simulation_stock_update(stock_dict):
	$ui/ui_stock/hbox_glasses/glass_amount.text = str(stock_dict.glasses)
	$ui/ui_stock/hbox_money/money_amount.text = str(stock_dict.money)
