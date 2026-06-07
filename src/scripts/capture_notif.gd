extends Label
@export var level : Node3D

@export var fade_time : float = 0.3
@export var view_time : float = 1.0
# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = Color(1,1,1,0)
	level.connect("capture", reveal)

func reveal():
	level.announcer.capture()
	var tween : Tween = create_tween()
	tween.tween_property(self,"modulate", Color(1,1,1,1), fade_time)
	tween.play()
	await tween.finished
	await get_tree().create_timer(view_time).timeout
	tween = create_tween()
	tween.tween_property(self,"modulate", Color(1,1,1,0),fade_time)
