extends CharacterBody2D


@export_category('Stats Data')
@export var health :int = 0
@export var speed :int = 0
@export var size :int = 0
@export var strength :int = 0
@export var wieght :int = 0
@export var rank :int = 6
@export var constitution :int = 0
@export var dexterity :int = 0
@export var intelligence :int = 0
@export var power :int = 0

@onready var gene_data : Dictionary = {
	"STR": strength,
	"CON": constitution,
	"SIZE": size,
	"DEX": dexterity,
	"INT": intelligence,
	"HP": health,
	"POW":power,
	"RNK": rank, 
}
enum stages {
	cell,
	pup,
	kin,
	mature,
	fallen,
	abomination,
	calamity,
	eldiritch
}
var stage = stages.cell

# Declare member variables here. For example, speed of the character.
@export var move_speed: float = 200.0
@onready var marker = $Node/Marker

# Variable to store the target position
var target_position: Vector2

# Variable to check if the character is moving
var is_moving: bool = false

func _ready():
	print(gene_data)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	# Initialize target position as the current position of the character
	target_position = marker.position#get_global_mouse_position()#get_local_mouse_position()#global_position

func _input(event: InputEvent ) -> void:
	# Check if the left mouse button was clicked
	if Input.is_action_just_pressed("click"):
		# Get the position of the mouse click
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
