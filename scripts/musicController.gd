extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(GameManager.inMenu):
		$MenuMusic.volume_db=24
	else:
		if($MenuMusic.volume_db>-80):
			$MenuMusic.volume_db-=delta*10
		if(GameManager.playerState==GameManager.possibleStates.OUTSIDE):
			if($MoonSounds.volume_db<0):
				$MoonSounds.volume_db+=delta*40
				if($MoonSounds.volume_db>0):
					$MoonSounds.volume_db=0
			if($BaseSounds.volume_db>-80):
				$BaseSounds.volume_db-=delta*10
				if($BaseSounds.volume_db<-800):
					$BaseSounds.volume_db=-80
			if($BaseMusic.volume_db>-80):
				$BaseMusic.volume_db-=delta*10
				if($BaseMusic.volume_db<-800):
					$BaseMusic.volume_db=-80
		else:
			if($MoonSounds.volume_db>-80):
				$MoonSounds.volume_db-=delta*10
				if($MoonSounds.volume_db<-800):
					$MoonSounds.volume_db=-80
			if($BaseSounds.volume_db<-5):
				$BaseSounds.volume_db+=delta*40
				if($BaseSounds.volume_db>-5):
					$BaseSounds.volume_db=-5
			if($BaseMusic.volume_db<-5):
				$BaseMusic.volume_db+=delta*40
				if($BaseMusic.volume_db>-5):
					$BaseMusic.volume_db=-5
