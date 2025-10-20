extends Node

var helmet
var player
var playerSprinting := false
var playerState="outside"
var flashlightOn=false
var playerEnergy:=100.0
var inventory=[]
var selectedSlot=0
var playerMove=true
var dead=""
var instants = ["Protein", "IceCream", "H Mac", "H Cup", "Carrots"]

var tapeHolder

var hud
var collisionTool=null

var baseWater=100
var baseHumidity=0
var suitHumidity=0

var pickedUpJugWater=-1

var playerHand

var solarOutput:=0.0

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

func add(item, count):
	for thing in inventory:
		if thing["name"] == item:
			thing["count"] += count
			return
	inventory.append({"name": item, "count": count})
	
func subtract(item, count):
	for thing in inventory:
		if thing["name"] == item:
			thing["count"] -= count
			if(thing["count"]<=0):
				inventory.erase(thing)
			return
	inventory.append({"name": item, "count": count})

func zoomCamera(target, zoom):
	camera.following=target
	camera.zoomIn(zoom)
	
func unzoomCamera():
	camera.following=player
	camera.zoomIn(.75)
