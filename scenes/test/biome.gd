extends BiomeData

var final_size

func make_room(_pos, _size):
	self.position = _pos
	size = _size
	var s = RectangleShape2D.new() 
	s.extents = size / 2
	s.custom_solver_bias = 0.75
	$CollisionShape2D.shape = s
	final_size = _size
	

func _ready():
	await get_tree().create_timer(1).timeout
	$ColorRect.position = Vector2(-size.x/2 , -(size.y/2))
	$ColorRect.size = size
	
	for i in initialFood:
		spawnFood(final_size)


var foodNode = preload("res://scenes/test/seed.tscn")
func spawnFood(location: Vector2):
	if $Food.get_child_count() < maxFood:
		var foodInstance = foodNode.instantiate()
		foodInstance.position = location
		$Food.add_child(foodInstance)


func _on_food_timer_timeout():
	spawnFood(Vector2(randf_range(0 , final_size.x) , randf_range(0, final_size.y)))
