extends Camera2D

@export var following : Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.camera=self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.global_position=following.global_position
	
func zoomIn(amount):
	#zoom = Vector2(amount, amount)
	var tween = create_tween()
	tween.tween_property(self, "zoom", Vector2(amount, amount), 1)
