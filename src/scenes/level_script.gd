extends Node3D
#region Exports, Variables, Signals
@export_category("Markers")
@export_subgroup("Banks")
@export var p1_marker_banks : Array[Marker3D]
@export var p2_marker_banks : Array[Marker3D]
@export_subgroup("Home")
@export var p1_marker_home : Marker3D
@export var p2_marker_home : Marker3D

@export_category("UI")
@export var arrow_pointer : Sprite3D

@export_category("Audio")
@export var announcer : AudioStreamPlayer

@export_category("Cameras")
@export var p1_cam : Camera3D 
@export var p2_cam : Camera3D

enum TURN {ONE=1,TWO=2}
var curr_turn : TURN = TURN.ONE

const STARTING_AMT : int = 4
const NUM_BANKS : int = 6
const TOTAL_BANKS : int = 13

var selected_bank : int = 0

var piece_scn : PackedScene = preload("uid://dx40hiqxmxc4x")

var allow_input : bool = false
var game_ready : bool = false
var p1_win : bool = false
var p2_win : bool = false

signal turn_change
signal extra_turn
signal capture
signal game_over(p1_win : bool, p2_win : bool)

@export_category("Game Modifiers")
@export var spread_delay : float = 0.3
#endregion
func _ready():
	arrow_pointer.global_position = p1_marker_banks[selected_bank].global_position
	arrow_pointer.visible = false
	await board_setup()
	arrow_pointer.visible = true
	arrow_pointer.modulate = Color("LIGHT_SEA_GREEN")
	game_ready = true
	allow_input = true
#region Game Setup
func board_setup():
	# Fill each players side with STARTING_AMT pieces.
	fill_bank(p1_marker_banks)
	await fill_bank(p2_marker_banks)
	
func fill_bank(bank_arr : Array[Marker3D]):
	for bank in bank_arr:
		for i in range(STARTING_AMT):
			var piece_inst : RigidBody3D = piece_scn.instantiate()
			bank.add_child(piece_inst)
			piece_inst.global_position = Vector3(bank.global_position.x,bank.global_position.y, bank.global_position.z + randf_range(-piece_inst.pos_variation_magnitude, piece_inst.pos_variation_magnitude))
			await get_tree().create_timer(spread_delay/2).timeout
#endregion
#region Input Handling
func _input(event):
	if game_ready and allow_input and p1_win == false and p2_win == false:
		if event.is_action_pressed("ui_left"):
			move_left()
		if event.is_action_pressed("ui_right"):
			move_right()
		if event.is_action_pressed("ui_select"):
			arrow_pointer.visible = false
			allow_input = false
			await choose_bank()
			arrow_pointer.visible = true
	
	if event.is_action_pressed("slam"):
		if p1_win or p2_win:
			slam()

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
	if curr_turn == TURN.ONE:
		arrow_pointer.global_position = p1_marker_banks[bank_num].global_position
	else:
		arrow_pointer.global_position = p2_marker_banks[bank_num].global_position

func slam():
	var force = 10.
	for piece in p1_marker_home.get_children():
		piece.apply_impulse(Vector3(randf_range(0.0,1.0),randf_range(0.0,1.0),randf_range(0.0,1.0)) * force)
	for piece in p2_marker_home.get_children():
		piece.apply_impulse(Vector3(randf_range(0.0,1.0),randf_range(0.0,1.0),randf_range(0.0,1.0)) * force)

#endregion
#region Game State Modification
func swap_turn():
	await get_tree().create_timer(spread_delay * 2).timeout
	#TODO: CHECK GAME STATE END
	await check_endgame()
	if curr_turn == TURN.ONE:
		curr_turn = TURN.TWO
		p1_cam.current = false
		p2_cam.current = true
		arrow_pointer.modulate = Color("CRIMSON")
	else:
		curr_turn = TURN.ONE
		p1_cam.current = true
		p2_cam.current = false
		arrow_pointer.modulate = Color("LIGHT_SEA_GREEN")

	# Change arrow to be new selection
	set_selection(0)
	# Change back end to select new bank
	selected_bank = 0
	allow_input = true
	turn_change.emit()
	
func check_endgame():
	var p1_pieces : int = get_p1_total_pieces()
	var p2_pieces : int = get_p2_total_pieces()
	if p1_pieces == 0 or p2_pieces == 0:
		arrow_pointer.visible = false
		allow_input = false
		game_ready = false
		# Transfer all pieces from the other side to the correct home
		if p1_pieces != 0:
			await move_to_home(p1_marker_banks, p1_marker_home)
		else:
			await move_to_home(p2_marker_banks, p2_marker_home)
		# Identify who has more pieces in home
		check_winner()
		game_over.emit(p1_win, p2_win)
		# End Game
		#TODO: Win behavior

func get_p1_total_pieces() -> int:
	var total : int = 0
	for bank in p1_marker_banks:
		for piece in bank.get_children():
			total += 1
	return total

func get_p2_total_pieces() -> int:
	var total : int = 0
	for bank in p2_marker_banks:
		for piece in bank.get_children():
			total += 1
	return total

