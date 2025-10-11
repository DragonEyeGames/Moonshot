extends Electronic

var overriden=false
var colliding=false
var zoomed = false
var canZoom=true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ProgressBar.editable=overriden
	if(GameManager.baseOxygen<30):
		efficiency=.7
		maxPower=10
	elif(GameManager.baseOxygen<60):
		efficiency=.85
		maxPower=5
	elif(GameManager.baseOxygen<100):
		efficiency=1.1
		maxPower=1.1
	elif(GameManager.baseOxygen<=300):
		efficiency=1.3
		maxPower=.2
	elif(GameManager.baseOxygen>300):
		maxPower=0
	efficiency =  1 - ((maxPower/10)-.5)
	maxPower=maxPower/efficiency
	efficiency*=2
	if(overriden):
		maxPower=$ProgressBar.value
		efficiency =  (1 - (($ProgressBar.value/10)-.5))*2
		$ColorRect2.color=Color(1, 0, 0)
		maxPower=maxPower/efficiency
	else:
		$ColorRect2.color=Color(.05, .05, .05)
	power=maxPower
	powerSap(delta)
	if(overriden):
		power/=priorityNerf
	GameManager.baseOxygen+=power
	$ColorRect4/RichTextLabel.text=str(round(power/efficiency/delta*100)/100)
	$ColorRect/RichTextLabel.text=str(round(GameManager.baseOxygen*10)/10)
	$ColorRect4/RichTextLabel.text=str(round(power/efficiency/delta*100)/100)
	$ColorRect3/RichTextLabel.text=str(round(efficiency*50)/100)
	if(colliding and Input.is_action_just_pressed("Interact") and GameManager.selectedSlot==-1 and canZoom and not zoomed):
		GameManager.zoomCamera($ZoomPoint, 3.8)
		zoomed=true
		canZoom=false
		await get_tree().create_timer(1.1).timeout
		$ColorRect5.visible=false
		canZoom=true
	elif(colliding and Input.is_action_just_pressed("Interact") and GameManager.selectedSlot==-1 and canZoom and zoomed):
		GameManager.unzoomCamera()
		zoomed=false
		canZoom=false
		$ColorRect5.visible=true
		await get_tree().create_timer(1.1).timeout
		canZoom=true

func _on_button_pressed() -> void:
	overriden=!overriden


func _on_area_2d_body_entered(body: Node2D) -> void:
	colliding=true


func _on_area_2d_body_exited(body: Node2D) -> void:
	colliding=false
