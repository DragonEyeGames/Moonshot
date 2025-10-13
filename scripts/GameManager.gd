extends Node

var helmet
var player
var playerSprinting := false
var playerState="outside"
var flashlightOn=true
var playerEnergy:=100.0
var inventory=[]
var selectedSlot=0
var playerMove=true
var dead=""
var instants = ["Protein", "IceCream", "H Mac", "H Cup"]

var baseWater=100
var baseHumidity=0
var suitHumidity=0

var solarOutput=0

var playerAnimator

var basePower=200
var health=100
var currentTime=22
var day=1
var sunPower=0

var baseOxygen=700
var baseCarbon=200

var carbon=0.0

var camera

var food = 100
var water = 400

func zoomCamera(target, zoom):
	camera.following=target
	camera.zoomIn(zoom)
	
func unzoomCamera():
	camera.following=player
	camera.zoomIn(.75)
