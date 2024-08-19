extends Node2D

# Number of points in the fish (like segments in the body)
@export var points: int = 5
# Distance between the points (length of each segment)
@export var segment_length: float = 50.0
# Amplitude of the sine wave (controls how much the fish wiggles)
@export var wave_amplitude: float = 10.0
# Frequency of the sine wave (controls the speed of the wiggle)
@export var wave_frequency: float = 2.0

# Arrays to store the segments
var segments = []

# Mouse position to control the head of the fish
var mouse_position: Vector2

# Time variable to drive the sine wave
var time: float = 0.0


func _ready():
	# Initialize the fish segments
	for i in range(points):
		# Create a new node for each segment
		var segment = Node2D.new()
		segment.position = Vector2(i * segment_length, 0)
		add_child(segment)
		segments.append(segment)
		
		# Optionally, create a visual representation for each segment (e.g., a circle or sprite)
		var joint = preload("res://scenes/expendable/attachment.tscn").instantiate()
		#joint.texture = preload("res://assets/export/circle.png")
		segment.add_child(joint)

	# Set the initial position of the head to the center of the screen
	segments[0].position = Vector2(0, 0)


func _input(event: InputEvent):
	# Update the mouse position on mouse movement
	if event is InputEventMouseMotion:
		mouse_position = event.position
		
		
func _process(delta):
	# Move the head towards the mouse position
	segments[0].position = lerp(segments[0].position , -get_parent().position , delta)
	# Update the time variable
	time += delta

	# Move the head in a straight line, applying the sine wave to the y-axis
	segments[0].position.x += segment_length * delta * wave_frequency
	segments[0].position.y = sin(time * wave_frequency) * wave_amplitude

	# Move each segment towards its predecessor with sine wave motion
	for i in range(1, points):
		var current_segment = segments[i]
		var previous_segment = segments[i - 1]

		# Calculate the direction and move the segment towards the previous one
		var direction = (previous_segment.position - current_segment.position).normalized()
		var target_position = previous_segment.position - direction * segment_length

		# Apply a sine wave to the y-axis to create the wavy movement
		var offset = sin(time * wave_frequency - i * 0.5) * wave_amplitude
		#target_position.y += offset

		# Smoothly move the current segment to the target position
		current_segment.position = current_segment.position.lerp(target_position, 0.5)
