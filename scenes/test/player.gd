extends KinematicBody2D

var dragging = false
const MOTION_SPEED = 160
onready var time_elapsed = 0


func _physics_process(delta):
	var motion = (get_global_mouse_position() - global_position) * MOTION_SPEED * delta
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		dragging = true
		move_and_slide(motion)
	else:
		dragging = false

	if dragging:
		move_and_slide(motion)



func _on_player_area_entered(area):
	pass # Replace with function body.
