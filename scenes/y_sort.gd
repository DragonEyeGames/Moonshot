extends Sprite2D

@export var minimum: int = 1
@export var maximum: int = 4
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(GameManager.player.global_position.y>self.global_position.y):
		z_index=minimum
	else:
		z_index=maximum
