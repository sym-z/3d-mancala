extends Label

@export var level : Node3D
@export var transparancy : float = 0.67

func _ready():
	level.connect("turn_change", update_text)
	modulate = Color("LIGHT_SEA_GREEN")
	modulate = Color(modulate.r,modulate.g,modulate.b, transparancy)

func update_text():
	var player_num : int = 0
	if level.curr_turn == level.TURN.ONE:
		player_num = 1
		modulate = Color("LIGHT_SEA_GREEN")
		modulate = Color(modulate.r,modulate.g,modulate.b, transparancy)
	else:
		player_num = 2
		modulate = Color("CRIMSON")
		modulate = Color(modulate.r,modulate.g,modulate.b, transparancy)
	text = "Player %d's Turn" % player_num 
