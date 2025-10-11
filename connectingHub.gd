extends Building


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	GameManager.basePower-=.9*delta
	#$PointLight2D2.energy=1.0
	$RichTextLabel2.text=str(GameManager.basePower)
