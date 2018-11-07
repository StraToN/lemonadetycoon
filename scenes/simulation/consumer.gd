extends Node

export(Curve) var day_consumption

func get_consumption_at_time(hours, minutes):
	var work_day_start_hour = int(ProjectSettings.get_setting("game/time/work_day_start_time").split(":")[0])
	var work_day_end_hour = work_day_start_hour + ProjectSettings.get_setting("game/time/work_day_duration")
	
	return day_consumption.interpolate(hours/24 + minutes/1440)
	
	