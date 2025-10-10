extends CharacterBody2D


@export var  speed = 300.0


func _process(delta: float) -> void:
	# Add the gravity.
	velocity = Input.get_vector("Left", "Right", "Up", "Down")
	velocity*=speed
	move_and_slide()
