extends Resource

class_name SaveData

const SAVE_GAME_PATH := "user://savegame.tres"

@export var masterVolume := 0

func writeSave():
	ResourceSaver.save(self, SAVE_GAME_PATH)
	
static func loadSave():
	if ResourceLoader.exists(SAVE_GAME_PATH):
		return load(SAVE_GAME_PATH)
	return null
