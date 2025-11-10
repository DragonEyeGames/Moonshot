extends Node2D

@export var textToDisplay: Array[String]
var displayedText=-1
var visibleCharacters:=0.0
var entered=false
var selected:=""
var zoomed=false
var canZoom=true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RichTextLabel.visible_characters=0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(entered and not zoomed and canZoom and Input.is_action_just_pressed("Interact")):
		zoom()
	elif(entered and zoomed and canZoom and Input.is_action_just_pressed("Interact")):
		unzoom()
	
	if($RichTextLabel.visible_ratio<1):
		visibleCharacters+=delta
		if(visibleCharacters>.02):
			visibleCharacters-=.02
			$RichTextLabel.visible_characters+=1
		if(Input.is_action_just_pressed("Click")):
			$RichTextLabel.visible_ratio=1
	elif(Input.is_action_just_pressed("Click") and $RichTextLabel.visible and entered):
		if(displayedText+2>len(textToDisplay)):
			$RichTextLabel.visible=false
			await get_tree().create_timer(.1).timeout
			$Interface.visible=true
		else:
			updateText()
		
func updateText():
	displayedText+=1
	$RichTextLabel.text=textToDisplay[displayedText]
	$RichTextLabel.visible_characters=0
	$RichTextLabel.visible_ratio=0

func _player_entered(_body: Node2D) -> void:
	entered=true


func _player_exited(_body: Node2D) -> void:
	entered=false
	
func zoom():
	if($BEEP.playing):
		$BEEP.playing=false
		$Control.visible=false
		$Loading.visible=true
	GameManager.zoomCamera($ZoomPoint, 5)
	zoomed=true
	canZoom=false
	GameManager.playerMove=false
	GameManager.flashlightOn=false
	GameManager.playerAnimator.play("fade")
	await get_tree().create_timer(1.1).timeout
	canZoom=true
	if($Loading.visible):
		$Loading.visible=false
		await get_tree().create_timer(.1).timeout
		updateText()
		$RichTextLabel.visible=true
		

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
