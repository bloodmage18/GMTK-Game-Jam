extends Node

const main_menu = preload("res://main.tscn")
const load_screen = preload("res://scenes/test/loading_screen.tscn")
const main_game = "res://scenes/test/world.tscn"
#const game_controller 

var loading_screen : Node = null

func load_screen_to_scene(target: String) -> void:
	loading_screen = load_screen.instantiate()
	loading_screen.next_scene_path = target
	get_tree().current_scene.add_child(loading_screen)


func _start_Game() -> void:
	
	pass
