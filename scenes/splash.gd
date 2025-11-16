extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var save = SaveData.loadSave()
	if(save != null):
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), save.masterVolume)
		if(save.masterVolume==-80):
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80)
	await get_tree().create_timer(0.51).timeout
	$Transition.play("fadeOut")
	await get_tree().create_timer(2.6).timeout
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
