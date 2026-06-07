extends AnimatableBody3D
@export var level : Node3D
var can_slam : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if can_slam:
		rotate(-Vector3(1,0,0), PI*delta*10.)
