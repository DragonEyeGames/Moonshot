extends Node

var helmet
var player
var playerSprinting := false
var playerState="outside"
var flashlightOn=true
var playerEnergy:=100
var inventory=[]
var selectedSlot=0
var playerMove=true
var dead=""
var instants = ["Protein", "IceCream", "H Mac", "H Cup"]

var baseWater=90
var baseHumidity=0
var suitHumidity=0

var basePower=40
var health=100
var currentTime=22
var day=1
var sunPower=0
var baseOxygen=50

var food = 100
var water = 400
