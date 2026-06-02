extends AudioStreamPlayer
@export var streams : Dictionary[String,AudioStreamMP3] = {}

func announce(name : String):
	for key in streams.keys():
		print(key)
		if name == key:
			stream = streams[name]
			play()
			return
	
func capture():
	announce("capture")
	
func extra_turn():
	announce("extra_turn")
	
func p1_win():
	announce("p1_win")

func p2_win():
	announce("p2_win")

func tie():
	announce("tie")

func title():
	announce("title")
