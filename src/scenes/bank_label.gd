extends Label3D

@export var bank_reference : Marker3D

@export var tween_speed : float = 0.5
func _ready():
	bank_reference.connect("bank_updated", refresh_label, CONNECT_DEFERRED)
	bank_reference.connect("set_manual", assign_label)
func refresh_label():
	text = "%d" % bank_reference.get_child_count()
	bulge()

func assign_label(amt : int):
	text = "%d" % amt
	#bulge()

func bulge():
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector3(2.0,2.0,2.0), tween_speed)
	tween.play()
	tween.tween_property(self, "scale", Vector3(1.,1.,1.), tween_speed)
	tween.play()
	await tween.finished
	tween.kill()
