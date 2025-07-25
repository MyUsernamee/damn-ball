extends CharacterBody3D

signal death;

var team: bool; # False is left true is right.

var movement: Vector2;
var jumping:  bool;
var push: Vector3;

var fitness: float = 0.0;

const MOVEMENT_SPEED = 2
const GRAB_DISTANCE = 2
const PUSH_FORCE = 8 
const JUMP_VELOCITY = 4

func sense() -> Array:
	var _sense = [];

	_sense.append(get_ball_direction().x)
	_sense.append(get_ball_direction().y)
	_sense.append(get_ball_direction().z)
	_sense.append(get_ball_velocity().x)
	_sense.append(get_ball_velocity().y)
	_sense.append(get_ball_velocity().z)
	_sense.append(get_hoop_direction().x)
	_sense.append(get_hoop_direction().y)
	_sense.append(get_hoop_direction().z)

	return _sense;

func act(actions: Array):

	var move_x = actions[0];
	var move_z = actions[1];
	var jump = actions[2] > 0.5;
	var push_x = actions[3];
	var push_y = actions[4];
	var push_z = actions[5];

	do_movement(Vector2(move_x, move_z), jump, Vector3(push_x, push_y, push_z))

func get_fitness():
	return fitness

func do_movement(wish_dir: Vector2, wish_jump: bool, wish_push: Vector3):
	movement = wish_dir.limit_length()
	jumping = wish_jump
	push = wish_push.limit_length()

func do_movement_vec3(wish_dir: Vector3, wish_jump: bool, wish_push: Vector3):
	do_movement(Vector2(wish_dir.x, wish_dir.z), wish_jump, wish_push)

func get_hoop_position():
	return GameState.get_hoop(team).global_position

func get_hoop_direction():
	return GameState.get_hoop(team).global_position - global_position

func get_ball_position():
	return GameState.ball.global_position
func get_ball_direction():
	return GameState.ball.global_position - global_position

func get_ball_velocity():
	return GameState.ball.linear_velocity

func _physics_process(delta: float) -> void:

	velocity.y -= 9.8 *  delta
	velocity.x = movement.x * MOVEMENT_SPEED
	velocity.z = movement.y * MOVEMENT_SPEED

	if is_on_floor() and jumping:
		velocity.y = JUMP_VELOCITY

	if GameState.ball.global_position.distance_to(global_position) < GRAB_DISTANCE:
		GameState.ball.apply_force(push * PUSH_FORCE)

	move_and_slide()

	fitness += 1.0/get_ball_direction().length() * delta * (1.0/(get_hoop_position() - get_ball_position()).length()*delta) * 4 * (1.0/(GameState.ball.global_position.y))
