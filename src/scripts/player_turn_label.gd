extends Label

@export var level : Node3D

func _ready():
	level.connect("turn_change", update_text)
	modulate = Color("LIGHT_SEA_GREEN")

func update_text():
	var player_num : int = 0
	if level.curr_turn == level.TURN.ONE:
		player_num = 1
		modulate = Color("LIGHT_SEA_GREEN")
	else:
		player_num = 2
		modulate = Color("CRIMSON")
	text = "Player %d's Turn" % player_num 
