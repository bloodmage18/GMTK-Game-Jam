extends Node2D

const BIOME = preload("res://scenes/test/biome.tscn")
@onready var biome : Node = null
var tile_size : int = 32  # size of a tile in the TileMap
var num_rooms : int = 50  # number of rooms to generate
var min_size : int = BiomeData.min_size / 2#4  # minimum room size (in tiles)
var max_size : int = BiomeData.max_size / 2#10  # maximum room size (in tiles)

var hspread : int = 400  # horizontal spread

func _ready() -> void:
	randomize()
	make_rooms()
	
func _input(_event : InputEvent) -> void:
	if _event.is_action_pressed('ui_select'):
		for n in $Biome.get_children():   
			n.queue_free()
		make_rooms()
	
func make_rooms() -> void:
	for i in range(num_rooms):
		var pos := Vector2(randf_range(-hspread/2, hspread/2), randf_range(-1000, hspread))
		biome = BIOME.instantiate()
		var w : int = min_size + randi() % (max_size - min_size)
		var h : int = min_size + randi() % (max_size - min_size)
		biome.make_room(pos, Vector2(w, h) * tile_size)
		#r.make_room(pos, BiomeData.size)
		$Biome.add_child(biome)
		

func _process(_delta : float) -> void:
	pass
