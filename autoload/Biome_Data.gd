extends RigidBody2D

var simulationSpeed: float = 4.0

var min_size = 650#1000
var max_size = 1200#25000
var size: Vector2 = Vector2(0,0)#(25000, 25000)
var foodSpawnTime: float = .001
var foodAmount: int = 500
var initialFood: int = 100
var maxFood: int = 500#2000

var initialPrey: int = 400
var maxPrey: int = 1000

var initialPredators: int = 25
var maxPredators: int = 500
