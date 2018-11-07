extends HBoxContainer

func _on_play_button_toggled(button_pressed):
	if button_pressed:
		sim.play()
	else:
		sim.pause()


func _on_x2_button_toggled(button_pressed):
	sim.set_simulation_speed(button_pressed)