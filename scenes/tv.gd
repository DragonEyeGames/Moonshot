extends Node2D

signal optionSelected()
var selectedOption:int=0

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
	loadText("[b][Earth][/b]: This is Mission Control Center broadcasting to Moon Base Gamma. Do you read me?", "Yes", "No", "What?")

func loadText(newText: String, opt1: String, opt2: String, opt3: String):
	$MessageLog.text+=newText
	$Popup/Button.text=opt1
	$Popup/Button2.text=opt2
	$Popup/Button3.text=opt3
	while $MessageLog.visible_characters<$MessageLog.text.length():
		await get_tree().create_timer(.02).timeout
		$MessageLog.visible_characters+=1
	await get_tree().create_timer(.05).timeout
	$Popup.visible=true
	await optionSelected
	$Popup.visible=false
	if(selectedOption==1):
		loadText("\n[b][Moon][/b]: Yes. I read you loud and clear.\n[b][Earth][/b]: Good to hear. Now, to make sure the base is intact. Is the oxygenator leaking anymore?", "Hope Not", "Yes", "No")
	if(selectedOption==2):
		loadText("\n[b][Moon][/b]: No. I have no idea what you just said.\n[b][Earth][/b]: I do not appreciate your sarcasm. Now, to make sure the base is intact. Is the oxygenator leaking anymore?", "Hope Not", "Yes", "No")
	if(selectedOption==3):
		loadText("\n[b][Moon][/b]: What? Im not sure what you mean by 'read me'. Are you a book?\n[b][Earth][/b]: I do not appreciate your sarcasm. Now, to make sure the base is intact. Is the oxygenator leaking anymore?", "Hope Not", "Yes", "No")
	selectedOption=0

func _on_button_pressed() -> void:
	selectedOption=1
	optionSelected.emit()


func _on_button_2_pressed() -> void:
	selectedOption=2
	optionSelected.emit()


func _on_button_3_pressed() -> void:
	selectedOption=3
	optionSelected.emit()
