extends Sprite2D

var abducting=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.tractorBeam=self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(abducting):
		visible=true
		global_position=GameManager.player.global_position
		for child in GameManager.player.get_children():
			if(child is Node2D and "sprites" in str(child.name).to_lower()):
				child.position.y-=5
				child.rotation_degrees+=randf_range(3, 5)
