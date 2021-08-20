extends KinematicBody


const MIN_CAMERA_ANGLE = -60
const MAX_CAMERA_ANGLE = 70
const GRAVITY = -20

export var camera_sensitivity: float = 0.05
export var speed: float = 10.0
export var acceleration: float = 6.0
export var jump_impulse: float = 12.0
var velocity: Vector3 = Vector3.ZERO

onready var head: Spatial = $Head


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	var movement = _get_movement_direction()
	
	velocity.x = lerp(velocity.x,movement.x * speed,acceleration * delta)
	velocity.z = lerp(velocity.z,movement.z * speed,acceleration * delta)
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity)


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		_handle_camera_rotation(event)


func _handle_camera_rotation(event):
	rotate_y(deg2rad(-event.relative.x * camera_sensitivity))
	head.rotate_x(deg2rad(-event.relative.y * camera_sensitivity))
	head.rotation.x = clamp(head.rotation.x, deg2rad(MIN_CAMERA_ANGLE), deg2rad(MAX_CAMERA_ANGLE))


func _get_movement_direction():
	var direction = Vector3.DOWN
	
	if Input.is_action_pressed("forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("backwards"):
		direction += transform.basis.z
	if Input.is_action_pressed("left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("right"):
		direction += transform.basis.x
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_impulse
	
	return direction

