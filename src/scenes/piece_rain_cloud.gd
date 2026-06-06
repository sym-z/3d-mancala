extends Area3D

@export var x : float = 10.
@export var y : float = 10.
@export var z : float = 10.

@export var col_shape : CollisionShape3D

@export var spawn_timer : Timer 
@export var spawn_tick : float = 0.1

var piece_scn : PackedScene = preload("uid://dx40hiqxmxc4x")

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_timer.connect("timeout", spawn_piece_random)
	spawn_timer.wait_time = spawn_tick
	spawn_timer.start()


func get_random_point_3d() -> Vector3:
	# Origin of shape is midpoint
	var rand_x : float = randf_range(-0.5*x,0.5*x)
	var rand_y : float = randf_range(-0.5*y,0.5*y)
	var rand_z : float = randf_range(-0.5*z,0.5*z)
	
	return Vector3(rand_x,rand_y,rand_z)

func get_random_point_area() -> Vector3:
	var box_shape : Shape3D = col_shape.get_shape()
	var box_vec : Vector3 = box_shape.size
	# Origin of shape is midpoint
	var rand_x : float = randf_range(-0.5*box_vec.x,0.5*box_vec.x)
	var rand_y : float = randf_range(-0.5*box_vec.y,0.5*box_vec.y)
	var rand_z : float = randf_range(-0.5*box_vec.z,0.5*box_vec.z)
	
	return Vector3(rand_x,rand_y,rand_z)


func spawn_piece_random():
	var piece_inst : RigidBody3D = piece_scn.instantiate()
	self.add_child(piece_inst)
	piece_inst.mute_audio = true
	piece_inst.scale*=2
	piece_inst.global_position = global_position + get_random_point_area()
