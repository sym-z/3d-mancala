extends Label

@export var level : Node3D
@export var view_duration : float = 3.0
@export var fade_time : float = 0.3
@export var post_game_messages : CenterContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = Color(1,1,1,0)
	level.connect("game_over", reveal)

func reveal(p1_win : bool, p2_win : bool):
	if p1_win and p2_win:
		text = "GAME TIE!"
		level.announcer.tie()
	elif p1_win:
		text = "PLAYER ONE WINS!"
		level.announcer.p1_win()
	else:
		text = "PLAYER TWO WINS!"
		level.announcer.p2_win()
	var tween : Tween = create_tween()
	tween.tween_property(self,"modulate", Color(1,1,1,1), fade_time)
	tween.play()
	await tween.finished
	await get_tree().create_timer(view_duration).timeout
	tween = create_tween()
	tween.tween_property(self,"modulate", Color(1,1,1,0),fade_time)
	post_game_messages.reveal()
	
