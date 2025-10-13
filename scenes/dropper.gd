extends Node2D

var placed=false

func _process(delta: float) -> void:
	if(placed):
		placed=false
		for child in get_children():
			child.fallen=true
			child.fall()
