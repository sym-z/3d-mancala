extends RigidBody3D

@export var mesh : MeshInstance3D
## How much random variation is there between spawn positions
@export var pos_variation_magnitude : float = 0.1

@export var detection_field : Area3D
@export var speaker : AudioStreamPlayer3D
@export var drop_sounds : Array[AudioStreamMP3]
var drop_sound_played : bool = false

func _ready():
	var new_material : StandardMaterial3D = StandardMaterial3D.new()
	new_material.albedo_color = Color(randf_range(0,1.0),randf_range(0,1.0),randf_range(0,1.0),1.0)
	new_material.metallic_specular = 1.0
	new_material.roughness = 0.0
	new_material.clearcoat_roughness = 0.0
	new_material.refraction_scale = 0.95
	mesh.material_override = new_material
	detection_field.connect("body_entered", collision)

func collision(body : Node):
	if  drop_sound_played == false and body != self:
		print("COLLIDE WITH ", body)
		#TODO: PLAY DROP SOUND
		play_random_drop_sound()
		drop_sound_played = true

func play_random_drop_sound():
	speaker.stream = drop_sounds[randi_range(0,drop_sounds.size()-1)]
	speaker.pitch_scale = randf_range(0.8,1.2)
	speaker.play()
