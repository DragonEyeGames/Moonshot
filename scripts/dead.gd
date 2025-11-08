extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$RichTextLabel.text="Dead via " + GameManager.dead
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	$ColorRect2/AnimationPlayer.play("out")

	GameManager.helmet = null
	GameManager.player = null
	GameManager.playerSprinting = false

	GameManager.oxygenator = null
	GameManager.waterReclaimer = null
	GameManager.solarField = null

	GameManager.playerState = GameManager.possibleStates.OUTSIDE

	GameManager.flashlightOn = false
	GameManager.playerEnergy = 100.0
	GameManager.inventory = []
	GameManager.selectedSlot = 0
	GameManager.playerMove = true
	GameManager.dead = ""
	GameManager.instants = ["Protein", "IceCream", "H Mac", "H Cup", "Carrots"]
	GameManager.nonstackingList = ["Tape", "H Cup", "Jug"]
	GameManager.nonstackingDict = [
		{"name": "Tape", "amount": 15},
		{"name": "Tape", "amount": 1},
		{"name": "Tape", "amount": GameManager.pickedUpJugWater}
	]
	GameManager.currentEmission = 0.0
	GameManager.mousePos = Vector2.ZERO
	GameManager.tapeHolder = null

	GameManager.hud = null
	GameManager.collisionTool = null

	GameManager.baseWater = 100
	GameManager.baseHumidity = 0
	GameManager.suitHumidity = 0

	GameManager.pickedUpJugWater = 0

	GameManager.playerHand = null

	GameManager.solarOutput = 0.0

	GameManager.playerAnimator = null

	GameManager.basePower = 200
	GameManager.health = 100
	GameManager.currentTime = 12
	GameManager.day = 1
	GameManager.sunPower = 0

	GameManager.baseOxygen = 700.0
	GameManager.baseCarbon = 200

	GameManager.playerTool = ""

	GameManager.interactedItem = null

	GameManager.carbon = 0.0

	GameManager.camera = null

	GameManager.carrots = 0

	GameManager.food = 100
	GameManager.water = 400
	GameManager.inMenu=true

	await get_tree().create_timer(1.1).timeout
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
