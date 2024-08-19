class_name Prey
extends CharacterBody2D

var speed = 400
var turnStrength = .035
var visionCone = 180
var dirTolerance: float = 20

var maxHunger: int = 4000
var hunger: int = maxHunger / 2

# Wander
var desiredDir: Vector2 = Vector2(randf_range(-1,1), randf_range(-1,1))
var wanderDirChangeTime: float = 3

enum STATE {
	WANDER,
	FORAGE,
	FLEE
}
var state: STATE = STATE.WANDER

var check = false

func _ready():
	$WanderTimer.wait_time = wanderDirChangeTime
	rotation_degrees = randf_range(-180, 180)

func _physics_process(delta):
	hunger -= 1 * BiomeData.simulationSpeed
	if hunger < 0:
		queue_free()
	
	keepInBounds()
	
	match state:
		STATE.WANDER:
			$WanderTimer.start()
			var angleToDesiredDir = rad_to_deg(desiredDir.angle())
			
			var leftBoundary = angleToDesiredDir - dirTolerance / 2
			var rightBoundary = angleToDesiredDir + dirTolerance / 2
			
			if (rotation_degrees > leftBoundary and rotation_degrees < rightBoundary):
				pass
			else:
				if rotation_degrees < leftBoundary:
					rotate(turnStrength)
				if rotation_degrees > rightBoundary:	
					rotate(-turnStrength)
		
		STATE.FORAGE:
			$WanderTimer.stop()
			
			var nearestFood = null
			
			var foods = $SightArea.get_overlapping_bodies()
			for food in foods:
				if food == self:
					continue
				if food.is_in_group('prey'):
					continue
				if food.is_in_group('predator'):
					state = STATE.FLEE
					return
				if nearestFood == null or position.distance_to(food.position) < position.distance_to(nearestFood.position):
					nearestFood = food
			
			if nearestFood == null:
				state = STATE.WANDER
				return
			
			var fp = nearestFood.position
			var p = position
			var foodDir = (nearestFood.position - position).normalized()
			
			var angleToFood = rad_to_deg(foodDir.angle())
			var leftBoundary = angleToFood - dirTolerance / 2
			var rightBoundary = angleToFood + dirTolerance / 2
			
			if (rotation_degrees > leftBoundary and rotation_degrees < rightBoundary):
				pass
			else:
				if rotation_degrees < leftBoundary:
					rotate(turnStrength * BiomeData.simulationSpeed)
				if rotation_degrees > rightBoundary:	
					rotate(-turnStrength * BiomeData.simulationSpeed)
		
		STATE.FLEE:
			$WanderTimer.stop()
			
			var nearestPred = null
			
			var bodies = $SightArea.get_overlapping_bodies()
			for body in bodies:
				if body == self:
					continue
				if body.is_in_group('prey') or body.is_in_group('food'):
					continue
				if nearestPred == null or position.distance_to(body.position) < position.distance_to(nearestPred.position):
					nearestPred = body
			
			if nearestPred == null:
				state = STATE.WANDER
				return
			
			var fp = nearestPred.position
			var p = position
			var predDir = (nearestPred.position - position).normalized()
			
			var angleToPred = rad_to_deg(predDir.angle())
			var angleFromPred = angleToPred
			if angleToPred < 0:
				angleFromPred = angleToPred + 180
			else:
				angleFromPred = angleToPred - 180
			var leftBoundary = angleFromPred - dirTolerance / 2
			var rightBoundary = angleFromPred + dirTolerance / 2
			
			if (rotation_degrees > leftBoundary and rotation_degrees < rightBoundary):
				pass
			else:
				if rotation_degrees < leftBoundary:
					rotate(turnStrength * BiomeData.simulationSpeed)
				if rotation_degrees > rightBoundary:	
					rotate(-turnStrength * BiomeData.simulationSpeed)

	velocity = Vector2(1,0).rotated(rotation) * (speed * BiomeData.simulationSpeed)
	move_and_slide()

func keepInBounds():
	var biome = get_biome()
	if position.x < 0:
		position = Vector2(biome.x, position.y)
	if position.x > biome.x:
		position = Vector2(0, position.y)
	if position.y < 0:
		position = Vector2(position.x, biome.y)
	if position.y > biome.x:
		position = Vector2(position.x, 0)
		
func get_biome():
	var parent = get_parent().get_parent().get_parent()
	return parent.final_size

func _on_wander_timer_timeout():
	desiredDir = Vector2(randf_range(-1,1), randf_range(-1,1))

func _on_sight_area_body_entered(body):
	if body.is_in_group('predator'):
		state = STATE.FLEE
	
	if body.is_in_group('food'):
		if state == STATE.WANDER:
			state = STATE.FORAGE

func eat(food):
	food.queue_free()
	hunger += BiomeData.foodAmount
	if hunger >= maxHunger:
		hunger = maxHunger / 2
		split()

var preyNode = preload("res://scenes/test/prey.tscn")
func split():
	
	var preyInstance = preyNode.instantiate()
	preyInstance.position = position
	get_parent().add_child(preyInstance)
	scale += scale


func _on_eat_area_body_entered(body):
	eat(body)
	pass # Replace with function body.
