extends ColorRect

var fallen=false
var fallDistance=0
var fallSpeed=0
var colliding=false
var reparented=false
var water:=0.0
var state="seed"

func _process(delta: float) -> void:
	if(fallen and fallDistance>0):
		position.y+=fallSpeed*delta
		fallDistance-=delta*fallSpeed
		if(fallDistance<0):
			fallDistance=0
		if(fallDistance==0 and (not colliding or randi_range(1, 4)==1)):
			queue_free()
	if(reparented==false and get_parent().name=="Seed Storage"):
		reparented=true
	if(reparented and state=="seed"):
		var farm = get_parent().get_parent()
		if(farm.standingWater>delta/10):
			farm.standingWater-=delta/10
			water+=delta/10
		else:
			water+=farm.standingWater
			farm.standingWater=0
		if(water>1):
			state="seedling"
	elif(state=="seedling"):
		var farm = get_parent().get_parent()
		if(farm.standingWater>delta/5):
			farm.standingWater-=delta/5
			water+=delta/5
		else:
			water+=farm.standingWater
			farm.standingWater=0
		if(water<=3):
			$stem.scale.y=water/2
		else:
			state="sprout"
	elif(state=="sprout"):
		var farm = get_parent().get_parent()
		if(farm.standingWater>delta/3):
			farm.standingWater-=delta/3
			water+=delta/3
		else:
			water+=farm.standingWater
			farm.standingWater=0
		if(water<=6):
			for child in $stem.get_children():
				child.scale.x=(water-3)/3
		else:
			state="young"
	elif(state=="young"):
		var farm = get_parent().get_parent()
		if(farm.standingWater>delta/2):
			farm.standingWater-=delta/2
			water+=delta/2
			if(water<=10):
				$".".color.r+=delta/20
				$".".color.g-=delta/20
				$".".color.b-=delta/20
			else:
				state="maturing"
		else:
			water+=farm.standingWater
			farm.standingWater=0
	elif(state=="maturing"):
		var farm = get_parent().get_parent()
		if(farm.standingWater>delta):
			farm.standingWater-=delta
			water+=delta
			if(water<=15):
				$".".scale+=Vector2(delta/15, delta/15)
			else:
				state="mature"
				$Plant/CollisionShape2D.disabled=false
		else:
			water+=farm.standingWater
			farm.standingWater=0
			
			
	
func fall():
	fallDistance=randi_range(70, 130)
	fallSpeed=randf_range(90, 110)
	fallSpeed*=2
	


func _on_area_2d_area_entered(_area: Area2D) -> void:
	colliding=true
