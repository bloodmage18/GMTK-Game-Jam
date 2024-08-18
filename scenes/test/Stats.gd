class_name Gene_Data extends StateMachine

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
	"SIZ": size,
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

func _ready():
	add_state('CELL')
	add_state('PUP')
	add_state('KIN')
	add_state('MATURE')
	add_state('FALLEN')
	add_state('CALAMITY')
	add_state('ELDIRITCH')
	call_deferred("set_state" , states.CELL)
	
	

func state_logic(delta):
	pass

func get_transition(delta):
	
	match state:
		states.CELL:
			pass
		states.PUP:
			pass
		states.KIN:
			pass
		states.MATURE:
			pass
		states.FALLEN:
			pass
		states.CALAMITY:
			pass
		states.ELDIRITCH:
			pass
	
	return null

func enter_state(new_state, old_state):
	match state:
		states.CELL:
			pass
		states.PUP:
			pass
		states.KIN:
			pass
		states.MATURE:
			pass
		states.FALLEN:
			pass
		states.CALAMITY:
			pass
		states.ELDIRITCH:
			pass
	

func exit_state(old_state, new_state):
	match state:
		states.CELL:
			pass
		states.PUP:
			pass
		states.KIN:
			pass
		states.MATURE:
			pass
		states.FALLEN:
			pass
		states.CALAMITY:
			pass
		states.ELDIRITCH:
			pass
	

func evolve():
	
	pass
	
func set_evolution_conditon():
	# set condition needed to evolve (stats required to evolve)
	pass
