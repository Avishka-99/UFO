extends KinematicBody


export var gravity = Vector3.DOWN * 0
export var speed = 4
export var rot_speed = 0.85
onready var Camera3D: Camera = $Camera
onready var tween: Tween = $Tween
var velocity = Vector3(20,0,0)
func _ready():
	transition_camera3D($Second,$First,2)
	#$Timer.start(5)
	pass
func _physics_process(delta):
	velocity += gravity * delta
	#get_input(delta)
	if Input.is_action_pressed("ui_left"):
		#self.global_transform.origin.z=-0.5
		self.global_transform.origin=self.global_transform.origin.linear_interpolate(Vector3(self.global_transform.origin.x,self.global_transform.origin.y,-2.8),delta*speed)
		rotation_degrees.y-=10
		#rotation=Vector3(0,0.4,0);
	if Input.is_action_pressed("ui_right"):
		self.global_transform.origin=self.global_transform.origin.linear_interpolate(Vector3(self.global_transform.origin.x,self.global_transform.origin.y,2.8),delta*speed)
		rotation=Vector3(0,-0.4,0);
	if Input.is_action_pressed("ui_up"):
		velocity += -transform.basis.x * speed
	if Input.is_action_pressed("ui_down"):
		velocity += transform.basis.x * speed
	rotation=Vector3(0,0,0);
	velocity = move_and_slide(velocity, Vector3.UP)

func get_input(delta):
	var vy = velocity.y
	velocity = Vector3.ZERO
	#if Input.is_action_pressed("ui_up"):
		#velocity += -transform.basis.x * speed
	#if Input.is_action_pressed("ui_down"):
		#velocity += transform.basis.x * speed
	if Input.is_action_pressed("ui_left"):
		velocity -= transform.basis.z * speed
	if Input.is_action_pressed("ui_right"):
		velocity += transform.basis.z * speed
	velocity.y = vy
func transition_camera3D(from: Camera, to: Camera, duration: float = 1.0) -> void:
	Camera3D.fov=from.fov
	Camera3D.cull_mask=from.cull_mask
	Camera3D.global_transform=from.global_transform
	Camera3D.current=true
	tween.remove_all()
	#print(to.global_transform)
	tween.interpolate_property(Camera3D, "global_transform", Camera3D.global_transform, 
		$First.global_transform, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(Camera3D, "fov", Camera3D.fov, 
		to.fov, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(Camera3D, "rotation", Camera3D.rotation, 
		to.rotation, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween,"tween_completed")
	velocity=Vector3(40,0,0)
func rotateCarLeft():
	tween.interpolate_property(self, "rotation", self.global_transform, 
		123, 2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	yield(tween,"tween_completed")

func _on_Tween_tween_all_completed():
	$First.queue_free()
	$Second.queue_free()
	$cam.queue_free()
	$Tween.queue_free()

