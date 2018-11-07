tool
extends Sprite

const PIXELS_TO_TOP = 30
const LIQUIDS_MOTION_SPEED = 50

var liquids_number = 0 setget set_liquids_number,get_liquids_number
export(int) var bottom = 10 setget set_bottom,get_bottom
export(bool) var bubbles = false setget set_bubbles_emitting,get_bubbles_emitting

var liquid_surface_scene = load("res://scenes/recipe_creator/liquid_surface.tscn")
var surfaces_array = []

var dragging = false
var surface_node_being_dragged
var drag_start_height = 0
var y_gap

signal surface_created(surface)
signal surface_removed(surface)
signal surface_moved(surface, offset)

func _ready():
	randomize()
	set_physics_process(false)

func _physics_process(delta):
	if dragging:
		var mouse_offset_y = get_global_mouse_position().y - surface_node_being_dragged.global_position.y
		var offset_y = mouse_offset_y * delta * LIQUIDS_MOTION_SPEED
		var offset = Vector2(0, offset_y)
		
		if surface_can_move(surface_node_being_dragged, offset):
			emit_signal("surface_moved", surface_node_being_dragged, round(offset_y))
			var kinematic_collision = surface_node_being_dragged.move_and_collide(offset)
			
			if kinematic_collision == null:
				surface_node_being_dragged.get_node("area").rect_size.y -= round(offset_y)

func recalculate_y_gap():
	if liquids_number >= 1:
		y_gap = (texture.get_height() - PIXELS_TO_TOP) / liquids_number

func set_liquids_number(number):
	liquids_number = number
	
	if liquids_number < surfaces_array.size():
		remove_last_liquid()
	elif liquids_number > surfaces_array.size():
		create_liquid()

func get_liquids_number():
	return liquids_number

func set_bottom(value):
	bottom = value
	recalculate_y_gap()
	reorder_surfaces()

func get_bottom():
	return bottom

func create_liquid():
	var new_surface = liquid_surface_scene.instance()
	new_surface.name = str(liquids_number)
	
	if liquids_number > 1:
		new_surface.get_node("drag_button").visible = true
		new_surface.get_node("drag_button").connect("button_down", self, "_on_surface_button_down", [new_surface])
		new_surface.get_node("drag_button").connect("button_up", self, "_on_surface_button_up")
	
	
	new_surface.get_node("area").color = Color(randf(), randf(), randf(), 0.7)
	new_surface.get_node("name_label").text = new_surface.name

	surfaces_array.append(new_surface)
	$surfaces.add_child(new_surface)
	emit_signal("surface_created", new_surface)
	recalculate_y_gap()
	reorder_surfaces()

func remove_last_liquid():
	var liquid_surface_node = surfaces_array.back()
	emit_signal("surface_removed", liquid_surface_node)
	$surfaces.remove_child(liquid_surface_node)
	surfaces_array.erase(liquid_surface_node)
	recalculate_y_gap()
	reorder_surfaces()

func reorder_surfaces():
	for i in range(0, surfaces_array.size()):
		var liquid = surfaces_array[i]
		var first_y = PIXELS_TO_TOP - texture.get_height()/2
		liquid.position.y = first_y + y_gap * i
		liquid.get_node("area").rect_size.y = texture.get_height() - y_gap * i - bottom

func _on_surface_button_down(node_pressed):
	dragging = true
	surface_node_being_dragged = node_pressed
	drag_start_height = node_pressed.get_node("area").rect_size.y
	set_physics_process(true)

func _on_surface_button_up():
	dragging = false
	surface_node_being_dragged = null
	set_physics_process(false)
	
	

func surface_can_move(surface_node_being_dragged, offset):
	var dragged_index = surfaces_array.find(surface_node_being_dragged)
#	print(surface_node_being_dragged)
	
	var surface_above = null
	var surface_under = null
	
	if dragged_index > -1: # found
		if dragged_index >= 1: # second from top
			surface_above = surfaces_array[dragged_index-1]
			
		if dragged_index < surfaces_array.size()-1: # last
			surface_under = surfaces_array[dragged_index+1]
		else:
			surface_under = $bottom
	
	#printt("above", surface_above.name, "under", surface_under.name)
	return true

func get_surface(id):
	return surfaces_array[id]

func set_bubbles_emitting(active):
	if has_node("Particles2D"):
		$Particles2D.emitting = active

func get_bubbles_emitting():
	if $Particles2D != null:
		return $Particles2D.emitting

