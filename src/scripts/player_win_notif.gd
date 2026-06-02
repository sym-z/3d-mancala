extends Label

@export var level : Node3D
@export var view_duration : float = 3.0
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	level.connect("game_over", reveal)

func reveal(p1_win : bool, p2_win : bool):
	if p1_win and p2_win:
		text = "GAME TIE!"
	elif p1_win:
		text = "PLAYER ONE WINS!"
	else:
		text = "PLAYER TWO WINS!"
	visible = true
	await get_tree().create_timer(view_duration).timeout
	visible = false
	await get_tree().create_timer(10.0).timeout
	SceneTransition.main_menu()
