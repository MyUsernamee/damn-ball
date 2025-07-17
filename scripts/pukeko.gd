extends CharacterBody3D

var team: bool; # False is left true is right.

var movement: Vector2;
var jumping:  bool;
var push: Vector3;

const MOVEMENT_SPEED = 2
const GRAB_DISTANCE = 2
const PUSH_FORCE = 8 
const JUMP_VELOCITY = 4

func do_movement(wish_dir: Vector2, wish_jump: bool, wish_push: Vector3):
	movement = wish_dir.normalized()
	jumping = wish_jump
	push = wish_push.limit_length()

func do_movement_vec3(wish_dir: Vector3, wish_jump: bool, wish_push: Vector3):
	do_movement(Vector2(wish_dir.x, wish_dir.z), wish_jump, wish_push)

func get_hoop_direction():
	return GameState.get_hoop(team).global_position - global_position

func get_ball_direction():
	return GameState.ball.global_position - global_position

func get_ball_velocity():
	return GameState.ball.linear_velocity

func _physics_process(delta: float) -> void:
	do_movement_vec3(get_hoop_direction(), true, Vector3.UP)

	velocity.y -= 9.8 *  delta
	velocity.x = movement.x * MOVEMENT_SPEED
	velocity.z = movement.y * MOVEMENT_SPEED

	if is_on_floor() and jumping:
		velocity.y = JUMP_VELOCITY

	if GameState.ball.global_position.distance_to(global_position) < GRAB_DISTANCE:
		GameState.ball.apply_force(push * PUSH_FORCE)

	move_and_slide()
