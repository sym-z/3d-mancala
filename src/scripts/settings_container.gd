extends MarginContainer

@export var active_setting : CheckBox
@export var speed_setting : HSlider
@export var back_btn : Button
const DEFAULT_SPEED : float = 0.3
# Called when the node enters the scene tree for the first time.
func _ready():
	active_setting.connect("toggled", adjust_active)
	back_btn.connect("pressed", close)
	speed_setting.connect("value_changed", adjust_speed)
	# Glitch in engine! 
	speed_setting.value = 0
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func adjust_speed(value : float):
	Globals.game_speed = DEFAULT_SPEED - value
	pass
	
func adjust_active(toggled_on : bool):
	Globals.follow_camera = toggled_on
	pass
	
func open():
	visible = true
func close():
	visible = false