func move_to_home(banks : Array[Marker3D], home : Marker3D):
	for bank in banks:
		for piece in bank.get_children():
			piece.call_deferred("queue_free")
			place_piece(home)
			bank.bank_updated.emit()
			await get_tree().create_timer(spread_delay).timeout
		bank.set_manual.emit(0)

func check_winner():
	if p1_marker_home.get_child_count() == p2_marker_home.get_child_count():
		p1_win = true
		p2_win = true
		announcer.tie()
	elif p1_marker_home.get_child_count() > p2_marker_home.get_child_count():
		p1_win = true
		p2_win = false
		announcer.p1_win()
	else:
		p1_win = false
		p2_win = true
		announcer.p2_win()
#endregion
#region Bank Choice
func choose_bank():
	allow_input = false
	var parent : Marker3D
	# Identify the current turn
	if curr_turn == TURN.ONE:
		# Identify correct parent
		parent = p1_marker_banks[selected_bank]
	else:
		parent = p2_marker_banks[selected_bank]
	# Identify number of pieces in selected bank
	var piece_amt : int = parent.get_child_count()
	
	if piece_amt > 0:
		# Delete all children
		for piece in parent.get_children():
			piece.queue_free()
		parent.set_manual.emit(0)
		# Iterate through, placing one piece per hop, remembering to place one piece in the current player's bank
		# Keep track of final bank
		var final_bank_num : int = -1
		# Player one's Turn
		if curr_turn == TURN.ONE:
			for i in range(1,piece_amt+1):
				var global_bank = (selected_bank + i) % TOTAL_BANKS
				if global_bank == NUM_BANKS:
					place_piece(p1_marker_home)
				elif global_bank > NUM_BANKS:
					place_piece(p2_marker_banks[(global_bank % NUM_BANKS)-1])
				else:
					place_piece(p1_marker_banks[global_bank])
				final_bank_num = global_bank
				await get_tree().create_timer(spread_delay).timeout
		# Player 2's Turn
		else:
			for i in range(1,piece_amt+1):
				var global_bank = (selected_bank + i) % TOTAL_BANKS
				if global_bank == NUM_BANKS:
					place_piece(p2_marker_home)
				elif global_bank > NUM_BANKS:
					place_piece(p1_marker_banks[(global_bank % NUM_BANKS)-1])
				else:
					place_piece(p2_marker_banks[global_bank])
				final_bank_num = global_bank
				await get_tree().create_timer(spread_delay).timeout
		
		# Landed in own Home
		if final_bank_num == NUM_BANKS:
			await check_endgame()
			if p1_win == false and p2_win == false:
				extra_turn.emit()
				allow_input = true
			
			
		# Landed on own side
		# You can only capture if you land on "your" side and that is the only piece in there now
		elif final_bank_num < NUM_BANKS:
			if curr_turn == TURN.ONE and p1_marker_banks[final_bank_num].get_child_count() == 1:
				await capture_check(p1_marker_banks[final_bank_num], final_bank_num)
			elif curr_turn == TURN.TWO and p2_marker_banks[final_bank_num].get_child_count() == 1:
				await capture_check(p2_marker_banks[final_bank_num], final_bank_num)
			await swap_turn()
		# Landed in other player's side
		else:
			await swap_turn()
	else:
		print("NO PIECES IN SELECTED BANK")
		allow_input = true

# Similarly to fill banks, used when iterating through banks after choice.
func place_piece(bank: Marker3D):
	var piece_inst : RigidBody3D = piece_scn.instantiate()
	bank.add_child(piece_inst)
	piece_inst.global_position = Vector3(bank.global_position.x,bank.global_position.y, bank.global_position.z + randf_range(-piece_inst.pos_variation_magnitude, piece_inst.pos_variation_magnitude))
	bank.bank_updated.emit()

func capture_check(bank : Marker3D, index : int):
	# Since function was called with await, these internal awaits for the placement will carry out before the function returns to caller
	var opposite_bank : Marker3D
	if curr_turn == TURN.ONE:
		opposite_bank = p2_marker_banks[5-index]
	else:
		opposite_bank = p1_marker_banks[5-index]
	# Transfer pieces
	if opposite_bank.get_child_count() != 0:
		capture.emit()
		for piece in opposite_bank.get_children():
			piece.call_deferred("queue_free")
			opposite_bank.bank_updated.emit()
			if curr_turn == TURN.ONE:
				place_piece(p1_marker_home)
			else:
				place_piece(p2_marker_home)
			await get_tree().create_timer(spread_delay/2).timeout
		opposite_bank.set_manual.emit(0)
		# Place remaining piece
		var last_piece = bank.get_child(0)
		last_piece.call_deferred("queue_free")
		if curr_turn == TURN.ONE:
			place_piece(p1_marker_home)
		else:
			place_piece(p2_marker_home)
		bank.set_manual.emit(0)
		await get_tree().create_timer(spread_delay/2).timeout
#endregion
