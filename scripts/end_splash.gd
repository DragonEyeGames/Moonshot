extends Control

func _ready() -> void:
	var save = SaveData.loadSave()
	if(save != null):
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), save.masterVolume)
		if(save.masterVolume==-80):
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80)

func wait():
	get_tree().change_scene_to_file("res://scenes/splash.tscn")
