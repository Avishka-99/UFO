extends KinematicBody


export var gravity = Vector3.DOWN * 1
export var speed = 4
export var rot_speed = 0.85

var velocity = Vector3(0,0,0)

func _physics_process(delta):
	velocity += gravity * delta
	#get_input(delta)
	velocity = move_and_slide(velocity, Vector3.UP)
	print(velocity)
