extends Node2D

# Number of points in the fish (like segments in the body)
@export var points: int = 5
# Distance between the points (length of each segment)
@export var segment_length: float = 50.0

# Arrays to store the segments and joints
var segments = []
var joints = []

# Mouse position to control the head of the fish
var mouse_position: Vector2

func _ready():
	# Initialize the fish segments
	for i in range(points):
		# Create a new node for each segment
		var segment = Node2D.new()
		segment.position = Vector2(i * segment_length, 0)
		add_child(segment)
		segments.append(segment)
		
		# Optionally, create a visual representation for each segment (e.g., a circle or sprite)
		var joint = CircleShape2D.new()
		joint.radius = 5.0
		var collision_shape = CollisionShape2D.new()
		collision_shape.shape = joint
		segment.add_child(collision_shape)
		joints.append(collision_shape)

	# Set the initial mouse position to the position of the head
	mouse_position = segments[0].position

	# Connect input events for mouse movement
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _input(event: InputEvent):
	# Update the mouse position on mouse movement
	if event is InputEventMouseMotion:
		mouse_position = event.position

func _process(delta):
	# Move the head towards the mouse position
	segments[0].position = mouse_position

	# Move each segment towards its predecessor
	for i in range(1, points):
		var current_segment = segments[i]
		var previous_segment = segments[i - 1]

		# Calculate the direction and move the segment towards the previous one
		var direction = (previous_segment.position - current_segment.position).normalized()
		current_segment.position = previous_segment.position - direction * segment_length

		# Optionally smooth out the movement for a more fluid fish-like motion
		current_segment.position = current_segment.position.lerp(previous_segment.position - direction * segment_length, 0.5)
