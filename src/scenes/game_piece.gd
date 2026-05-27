extends RigidBody3D

@export var mesh : MeshInstance3D
## How much random variation is there between spawn positions
@export var pos_variation_magnitude : float = 0.1

func _ready():
	var new_material : StandardMaterial3D = StandardMaterial3D.new()
	new_material.albedo_color = Color(randf_range(0,1.0),randf_range(0,1.0),randf_range(0,1.0),1.0)
	new_material.metallic_specular = 1.0
	new_material.roughness = 0.0
	new_material.clearcoat_roughness = 0.0
	new_material.refraction_scale = 0.95
	mesh.material_override = new_material
