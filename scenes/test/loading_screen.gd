extends CanvasLayer

@export_file("*.tscn") var next_scene_path: String #Determines which scene file to load

func _ready():
	$AnimationPlayer.play("load_in")
	await  get_tree().create_timer(0.5).timeout
	#$AnimationPlayer.play("loading")
	ResourceLoader.load_threaded_request(next_scene_path)

func _process(_delta):
	
	var b = 0
	var loader =  ResourceLoader.load_threaded_get_status(next_scene_path)
	if loader == 3:#ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)
		await get_tree().create_timer(3).timeout
		var new_scene: PackedScene = ResourceLoader.load_threaded_get(next_scene_path)
		get_tree().change_scene_to_packed(new_scene)
	elif loader == 2 : #THREAD_LOAD_FAILED
		# handle your error
		print("error occured while loading chuncks of data")
		return
	elif loader == 1 : #THREAD_LOAD_IN_PROGRESS
#		await get_tree().create_timer(1).timeout
		pass
		
	elif loader == 0 : #THREAD_LOAD_INVALID_RESOURCE
		# handle your error
#		print("error occured while getting the scene")
#		print("The resource is invalid, or has not been loaded with load_threaded_request().")
		return
	else:
		print("unknown error")
