class_name Paddle
extends StaticBody2D


@export var speed: float = 300.0


var size: Vector2
var viewport_size: Vector2


func _ready() -> void:
	size = $ColorRect.size
	viewport_size = get_viewport_rect().size


func _process(delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		position.x -= speed * delta
	if Input.is_action_pressed("move_right"):
		position.x += speed * delta
	
	position.x = clamp(position.x, size.x / 2, viewport_size.x - size.x / 2)


func pause() -> void:
	speed = 0.0