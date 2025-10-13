extends Electronic

class_name ElectronicZoom

var zoomed=false
var colliding=false
var canZoom=true

func _on_area_2d_body_entered(body: Node2D) -> void:
	colliding=true


func _on_area_2d_body_exited(body: Node2D) -> void:
	colliding=false
	
func zoom():
	GameManager.zoomCamera($ZoomPoint, 3.8)
	zoomed=true
	canZoom=false
	GameManager.playerMove=false
	GameManager.flashlightOn=false
	GameManager.playerAnimator.play("fade")
	await get_tree().create_timer(1.1).timeout
	$ColorRect5.visible=false
	canZoom=true

func unzoom():
	GameManager.unzoomCamera()
	zoomed=false
	canZoom=false
	$ColorRect5.visible=true
	GameManager.playerAnimator.play("appear")
	await get_tree().create_timer(1.1).timeout
	GameManager.playerMove=true
	canZoom=true
