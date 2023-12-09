class_name Ball
extends RigidBody2D


@onready var paddle_sfx: AudioStreamPlayer = $PaddleSFX
@onready var wall_sfx: AudioStreamPlayer = $WallSFX


@export var initial_speed: float = 300.0
@export var acceleration: float = 50.0


const MAX_Y_VECTOR: float = 0.6


var viewport_size: Vector2
var direction: Vector2 = Vector2.ZERO
var speed: float = initial_speed


func _ready() -> void:
	viewport_size = get_viewport_rect().size
	reset_position()

	direction = random_direction()


func _process(delta: float) -> void:
	var collision_data = move_and_collide(direction * speed * delta)
	if collision_data:
		var collider = collision_data.get_collider()
		if collider.is_in_group("paddles"):
			direction = calculate_bounce_direction(collider)
			speed += acceleration
			paddle_sfx.play()
		else:
			direction = direction.bounce(collision_data.get_normal())
			wall_sfx.play()


func reset_position() -> void:
	position.x = viewport_size.x / 2
	if [-1, 1].pick_random() == -1:
		position.y = randf_range(50, viewport_size.y / 3)
	else:
		position.y = randf_range((viewport_size.y / 3) * 2, viewport_size.y - 50)


func random_direction() -> Vector2:
	var new_direction: Vector2 = Vector2.ZERO
	new_direction.x = [-1, 1].pick_random()
	new_direction.y = randf_range(-1, 1)
	return new_direction.normalized()


func reset_speed():
	speed = initial_speed


func calculate_bounce_direction(collider: Paddle) -> Vector2:
	var ball_y: float = position.y
	var paddle_y: float = collider.position.y
	# if distance y > 0 ball touching upper part of paddle else bottom
	var distance_y: float = ball_y - paddle_y
	var bounce_direction: Vector2 = Vector2.ZERO
	
	# change direction after collision
	if direction.x > 0:
		bounce_direction.x = -1
	else:
		bounce_direction.x = 1
	bounce_direction.y = (distance_y / (collider.size.y / 2)) * MAX_Y_VECTOR
	return bounce_direction.normalized()
