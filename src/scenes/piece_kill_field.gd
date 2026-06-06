extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", kill_piece)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func kill_piece(body: Node3D):
	if body is RigidBody3D:
		body.call_deferred("queue_free")
