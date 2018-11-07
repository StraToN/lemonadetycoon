extends Node

# TIME MANAGEMENT
var day # unused for now
onready var hours = int(ProjectSettings.get_setting("game/time/work_day_start_time").split(":")[0])
onready var minutes = int(ProjectSettings.get_setting("game/time/work_day_start_time").split(":")[1])
onready var hours_worked_per_day = 1 #8am to 18pm 
const REAL_TIME_FIVE_MIN_IG = 3.0

# MONEY
onready var current_money = ProjectSettings.get_setting("game/money/starting_money")
onready var glass_price = 0.02

# STOCKS
onready var current_lemons = 100 # pieces
onready var current_sugar = 1 # kg
onready var current_glasses = 0

signal time_tick(hours, minutes)
signal end_of_day
signal stock_update(stock_dict)

func _ready():
	emit_signal("time_tick", hours, minutes)
	$Timer.wait_time = REAL_TIME_FIVE_MIN_IG


func play():
	get_tree().paused = false
	$Timer.paused = false
	$Timer.start()

func set_simulation_speed(is_fast):
	if is_fast:
		$Timer.wait_time = 1.0
	else:
		$Timer.wait_time = REAL_TIME_FIVE_MIN_IG
	
func pause():
	get_tree().paused = true
	$Timer.paused = true

func _on_Timer_timeout():
	minutes = minutes + 5
	if minutes == 60:
		minutes = 0
		hours = hours + 1
		
	if hours == 24:
		hours = 0
	
	if hours == int(ProjectSettings.get_setting("game/time/work_day_start_time").split(":")[0]) + hours_worked_per_day:
		emit_signal("end_of_day")
	
	emit_signal("time_tick", hours, minutes)


func supply_for_new_day(_glasses, _signs, _glass_price):
	current_glasses = _glasses
	glass_price = _glass_price
	notify_stock_update()
	play()

func notify_stock_update():
	var stock_dict = {}
	stock_dict.glasses = current_glasses
	stock_dict.money = current_money
	emit_signal("stock_update", stock_dict)