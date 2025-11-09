extends Node2D

@export var textToDisplay: Array[String]
var displayedText=2
var visibleCharacters:=0.0
var entered=false
var selected:=""
var zoomed=false
var canZoom=true
var lastPage=false
var textFinished=true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RichTextLabel.visible_characters=0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(displayedText+1>=len(textToDisplay) and lastPage==false):
		lastPage=true
	if(lastPage and $RichTextLabel.visible_ratio>=1.0 and textFinished==false):
		textFinished=true
		$Interface.visible=true
		$RichTextLabel.visible=false
#	prints(entered, zoomed, canZoom)
	if($RichTextLabel.visible_ratio<1.0):
		visibleCharacters+=delta*25
		if(visibleCharacters>1):
			visibleCharacters-=1
			$RichTextLabel.visible_characters+=1
	else:
		$RichTextLabel.visible_ratio=1.0
	if(entered and not zoomed and canZoom and Input.is_action_just_pressed("Interact")):
		zoom()
		if(not lastPage and not textFinished):
			updateText()
	elif(entered and zoomed and canZoom and Input.is_action_just_pressed("Interact")):
		unzoom()
		
	if(Input.is_action_just_pressed("Click") and $RichTextLabel.visible_ratio>=1.0 and entered and not lastPage):
		updateText()
	elif(Input.is_action_just_pressed("Click") and $RichTextLabel.visible_ratio<1.0 and entered):
		$RichTextLabel.visible_ratio=1.0
		
func updateText():
	displayedText+=1
	$RichTextLabel.text=textToDisplay[displayedText]
	$RichTextLabel.visible_characters=0
	print($RichTextLabel.text)
	$RichTextLabel.visible_ratio=0

func _player_entered(_body: Node2D) -> void:
	entered=true


func _player_exited(_body: Node2D) -> void:
	entered=false
	
func zoom():
	if($BEEP.playing):
		$BEEP.playing=false
	GameManager.zoomCamera($ZoomPoint, 5)
	zoomed=true
	canZoom=false
	GameManager.playerMove=false
	GameManager.flashlightOn=false
	GameManager.playerAnimator.play("fade")
	await get_tree().create_timer(1.1).timeout
	canZoom=true

func unzoom():
	GameManager.unzoomCamera()
	zoomed=false
	canZoom=false
	GameManager.playerMove=true
	GameManager.playerAnimator.play("appear")
	await get_tree().create_timer(1.1).timeout
	canZoom=true


func _on_systems_pressed() -> void:
	selected=""
	$Interface/Systems_Popup.visible=true


func _on_exit_pressed() -> void:
	selected=""
	$Interface/Systems_Popup.visible=false
	$Interface/Instructions_Popup.visible=false


func _on_instructions_pressed() -> void:
	$Interface/Instructions_Popup.visible=true
