extends AnimatableBody3D
var speed : float = 1.
var mouse_pos : Vector2 
var screen_center : Vector2
@export var center_marker : Marker2D

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_center = center_marker.global_position


func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = event.position
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	print(screen_center)
	#print(mouse_pos.distance_to(screen_center)*0.05)
	speed = 1. + mouse_pos.distance_to(screen_center)*0.005
	rotate(Vector3(0,1,0), speed*delta)
