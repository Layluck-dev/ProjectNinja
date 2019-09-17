extends KinematicBody

var camera_angle = 0
var mouse_sensitivity = 0.2
var camera_change = Vector2()

var velocity = Vector3()
var direction = Vector3()

#fly variables
const FLY_SPEED = 20
const FLY_ACCEL = 4
var flying = false

#walk variables
var gravity = -9.8 * 5
const MAX_SPEED = 20
const MAX_RUNNING_SPEED = 50
const ACCEL = 2
const DEACCEL = 6

#jumping
const MAX_JUMP_HEIGHT = 50
const JUMP_HEIGHT = 15
var in_air = 0
var has_contact = false
var jumpCount = 0

#slope variables
const MAX_SLOPE_ANGLE = 40

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#handles the physics process
func _physics_process(delta):
	
	#adjust viewing orientation
	aim()
	if flying:
		fly(delta)
	else:
		walk(delta)

func _input(event):
	if event is InputEventMouseMotion:
		camera_change = event.relative
		
func walk(delta):
	# reset the direction of the player
	direction = Vector3()
	
	# get the rotation of the camera
	var aim = $Head/Camera.get_global_transform().basis
	# check input and change direction
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	if Input.is_action_pressed("move_backward"):
		direction += aim.z
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_right"):
		direction += aim.x
	
	#set y (vertical) axis to 0
	direction.y = 0
	direction = direction.normalized()
	
	#if the object is on the floor..
	if (is_on_floor()):
		jumpCount = 0
		has_contact = true
		var n = $Tail.get_collision_normal()
		var floor_angle = rad2deg(acos(n.dot(Vector3(0, 1, 0))))
		if floor_angle > MAX_SLOPE_ANGLE:
			velocity.y += -ACCEL -2
	
	#if not...
	else:
		if !$Tail.is_colliding():
			has_contact = false
		velocity.y += gravity * delta
	
	#if the object has contact, but is not on the floor...
	if (has_contact and !is_on_floor()):
		move_and_collide(Vector3(0, -1, 0))
	
	var temp_velocity = velocity
	temp_velocity.y = 0
	
	var speed
	if Input.is_action_pressed("move_sprint"):
		speed = MAX_RUNNING_SPEED
	else:
		speed = MAX_SPEED
	
	# where would the player go at max speed
	var target = direction * speed
	
	var acceleration
	if direction.dot(temp_velocity) > 0:
		acceleration = ACCEL
	else:
		acceleration = DEACCEL
	
	# calculate a portion of the distance to go
	temp_velocity = temp_velocity.linear_interpolate(target, acceleration * delta)
	
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z
	
	if !has_contact and Input.is_action_just_pressed("jump") and jumpCount == 0:
		jumpCount = 1 
	if has_contact and Input.is_action_just_pressed("jump") or jumpCount < 2 and Input.is_action_just_pressed("jump"):
		jump()
	
	if Input.is_action_just_released("jump"):
    	jump_cut()	
	
	
	# move, give m_a_s the up direction so it can apply _is_on_floor and more
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))
	
	if !has_contact:
		#print(in_air)
		in_air += 1

func jump():
		jumpCount += 1
		velocity.y = MAX_JUMP_HEIGHT
		has_contact = false

func jump_cut():
	if velocity.y > JUMP_HEIGHT:
		velocity.y = JUMP_HEIGHT

func fly(delta):
	# reset the direction of the player
	direction = Vector3()
	
	# get the rotation of the camera
	var aim = $Head/Camera.get_global_transform().basis
	
	# check input and change direction
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	if Input.is_action_pressed("move_backward"):
		direction += aim.z
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_right"):
		direction += aim.x
	
	direction = direction.normalized()
	
	# where would the player go at max speed
	var target = direction * FLY_SPEED
	
	# calculate a portion of the distance to go
	velocity = velocity.linear_interpolate(target, FLY_ACCEL * delta)
	
	# move
	move_and_slide(velocity)

#Changes the direction the char is looking in
func aim():
	
	#if the camera orientation changes...
	if camera_change.length() > 0:
		
		#Rotates the head on the y axis
		$Head.rotate_y(deg2rad(-camera_change.x * mouse_sensitivity))
		
		#temp var that holds the value of camera change (y axis) * mouse sensitivity
		var change = -camera_change.y * mouse_sensitivity
		
		#if change is between 60d and -60d (vertical)...
		if change + camera_angle < 60 and change + camera_angle > -60:
			
			#the change is applied to the character head
			$Head/Camera.rotate_x(deg2rad(change))
			camera_angle += change
		camera_change = Vector2()

func get_forward():
	pass

func _on_Area_body_entered( body ):
	if body.name == "Player":
		flying = true


func _on_Area_body_exited( body ):
	if body.name == "Player":
		flying = false
