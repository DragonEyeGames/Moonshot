extends ColorRect

var collision=false


func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	collision=true


func _on_area_2d_body_exited(body: Node2D) -> void:
	collision=false
