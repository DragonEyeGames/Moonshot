extends Node2D

var moonSounds:=false
var menuSounds:=true
var baseSounds:=false
var baseMusic:=false
var deadMusic:=false

var currentlyPlaying:AudioStreamPlayer2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentlyPlaying=$MenuMusic

func dead():
	if($DeadMusic.playing==false):
		$DeadMusic.playing=true
	var tween=create_tween()
	tween.tween_property($DeadMusic, "volume_db", 0, .5)
	await get_tree().create_timer(.5).timeout
	var tween2 = create_tween()
	tween2.tween_property(currentlyPlaying, "volume_db", -80, 0.5)
	currentlyPlaying.playing=false
	currentlyPlaying=$DeadMusic
	
func moon():
	if($MoonSounds.playing==false):
		$MoonSounds.playing=true
	var tween=create_tween()
	tween.tween_property($MoonSounds, "volume_db", 0, .5)
	await get_tree().create_timer(.5).timeout
	var tween2 = create_tween()
	tween2.tween_property(currentlyPlaying, "volume_db", -80, 0.5)
	currentlyPlaying.playing=false
	currentlyPlaying=$MoonSounds
	
func base():
	if($BaseMusic.playing==false):
		$BaseMusic.playing=true
	var tween=create_tween()
	tween.tween_property($BaseMusic, "volume_db", 0, .5)
	await get_tree().create_timer(.5).timeout
	var tween2 = create_tween()
	tween2.tween_property(currentlyPlaying, "volume_db", -80, 0.5)
	currentlyPlaying.playing=false
	currentlyPlaying=$BaseMusic
	
func menu():
	if($MenuMusic.playing==false):
		$MenuMusic.playing=true
	var tween=create_tween()
	tween.tween_property($MenuMusic, "volume_db", 0, .5)
	await get_tree().create_timer(.5).timeout
	var tween2 = create_tween()
	tween2.tween_property(currentlyPlaying, "volume_db", -80, 0.5)
	currentlyPlaying.playing=false
	currentlyPlaying=$MenuMusic
	
