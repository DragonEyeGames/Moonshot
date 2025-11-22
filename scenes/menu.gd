extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var save = SaveData.loadSave()
	if(save != null):
		$SettingsMenu/HSlider.value=save.masterVolume
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), save.masterVolume)
		if(save.masterVolume==-80):
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("Click") and $HowTo.visible):
		$HowTo.visible=false


func _on_start_pressed() -> void:
	Music.moon()
	$ColorRect2/AnimationPlayer.play("out")
	var save = SaveData.new()
	save.masterVolume=$SettingsMenu/HSlider.value
	save.writeSave()
	await get_tree().create_timer(1.1).timeout
	get_tree().change_scene_to_file("res://scenes/Main.tscn")


func _on_how_pressed() -> void:
	$HowTo.visible=true


func _on_start_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($ButtonGlow, "modulate:a", .3, .1)
	var tween2 = create_tween()
	tween2.tween_property($Start, "scale", Vector2(.8, .8), .1)
	var tween3 = create_tween()
	tween3.tween_property($ButtonGlow, "scale", Vector2(.94, .94), .1)


func _on_start_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($ButtonGlow, "modulate:a", .05, .1)
	var tween2 = create_tween()
	tween2.tween_property($Start, "scale", Vector2(.73, .73), .1)
	var tween3 = create_tween()
	tween3.tween_property($ButtonGlow, "scale", Vector2(.9, .9), .1)


func _on_how_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($ButtonGlow2, "modulate:a", .3, .1)
	var tween2 = create_tween()
	tween2.tween_property($How, "scale", Vector2(.8, .8), .1)
	var tween3 = create_tween()
	tween3.tween_property($ButtonGlow2, "scale", Vector2(.94, .94), .1)


func _on_how_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($ButtonGlow2, "modulate:a", .05, .1)
	var tween2 = create_tween()
	tween2.tween_property($How, "scale", Vector2(.73, .73), .1)
	var tween3 = create_tween()
	tween3.tween_property($ButtonGlow2, "scale", Vector2(.9, .9), .1)


func _on_settings_pressed() -> void:
	$SettingsMenu.visible=true


func _on_settings_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($ButtonGlow3, "modulate:a", .3, .1)
	var tween2 = create_tween()
	tween2.tween_property($Settings, "scale", Vector2(.8, .8), .1)
	var tween3 = create_tween()
	tween3.tween_property($ButtonGlow3, "scale", Vector2(.94, .94), .1)


func _on_settings_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($ButtonGlow3, "modulate:a", .05, .1)
	var tween2 = create_tween()
	tween2.tween_property($Settings, "scale", Vector2(.73, .73), .1)
	var tween3 = create_tween()
	tween3.tween_property($ButtonGlow3, "scale", Vector2(.9, .9), .1)


func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	if(value==-80):
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80)


func _on_leave_pressed() -> void:
	$SettingsMenu.visible=false
