extends CenterContainer

@export var menu_btn : Button 
@export var fade_time : float = 0.3
func _ready():
	modulate = Color(1,1,1,0)
	menu_btn.connect("pressed", to_menu)

func reveal():
	var tween : Tween = create_tween()
	tween.tween_property(self,"modulate", Color(1,1,1,1), fade_time)
	tween.play()
	
func to_menu():
	SceneTransition.main_menu()
