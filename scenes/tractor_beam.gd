extends Sprite2D

var abducting=false
var visibleTime:=0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.tractorBeam=self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(abducting):
		visibleTime+=delta
		visible=true
		global_position=GameManager.player.global_position
		if(visibleTime>2):
			for child in GameManager.player.get_children():
				if(child is Node2D and "sprites" in str(child.name).to_lower()):
					child.position.y-=5.5
					child.rotation_degrees+=7
