extends CenterContainer

@export var menu_btn : Button 

func _ready():
	visible = false
	menu_btn.connect("pressed", to_menu)

func reveal():
	visible = true
	
func to_menu():
	SceneTransition.main_menu()
