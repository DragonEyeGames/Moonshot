extends Node2D

var placed=false

func _process(_delta: float) -> void:
	if(placed):
		placed=false
		for child in get_children():
			child.fallen=true
			child.fall()
		await get_tree().create_timer(1.5).timeout
		for child in get_children():
			child.reparent($"../Seed Storage")
		await get_tree().create_timer(.1).timeout
		queue_free()
