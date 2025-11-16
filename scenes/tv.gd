extends Node2D

signal optionSelected()
var selectedOption:int=0
var page=0
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
	loadText("[b][Earth]: [/b]This is Mission Control Center broadcasting to Moon Base Gamma. Do you read me?", "Yes", "No", "What?")

func loadText(newText: String, opt1: String, opt2: String, opt3: String):
	page+=1
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
	if(page==1):
		var text = " Now, to make sure the base is intact. Is the oxygenator leaking anymore?"
		var textAdditive=""
		var baseAdditive="\n[b][Earth]: [/b]"
		if(selectedOption==1):
			textAdditive="Yes. I read you loud and clear."
			baseAdditive+="Glad to hear it."
		if(selectedOption==2):
			textAdditive="No. I have no idea what you just said."
			baseAdditive+="I don't appreciate your sarcasm,"
		if(selectedOption==3):
			textAdditive="What? What exactly do you mean by 'read me'?"
			baseAdditive+="Well atleast you responded. Good enough."
		text = "\n[b][Moon]: [/b]" + textAdditive + baseAdditive + text
		loadText(text, "Hope Not", "Yes", "No")
		selectedOption=0
	elif(page==2):
		var parts = $MessageLog.text.split("\n")
		$MessageLog.visible_characters-=parts[0].length()
		parts.remove_at(0)
		$MessageLog.visible_characters-=parts[0].length()
		parts.remove_at(0)
		$MessageLog.text = "\n".join(parts)
		var text = " On to the next. Is the water reclaimer making water again?"
		var textAdditive=""
		var baseAdditive="\n[b][Earth]: [/b]"
		if(selectedOption==1):
			textAdditive="Hope Not. Haven't checked."
			baseAdditive+="Well as you are still alive i'll assume its working."
		if(selectedOption==2):
			textAdditive="Yes. I'm seconds away from running out of air."
			baseAdditive+="Well, you aren't rushing to fix it. Either you don't prioritize your life well or it works. "
		if(selectedOption==3):
			textAdditive="Nope. I got that fixed eons ago."
			baseAdditive+="Glad that you prioritized its repair."
		text = "\n[b][Moon]: [/b]" + textAdditive + baseAdditive + text
		loadText(text, "Possibly?", "Yes", "No")
		selectedOption=0
	elif(page==3):
		var parts = $MessageLog.text.split("\n")
		$MessageLog.visible_characters-=parts[0].length()
		parts.remove_at(0)
		$MessageLog.visible_characters-=parts[0].length()
		parts.remove_at(0)
		$MessageLog.text = "\n".join(parts)
		var text = " On to the next. Is the solar farm making power again??"
		var textAdditive=""
		var baseAdditive="\n[b][Earth]: [/b]"
		if(selectedOption==1):
			textAdditive="Maybe??? Im not very thirsty so..."
			baseAdditive+="Well ill assume that its working because you grew plants."
		if(selectedOption==2):
			textAdditive="Yup. I got that fixed and have been enjoying my water."
			baseAdditive+="Glad to hear that you are enjoying your water."
		if(selectedOption==3):
			textAdditive="Nope. I bypassed that step and have been licking humidity off the wall."
			baseAdditive+="If you really were doing that this system wouldn't be running."
		text = "\n[b][Moon]: [/b]" + textAdditive + baseAdditive + text
		loadText(text, "Possibly?", "Yes", "No")
		selectedOption=0
	elif(page==4):
		var parts = $MessageLog.text.split("\n")
		$MessageLog.visible_characters-=parts[0].length()
		parts.remove_at(0)
		$MessageLog.visible_characters-=parts[0].length()
		parts.remove_at(0)
		$MessageLog.text = "\n".join(parts)
		var text = " On to the next. Were you able to successfully grow food?"
		var textAdditive=""
		var baseAdditive="\n[b][Earth]: [/b]"
		if(selectedOption==1):
			textAdditive="Well I'm not quite sure. Maybe?"
			baseAdditive+="As this computer is running then yes. You fixed it."
		if(selectedOption==2):
			textAdditive="Yup. Got that fixed and have been mining bitcoins with the excess."
			baseAdditive+="Good that you got the power up and running."
		if(selectedOption==3):
			textAdditive="No. Ive been running on fumes of energy."
			baseAdditive+="Well there wasn't enough energy for that. I'll assume you fixed it."
		text = "\n[b][Moon]: [/b]" + textAdditive + baseAdditive + text
		loadText(text, "Possibly?", "Yes", "No")
		selectedOption=0
	elif(page==5):
		var parts = $MessageLog.text.split("\n")
		$MessageLog.visible_characters-=parts[0].length()
		parts.remove_at(0)
		$MessageLog.visible_characters-=parts[0].length()
		parts.remove_at(0)
		$MessageLog.text = "\n".join(parts)
		var text = " On to the next."
		var textAdditive=""
		var baseAdditive="\n[b][Earth]: [/b]"
		if(selectedOption==1):
			textAdditive="I can't quite remember if I did or not."
			baseAdditive+="Pretty sure there wasn't enough food for you to live. I'm sure you did it."
		if(selectedOption==2):
			textAdditive="I have so many carrots. I dine on a table of pure carrot. I drink carrot juice."
			baseAdditive+="Glad that you were able to grow some carrots."
		if(selectedOption==3):
			textAdditive="No. I tried but those dang rabbits ate my carrots."
			baseAdditive+="I hope that there aren't rabbits on the moon. Im sure that you ate the carrots yourself."
		text = "\n[b][Moon]: [/b]" + textAdditive + baseAdditive + text
		loadText(text, "Possibly?", "Yes", "No")
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
