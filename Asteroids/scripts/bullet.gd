class_name Bullet
extends Area2D


@onready var timer: Timer = $Timer


@export var speed: float = 750.0


var direction: Vector2


func _process(delta: float) -> void:
	position += direction * speed * delta


func _on_timer_timeout() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is Asteroid:
		queue_free()
