extends Sprite3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var time : float = 0.0
var speed : float = 2.
func _process(delta):
	time += delta
	var factor : float = (sin(time*speed)/6)+0.7
	modulate.v = factor


	pass
