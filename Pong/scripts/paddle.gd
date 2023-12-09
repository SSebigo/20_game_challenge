class_name Paddle
extends StaticBody2D


enum PlayerSide {LEFT,RIGHT}


@export var side: PlayerSide
@export var speed: float = 300.0


var size: Vector2
var viewport_size: Vector2


func _ready() -> void:
	size = $ColorRect.size
	viewport_size = get_viewport_rect().size


func _physics_process(delta: float) -> void:
	if (side == PlayerSide.LEFT and Input.is_action_pressed("p1_move_up")) or (side == PlayerSide.RIGHT and Input.is_action_pressed("p2_move_up")):
		position.y -= speed * delta
	if (side == PlayerSide.LEFT and Input.is_action_pressed("p1_move_down")) or (side == PlayerSide.RIGHT and Input.is_action_pressed("p2_move_down")):
		position.y += speed * delta
	
	position.y = clamp(position.y, size.y / 2, viewport_size.y - size.y / 2)
