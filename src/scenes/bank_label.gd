extends Label3D

@export var bank_reference : Marker3D

func _ready():
	bank_reference.connect("bank_updated", refresh_label, CONNECT_DEFERRED)
	bank_reference.connect("set_manual", assign_label)
func refresh_label():
	text = "%d" % bank_reference.get_child_count()

func assign_label(amt : int):
	text = "%d" % amt
