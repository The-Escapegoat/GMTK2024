
extends CharacterBody2D

#pls work

const SPEED = 200.0
const ACCELERATION = 1400.0
const FRICTION = 2000.0
const JUMP_VELOCITY = -310.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var targetDirection : Vector2

var facing_direction : int = 1

@export var side_point : Marker2D
@export var up_point : Marker2D
@export var up_side_point : Marker2D
@export var down_side_point : Marker2D
@export var down_point : Marker2D
@export var bullet : PackedScene

var gunDirName : String

var selected_point : Marker2D

var shoot_direction : Vector2

var is_shooting : bool

var can_move : bool = true
var can_shoot : bool = true

@onready var animated_sprite_2d = $PlayerSprite
@onready var gun_sprite = $GunSprite
@onready var coyotye_jump_timer = $CoyoteJumpTimer
@onready var cooldown = $Cooldown

@onready var jump_buffer_timer = $JumpBuffer
@onready var shoot_buffer_timer = $ShootBuffer
var jump_buffered : bool = false
var shoot_buffered : bool = false


func _physics_process(delta):
	if(can_move):
		select_point()
		if(cooldown.time_left == 0):
			can_shoot = true
			
		if (Input.is_action_just_pressed("Shoot") or shoot_buffered) and can_shoot:
			shoot()
		elif Input.is_action_just_pressed("Shoot") and !can_shoot:
			shoot_buffered = true
			shoot_buffer_timer.start()
			
		apply_gravity(delta)
		handle_jump()
		var input_axis = Input.get_axis("Left", "Right")
		input_axis = roundi(input_axis)
		handle_acceleration(input_axis, delta)
		apply_friction(input_axis, delta)
		update_animations(input_axis)
		var was_on_floor = is_on_floor()
		if (can_move):
			move_and_slide()
			
		var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
		if just_left_ledge:
			coyotye_jump_timer.start()
		
func shoot():
	can_shoot = false
	cooldown.start()
	is_shooting = true
	var b = bullet.instantiate()
	b.position = selected_point.global_position
	owner.add_child(b)
	b.launch(shoot_direction)

func select_point():
	var mouseDir = global_position.direction_to(get_global_mouse_position())
	targetDirection.x = roundi(mouseDir.x)
	targetDirection.y = roundi(mouseDir.y)
	if(!is_shooting):
		check_if_flip(targetDirection.x)
		if(targetDirection == Vector2.ZERO or (targetDirection.y == 0 and targetDirection.x != 0)):
			selected_point = side_point
			gunDirName = "right"
			shoot_direction = Vector2(facing_direction, 0)
		if(targetDirection.y < -0.01 and targetDirection.x == 0):
			selected_point = up_point
			gunDirName = "up"
			shoot_direction = Vector2(0, -1)
		if(targetDirection.y < -0.1 and targetDirection.x != 0):
			selected_point = up_side_point
			gunDirName = "upright"
			shoot_direction = Vector2(facing_direction, -1)
		if(targetDirection.y > 0.1 and targetDirection.x == 0):
			selected_point = down_point
			gunDirName = "down"
			shoot_direction = Vector2(0, 1)
		if(targetDirection.y > 0.1 and targetDirection.x != 0):
			selected_point = down_side_point
			gunDirName = "downright"
			shoot_direction = Vector2(facing_direction, 1)
		shoot_direction = shoot_direction.normalized()
	

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
func handle_jump():
	
	if(Input.is_action_just_pressed("Jump") and !is_on_floor()):
		jump_buffered = true
		jump_buffer_timer.start()
	if is_on_floor() or coyotye_jump_timer.time_left > 0.0:		
		if Input.is_action_just_pressed("Jump") or jump_buffered:
			velocity.y = JUMP_VELOCITY
	if not is_on_floor():
		if Input.is_action_just_released("Jump") and velocity.y < JUMP_VELOCITY/2 and !is_shooting:
			velocity.y = JUMP_VELOCITY/2
			
func apply_friction(input_axis, delta):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		
func handle_acceleration(input_axis, delta):
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, SPEED * input_axis, ACCELERATION * delta)
func check_if_flip(dir):
	if dir == -facing_direction:
		self.scale.x *= -1
		facing_direction *= -1
	
func update_animations(input_axis):
	if(!is_shooting and can_move):
		gun_sprite.play(gunDirName)
		#check_if_flip(input_axis)
		if (input_axis != 0):
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")
		if not is_on_floor():
			animated_sprite_2d.play("air")
	else:
		gun_sprite.play("shoot"+gunDirName)
		await gun_sprite.animation_finished
		is_shooting = false
		

func _on_shoot_buffer_timeout():
	shoot_buffered = false
	
func _on_jump_buffer_timeout():
	jump_buffered = false
	
