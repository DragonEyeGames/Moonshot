extends Node2D

var moonSounds:=false
var menuSounds:=true
var baseSounds:=false
var baseMusic:=false
var deadMusic:=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(get_tree().current_scene!=null and get_tree().current_scene.name=="Dead"):
		deadMusic=true
		moonSounds=false
		menuSounds=false
		baseSounds=false
		baseMusic=false
	elif(GameManager.inMenu):
		deadMusic=false
		moonSounds=false
		menuSounds=true
		baseSounds=false
		baseMusic=false
	else:
		menuSounds=false
		deadMusic=false
		if(GameManager.playerState==GameManager.possibleStates.OUTSIDE):
			moonSounds=true
			baseMusic=false
			baseSounds=false
		else:
			moonSounds=false
			baseMusic=true
			baseSounds=true
	loadSounds(delta)
	
func loadSounds(delta: float):
	update(menuSounds, $MenuMusic, delta)
	update(moonSounds, $MoonSounds, delta)
	update(baseSounds, $BaseSounds, delta)
	update(baseMusic, $BaseMusic, delta)
	update(deadMusic, $DeadMusic, delta)

func update(on: bool, player: AudioStreamPlayer2D, delta: float):
	if(on):
		if(player.volume_db<0):
			player.volume_db+=delta*70
			if(player.volume_db>0):
				player.volume_db=0
	else:
		if(player.volume_db>-80):
			player.volume_db-=delta*10
			if(player.volume_db<-80):
				player.volume_db=-80
