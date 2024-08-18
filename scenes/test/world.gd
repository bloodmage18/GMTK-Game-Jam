extends Node2D

const BIOME = preload("res://scenes/test/biome.tscn")
@onready var b
var tile_size = 32  # size of a tile in the TileMap
var num_rooms = 50  # number of rooms to generate
var min_size = BiomeData.min_size / 2#4  # minimum room size (in tiles)
var max_size = BiomeData.max_size / 2#10  # maximum room size (in tiles)

var hspread = 400  # horizontal spread

func _ready():
	randomize()
	make_rooms()
	
func _input(event):
	if event.is_action_pressed('ui_select'):
		for n in $Biome.get_children():   
			n.queue_free()
		make_rooms()
	
func make_rooms():
	for i in range(num_rooms):
		var pos = Vector2(randf_range(-hspread/2, hspread/2), randf_range(-1000, hspread))
		var r = BIOME.instantiate()
		var w = min_size + randi() % (max_size - min_size)
		var h = min_size + randi() % (max_size - min_size)
		r.make_room(pos, Vector2(w, h) * tile_size)
		#r.make_room(pos, BiomeData.size)
		$Biome.add_child(r)
		

func _process(delta):
	pass
