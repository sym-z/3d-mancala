extends Label

@export var level : Node3D
@export var view_duration : float = 3.0
@export var post_game_messages : CenterContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
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
	visible = true
	await get_tree().create_timer(view_duration).timeout
	visible = false
	post_game_messages.reveal()
	
