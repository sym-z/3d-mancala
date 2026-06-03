extends Control

@export var play_btn : Button
@export var announcer : AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
@export var appear_time : float = 2.0
@export var fade_time : float = 2.0
@export var model : MeshInstance3D
func _ready():
	modulate = Color(0,0,0,0)
	play_btn.connect("pressed", to_game)
	announcer.title()
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self,"modulate", Color(1,1,1,1), appear_time)
	tween.play()
	await tween.finished
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func to_game():
	model.visible = false
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self,"modulate", Color(0,0,0,1), fade_time)
	tween.play()
	await tween.finished
	SceneTransition.game()
