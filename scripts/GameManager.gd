extends Node
class_name Manager
#the space suit for the player
var helmet
var player: Player
var playerSprinting := false

#the player state state machine
enum possibleStates {
	OUTSIDE,
	INSIDE
}

var playerState: possibleStates=possibleStates.OUTSIDE

var flashlightOn=false
var playerEnergy:=100.0
var inventory=[{"name": "CleanFilter", "count": 1}]
var selectedSlot=0
var playerMove=true
var dead=""
var instants = ["Protein", "IceCream", "H Mac", "H Cup", "Carrots"]
var nonstackingList = ["Tape", "H Cup", "Jug"]
var nonstackingDict = [{"name": "Tape", "amount": 15}, {"name": "Tape", "amount": 1}, {"name": "Tape", "amount": pickedUpJugWater}]
var currentEmission:=0.0
var mousePos:Vector2
var tapeHolder

var hud
var collisionTool=null

var baseWater=100
var baseHumidity=0
var suitHumidity=0

var pickedUpJugWater=0

var playerHand

var solarOtput:=0.0

var playerAnimator: AnimationPlayer

var basePower=200
var health=100
var currentTime=12
var day=1
var sunPower=0

var baseOxygen=700
var baseCarbon=200

var playerTool=""

var interactedItem

var carbon=0.0

var camera

var carrots=0

var food = 100
var water = 400

func _process(_delta: float) -> void:
	nonstackingDict[2]["amount"] = pickedUpJugWater
	
func add(item, count):
	for thing in inventory:
		if thing["name"] == item and not thing["name"] in nonstackingList:
			thing["count"] += count
			return
	if(item in nonstackingList):
		for nonstackable in nonstackingDict:
			if(nonstackable["name"]==item):
				count=nonstackable["amount"]
				break
	inventory.append({"name": item, "count": count})
	
func subtract(item, count):
	for thing in inventory:
		if thing["name"] == item:
			thing["count"] -= count
			if(thing["count"]<=0):
				inventory.erase(thing)
			return

func zoomCamera(target, zoom):
	camera.following=target
	camera.zoomIn(zoom)
	
func unzoomCamera():
	camera.following=player
	camera.zoomIn(.75)
