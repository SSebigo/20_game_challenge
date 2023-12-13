class_name Bomb
extends Area2D


@export var speed: float = 300.0


func _process(delta: float) -> void:
	position += Vector2.DOWN * speed * delta


func _on_area_entered(area: Area2D) -> void:
	if area is Player or area is Bullet:
		queue_free()
