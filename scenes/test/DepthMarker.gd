extends Marker2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = str(position.y , " ft")
