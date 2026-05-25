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
var selected_bank : int = 0


const STARTING_AMT : int = 4
var piece_scn : PackedScene = preload("uid://dx40hiqxmxc4x")
func _ready():
	arrow_pointer.global_position = p1_marker_banks[selected_bank].global_position
	board_setup()

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


#region Input Handling
func _input(event):
	if event.is_action_pressed("ui_left"):
		move_left()
	if event.is_action_pressed("ui_right"):
		move_right()

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
