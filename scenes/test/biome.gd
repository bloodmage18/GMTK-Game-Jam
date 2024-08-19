extends BiomeData
class_name Biome

var final_size : Vector2

@onready var color_rect = $Visual/Control/ColorRect
@onready var collision_shape_2d = $CollisionShape2D

# Entities
@onready var predetor = $Entities/Predetor
@onready var prey = $Entities/Prey
@onready var food = $Entities/Food

# Attribute_Zones
@onready var attribute_region = $Attribute/Attribute_Region
@onready var markers = $Attribute/markers
@onready var biome_info = $Attribute/BiomeInfo
@onready var food_timer = $Attribute/Food_timer
@onready var exit = $Attribute/Exit


func make_room(_pos : Vector2 , _size : Vector2) -> void:
	#self.position = _pos
	size = _size
	var s = RectangleShape2D.new() 
	s.extents = size / 2
	s.custom_solver_bias = 0.75
	$CollisionShape2D.shape = s
	$Attribute/Attribute_Region/CollisionShape2D.shape = s
	$Visual/Control/ColorRect.position = Vector2(-(size.x * 129 )/ 2 , -(size.y * 129) / 2) #* 128
	$Visual/Control/ColorRect.size = size * 128
	$CollisionShape2D.shape.size = size * 128
	final_size = _size * 125

func _ready() -> void:
	#make_room(self.position , size)
	await get_tree().create_timer(1).timeout
	$Visual/Control/ColorRect.position = Vector2(-(size.x * 129 )/ 2 , -(size.y * 129) / 2)
	biome_setter()


var foodNode : PackedScene = preload("res://scenes/test/food.tscn")
func spawnFood(location: Vector2) -> void:
	if food.get_child_count() < maxFood:
		var foodInstance = foodNode.instantiate()
		foodInstance.position = location
		food.add_child(foodInstance)
		
var preyNode = preload("res://scenes/test/prey.tscn")
func spawnPrey(location: Vector2):
	var newPrey = preyNode.instantiate()
	newPrey.position = location
	$Entities/Prey.add_child(newPrey)
	
#var predNode = preload("res://scenes/test/predator.tscn")
#func spawnPredator(location: Vector2):
	#var newPred = predNode.instantiate()
	#newPred.position = location
	#$Entities/Predetor.add_child(newPred)
		
func biome_setter() -> void:
	
	food_timer.wait_time = foodSpawnTime / simulationSpeed
	
	
	$Attribute/BiomeInfo/FoodLabel/FoodSlider.max_value = maxFood
	
	for i in initialFood:
		spawnFood(final_size)
		
	for i in initialPrey:
		spawnPrey(final_size)
	
	#for i in initialPredators:
		#spawnPredator(Vector2(randf_range(0, BiomeData.size.x), randf_range(0, BiomeData.size.y)))

	

func _on_food_timer_timeout():
	spawnFood(Vector2(randf_range(-final_size.x / 2 , final_size.x /2) , randf_range(-final_size.y / 2, final_size.y /2)))

func _process(delta):
	var preyCount = prey.get_child_count()
	var predCount = predetor.get_child_count()
	var foodCount = food.get_child_count()
	$Attribute/BiomeInfo/PredatorLabel.text = 'Predator: %s' % predCount
	$Attribute/BiomeInfo/PredatorLabel/PredatorSlider.value = predCount
	$Attribute/BiomeInfo/PreyLabel.text = 'Prey: %s' % preyCount
	$Attribute/BiomeInfo/PreyLabel/PreySlider.value = preyCount
	$Attribute/BiomeInfo/FoodLabel.text = 'Food: %s' % foodCount
	$Attribute/BiomeInfo/FoodLabel/FoodSlider.value = foodCount








func _on_attribute_region_body_entered(body):
	food_timer.start()
	food_timer.autostart = true
	pass # Replace with function body.

func _on_attribute_region_body_exited(body):
	food_timer.stop()
	food_timer.autostart = false
	pass # Replace with function body.
