extends Node2D

var item
@export var shelf=false
@export var display=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(shelf):
		return
	for child in get_children():
		if not child.name=="Carrots":
			child.freeze=true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	visible=false
	for child in get_children():
		if(child.visible):
			visible=true
			item=str(child.name)
