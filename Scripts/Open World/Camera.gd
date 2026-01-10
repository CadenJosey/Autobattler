extends Camera2D

# Variables to store the dragging state
var dragging = false
var drag_start_position = Vector2()
var camera_start_position = Vector2()

# Called when the node is added to the scene
func _ready():
	# Enable the camera if it's not already enabled
	make_current()

# Called every frame. Delta is the elapsed time since the previous frame.
func _process(delta):
	# Check for mouse button input
	if Input.is_action_just_pressed("click"):
		dragging = true
		drag_start_position = get_global_mouse_position()
		camera_start_position = position

	elif Input.is_action_just_released("click"):
		dragging = false

	if dragging:
		# Calculate the new camera position based on the mouse movement
		var mouse_position = get_global_mouse_position()
		var offset = drag_start_position - mouse_position
		position = camera_start_position + offset
		
		# Clamp the camera position
		position = position.clamp(Vector2(0, 0), position)

# Input actions can be handled here
func _input(event):
	# Process the input event if needed
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				Input.action_press("click")
			else:
				Input.action_release("click")
