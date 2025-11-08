extends TextureButton

@export var newText:=""
@export var fontSize:=16

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("Click") and $"../../../../TextHolder".visible):
		$"../../../../TextHolder".visible=false


func _on_pressed() -> void:
	$"../../../../TextHolder".visible=true
	$"../../../../TextHolder/TextBox".text=newText
	$"../../../../TextHolder/TextBox".add_theme_font_size_override("normal_font_size", fontSize)
