extends Node2D

@export var startingText: String
var visibleCharacters:=0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RichTextLabel.text=startingText
	$RichTextLabel.visible_characters=0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	visibleCharacters+=delta*25
	if(visibleCharacters>1):
		visibleCharacters-=1
		$RichTextLabel.visible_characters+=1
		
