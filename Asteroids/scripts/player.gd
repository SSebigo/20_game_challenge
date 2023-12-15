class_name Player
extends CharacterBody2D


signal bullet_shot(player_position: Vector2, player_rotation: Vector2)


@onready var shoot_timer: Timer = $ShootTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


@export var speed: float = 500.0
@export var rotation_speed: float = 2.5
@export var acceleration: float = 5.0
@export var friction: float = 1.0


var viewport_size: Vector2
var rotation_direction: float
var direction: Vector2 = Vector2.ZERO
var can_shoot: bool = true


func _ready() -> void:
	viewport_size = get_viewport_rect().size


func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot") and can_shoot:
		bullet_shot.emit(position, Vector2.UP.rotated(rotation))
		can_shoot = false
		shoot_timer.start()
	
	screen_wrap()


func _physics_process(delta: float) -> void:
	rotation_direction = Input.get_axis("rotate_left", "rotate_right")

	rotation += rotation_direction * rotation_speed * delta
	
	get_input_direction(delta)

	move_and_slide()


func get_input_direction(delta: float) -> void:
	if Input.is_action_pressed("move_forward"):
		direction = Vector2.UP.rotated(rotation)
		accelerate()
		animation_player.play("move")
	else:
		direction = Vector2.ZERO
		apply_friction()
		animation_player.play("RESET")


func accelerate() -> void:
	velocity = velocity.move_toward(direction * speed, acceleration)


func apply_friction() -> void:
	velocity = velocity.move_toward(Vector2.ZERO, friction)


func screen_wrap() -> void:
	position.x = wrapf(position.x, 0, viewport_size.x)
	position.y = wrapf(position.y, 0, viewport_size.y)


func _on_shoot_timer_timeout() -> void:
	can_shoot = true
