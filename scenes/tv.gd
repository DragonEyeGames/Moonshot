extends Node2D

var zoomed=false

func _process(_delta: float) -> void:
	$Noise.texture.noise.seed+=1

func zoom():
	GameManager.zoomCamera($ZoomPoint, 3.8)
	$"Visibility Controller".play("show")
	zoomed=true
	GameManager.playerMove=false
	GameManager.flashlightOn=false
	await get_tree().create_timer(3.4).timeout
	$"Establishing Connection".visible=false
	await get_tree().create_timer(.1).timeout
	$Established.visible=true
	await get_tree().create_timer(2.4).timeout
	$Established.visible=false
	await get_tree().create_timer(.1).timeout
	loadText(0, "This is Mission Control Center broadcasting to Moon Base Gamma. Do you read me?", "Yes", "No", "What?")

func loadText(sender: int, newText: String, opt1: String, opt2: String, opt3: String):
	var message="[b]["
	if(sender==0):
		message += "Earth"
	else:
		message += "Moon"
	message += "]:[/b]"
	message+=newText
	$MessageLog.text+=message
	$Popup/Button.text=opt1
	$Popup/Button2.text=opt2
	$Popup/Button3.text=opt3
	$MessageLog.visible_ratio=0
	while $MessageLog.visible_ratio<1:
		await get_tree().create_timer(.05).timeout
		$MessageLog.visible_characters+=1
	await get_tree().create_timer(.05).timeout
	$Popup.visible=true
