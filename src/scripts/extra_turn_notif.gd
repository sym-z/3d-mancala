extends Label
@export var level : Node3D
@export var view_time : float = 1.0

func _ready():
	visible = false
	level.connect("extra_turn", reveal)

func reveal():
	visible = true
	await get_tree().create_timer(view_time).timeout
	visible = false
