extends Button

@export var window : MarginContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", hide_window)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hide_window():
	visible = false
