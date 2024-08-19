extends RigidBody2D

var simulationSpeed: float = 1.0

var min_size : int = 650#1000
var max_size : int = 1200#25000
var size: Vector2 = Vector2(0,0)#(25000, 25000)
var foodSpawnTime: float = .001
var foodAmount: int = 500
var initialFood: int = 10
var maxFood: int = 20#2000

var initialPrey: int = 7
var maxPrey: int = 10

var initialPredators: int = 25
var maxPredators: int = 50
