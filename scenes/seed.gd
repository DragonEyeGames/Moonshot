extends ColorRect

var fallen=false
var fallDistance=0
var fallSpeed=0
var colliding=false

func _process(delta: float) -> void:
	if(fallen and fallDistance>0):
		position.y+=fallSpeed*delta
		fallDistance-=delta*fallSpeed
		if(fallDistance<0):
			fallDistance=0
			print("STAP")
		if(fallDistance==0 and colliding):
			print("BOTANISTS")
	
func fall():
	print("FAAAAAAALLLLLLLING")
	fallDistance=randi_range(70, 130)
	fallSpeed=randf_range(90, 110)
	fallSpeed*=2
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	colliding=true
