extends Node2D

class_name Building


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func playerEnter(area: Node2D):
	openMods()
	$Roof/State.play("hide")
	
func playerExit(area: Node2D):
	$Roof/State.play("show")

func openMods():
	pass
