extends CharacterBody2D


# camera variables


var zoomSpeed: float = 0.0025
var zoomMin: float = 0.001
var zoomMax: float = 5.0
var dragSensitivity: float = 1.0

# Declare member variables here. For example, speed of the character.
@export var move_speed: float = 200.0
@onready var marker = $Node/Marker

# Variable to store the target position
var target_position: Vector2

# Variable to check if the character is moving
var is_moving: bool = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	# Initialize target position as the current position of the character
	target_position = marker.position

func _input(event: InputEvent ) -> void:
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			$Camera2D.zoom += Vector2(zoomSpeed, zoomSpeed)
			move_speed = 200.0
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if $Camera2D.zoom != Vector2.ZERO:
				$Camera2D.zoom -= Vector2(zoomSpeed, zoomSpeed)
			move_speed += 20
		$Camera2D.zoom = clamp($Camera2D.zoom, Vector2(zoomMin, zoomMin), Vector2(zoomMax, zoomMax))

	# Check if the left mouse button was clicked
	if event is InputEventMouseMotion:
		# Get the position of the mouse click
		target_position = marker.position 
		is_moving = true
		
	if Input.is_action_just_pressed("attack"):
		target_position = marker.position 
		is_moving = true

func _physics_process(delta: float) -> void:
	# Tank's launcher looks in mouse pointer direction
	aim_bot(delta)
		
	var input_dir = Input.get_vector("down" , "up" , "left" , "right" )
	var move_rot = Vector2()
	if input_dir:
		move_rot = input_dir.rotated(rotation) 
		velocity = move_rot * move_speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO , move_speed * delta)
	move_and_slide()
	
	if is_moving:
		# Calculate the direction vector to the target position
		var direction = (target_position - global_position).normalized()
		# Move the character towards the target position
		velocity = direction * move_speed
		# Move and slide the character with the calculated velocity
		move_and_slide()
		
		# Check if the character has reached the target position
		if global_position.distance_to(target_position) < move_speed * delta:
			# Stop the movement
			velocity = Vector2.ZERO
			is_moving = false

func aim_bot(delta):
	marker.top_level = true
	marker.position = get_global_mouse_position()
	look_at(marker.position)
