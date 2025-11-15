extends Electronic

class_name ElectronicZoom

var zoomed=false
var colliding=false
var canZoom=true

func _on_area_2d_body_entered(_body: Node2D) -> void:
	print("HEY")
	colliding=true


func _on_area_2d_body_exited(_body: Node2D) -> void:
	colliding=false
	
func zoom(type="fade"):
	GameManager.zoomCamera($ZoomPoint, 4.5)
	zoomed=true
	canZoom=false
	GameManager.playerMove=false
	GameManager.flashlightOn=false
	GameManager.playerAnimator.play(type)
	await get_tree().create_timer(1.1).timeout
	$ColorRect5.visible=false
	canZoom=true

func unzoom(type="appear"):
	GameManager.unzoomCamera()
	zoomed=false
	canZoom=false
	$ColorRect5.visible=true
	GameManager.playerAnimator.play(type)
	await get_tree().create_timer(1.1).timeout
	GameManager.playerMove=true
	canZoom=true
