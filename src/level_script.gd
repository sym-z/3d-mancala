extends Node3D

@export_category("Markers")
@export_subgroup("Banks")
@export var p1_marker_banks : Array[Marker3D]
@export var p2_marker_banks : Array[Marker3D]
@export_subgroup("Home")
@export var p1_marker_home : Marker3D
@export var p2_marker_home : Marker3D

@export_category("UI")
@export var arrow_pointer : Sprite3D

enum TURN {ONE,TWO}
var curr_turn : TURN = TURN.ONE
const NUM_BANKS : int = 6
const TOTAL_BANKS : int = 13
var selected_bank : int = 0


const STARTING_AMT : int = 4
var piece_scn : PackedScene = preload("uid://dx40hiqxmxc4x")
func _ready():
	arrow_pointer.global_position = p1_marker_banks[selected_bank].global_position
	board_setup()


#region Game Setup
func board_setup():
	# Fill each players side with STARTING_AMT pieces.
	fill_bank(p1_marker_banks)
	fill_bank(p2_marker_banks)
			
	pass
func fill_bank(bank_arr : Array[Marker3D]):
	for bank in bank_arr:
		for i in range(STARTING_AMT):
			var piece_inst : RigidBody3D = piece_scn.instantiate()
			bank.add_child(piece_inst)
			piece_inst.global_position = bank.global_position
	pass
#endregion

#region Input Handling
func _input(event):
	if event.is_action_pressed("ui_left"):
		move_left()
	if event.is_action_pressed("ui_right"):
		move_right()
	if event.is_action_pressed("ui_select"):
		choose_bank()

func move_left():
	#TODO: Check turn
		if selected_bank == 0:
			selected_bank = NUM_BANKS - 1
		else:
			selected_bank -= 1
		set_selection(selected_bank)

func move_right():
	#TODO: Check turn
		if selected_bank == NUM_BANKS-1:
			selected_bank = 0
		else:
			selected_bank += 1
		set_selection(selected_bank)

func set_selection(bank_num : int):
	arrow_pointer.global_position = p1_marker_banks[bank_num].global_position
#endregion

#region Bank Choice
func choose_bank():
	var parent : Marker3D
	# Identify the current turn
	if curr_turn == TURN.ONE:
		# Identify correct parent
		parent = p1_marker_banks[selected_bank]
	else:
		parent = p2_marker_banks[selected_bank]
	var piece_amt : int = parent.get_child_count()
	if piece_amt > 0:
		# Delete all children
		for piece in parent.get_children():
			piece.call_deferred("queue_free")
		# Iterate through, placing one piece per hop, remembering to place one piece in the current player's bank
		# Keep track of final bank
		var final_bank_num : int = -1
		#TODO ADD AWAIT TIMER
		if curr_turn == TURN.ONE:
			for i in range(1,piece_amt+1):
				var curr_bank = selected_bank + i
				if curr_bank == NUM_BANKS:
					#TESTED
					place_piece(p1_marker_home)
				# OVERFLOW BACK TO P1
				elif curr_bank > TOTAL_BANKS:
					print("OVERFLOW: " , curr_bank % TOTAL_BANKS)
				# OVERFLOW INTO P2
				elif curr_bank > NUM_BANKS:
					place_piece(p2_marker_banks[curr_bank % (NUM_BANKS+1)])
				else:
					#TESTED
					place_piece(p1_marker_banks[curr_bank])
				await get_tree().create_timer(0.5).timeout
				# For end turn logic
				final_bank_num = selected_bank + i
			print("SELECTED BANK: ", selected_bank)
			print("FINAL BANK: ", final_bank_num % (NUM_BANKS+1))
		pass
	else:
		print("NO PIECES IN SELECTED BANK")

# Similarly to fill banks, used when iterating through banks after choice.

func place_piece(bank: Marker3D):
	var piece_inst : RigidBody3D = piece_scn.instantiate()
	bank.add_child(piece_inst)
	piece_inst.global_position = bank.global_position
