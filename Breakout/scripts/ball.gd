class_name Ball
extends RigidBody2D


signal brick_destroyed


@onready var paddle_sfx: AudioStreamPlayer = $PaddleSFX
@onready var wall_sfx: AudioStreamPlayer = $WallSFX


@export var initial_speed: float = 300.0
@export var acceleration: float = 50.0


const MAX_X_VECTOR: float = 0.75


var viewport_size: Vector2
var direction: Vector2 = Vector2.ZERO
var speed: float = initial_speed


func _ready() -> void:
	viewport_size = get_viewport_rect().size
	reset_position()


func _process(delta: float) -> void:
	var collision_data: KinematicCollision2D = move_and_collide(direction * speed * delta)
	if collision_data:
		var collider = collision_data.get_collider()
		if collider.is_in_group("paddles"):
			direction = calculate_bounce_direction(collider)
			paddle_sfx.play()
			speed += acceleration
		else:
			direction = direction.bounce(collision_data.get_normal())
			wall_sfx.play()
			if collider.is_in_group("bricks"):
				collider.queue_free()
				brick_destroyed.emit()


func reset_position() -> void:
	position.x = randf_range(viewport_size.x / 3, (viewport_size.x / 3) * 2)
	position.y = viewport_size.y / 2
	direction = random_direction()


func reset_speed() -> void:
	speed = initial_speed


func random_direction() -> Vector2:
	var new_direction: Vector2 = Vector2.ZERO
	new_direction.x = randf_range(-1.0, 1.0) * 0.5
	new_direction.y = 1
	return new_direction.normalized()


func calculate_bounce_direction(collider: Paddle) -> Vector2:
	var ball_x: float = position.x
	var paddle_x: float = collider.position.x
	var distance_x: float = ball_x - paddle_x
	var bounce_direction: Vector2 = Vector2.ZERO

	if direction.y > 0:
		bounce_direction.y = -1
	else:
		bounce_direction.y = 1
	bounce_direction.x = (distance_x / (collider.size.x / 2)) * MAX_X_VECTOR
	return bounce_direction.normalized()


func pause() -> void:
	speed = 0.0