extends Label

@export var level : Node3D
@export var view_duration : float = 3.0
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	level.connect("capture", reveal)

func reveal():
	visible = true
	level.announcer.capture()
	await get_tree().create_timer(view_duration).timeout
	visible = false
