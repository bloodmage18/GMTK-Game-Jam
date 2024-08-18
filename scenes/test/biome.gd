extends BiomeData
class_name Biome

var final_size

func make_room(_pos, _size):
	self.position = _pos
	size = _size
	var s = RectangleShape2D.new() 
	s.extents = size / 2
	s.custom_solver_bias = 0.75
	$CollisionShape2D.shape = s
	$Attribute_Region/CollisionShape2D.shape = s
	$ColorRect.position = Vector2(-(size.x * 129 )/ 2 , -(size.y * 129) / 2) #* 128
	$ColorRect.size = size * 125
	$CollisionShape2D.shape.size = size * 128
	final_size = _size * 125
	
	
	

func _ready():
	#make_room(self.position , size)
	await get_tree().create_timer(1).timeout
	#$ColorRect.position = 
	
	
	biome_setter()


var foodNode = preload("res://scenes/test/seed.tscn")
func spawnFood(location: Vector2):
	if $Food.get_child_count() < maxFood:
		var foodInstance = foodNode.instantiate()
		foodInstance.position = location
		$Food.add_child(foodInstance)
		
func biome_setter():
	
	$Food_timer.wait_time = foodSpawnTime / simulationSpeed
	
	
	$BiomeInfo/FoodLabel/FoodSlider.max_value = maxFood
	
	for i in initialFood:
		spawnFood(final_size)
	

func _on_food_timer_timeout():
	spawnFood(Vector2(randf_range(-final_size.x / 2 , final_size.x /2) , randf_range(-final_size.y / 2, final_size.y /2)))

func _process(delta):
	#var preyCount = $Prey.get_child_count()
	#var predCount = $Predator.get_child_count()
	var foodCount = $Food.get_child_count()
	#$BiomeInfo/PredatorLabel.text = 'Predator: %s' % predCount
	#$BiomeInfo/PredatorLabel/PredatorSlider.value = predCount
	#$BiomeInfo/PreyLabel.text = 'Prey: %s' % preyCount
	#$BiomeInfo/PreyLabel/PreySlider.value = preyCount
	$BiomeInfo/FoodLabel.text = 'Food: %s' % foodCount
	$BiomeInfo/FoodLabel/FoodSlider.value = foodCount

func _on_attribute_region_body_entered(body):
	$Food_timer.start()
	$Food_timer.autostart = true
	pass # Replace with function body.


func _on_attribute_region_body_exited(body):
	$Food_timer.stop()
	$Food_timer.autostart = false
	pass # Replace with function body.
