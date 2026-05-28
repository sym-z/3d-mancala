extends Node
var main_menu_scn : String = "uid://bqtsdv8po308"
var game_scn : String = "uid://c0wr77kcmfrov"

func main_menu():
	call_deferred("change_scene", main_menu_scn)

func game():
	call_deferred("change_scene", game_scn)

func change_scene(scene: String):
	get_tree().change_scene_to_file(scene)
