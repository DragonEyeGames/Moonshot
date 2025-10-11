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

var basePower=10
var health=100
var currentTime=0
var day=1
var sunPower=0

var food = 90
var water = 90
