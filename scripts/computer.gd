extends Node2D

@export var textToDisplay: String
var visibleCharacters:=0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RichTextLabel.text=textToDisplay
	$RichTextLabel.visible_characters=0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if($RichTextLabel.visible_ratio<1.0):
		visibleCharacters+=delta*25
		if(visibleCharacters>1):
			visibleCharacters-=1
			$RichTextLabel.visible_characters+=1
	else:
		$RichTextLabel.visible_ratio=1.0
		
