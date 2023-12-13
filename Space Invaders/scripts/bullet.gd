class_name Bullet
extends Area2D


@export var speed: float = 300.0


func _process(delta: float) -> void:
	position += Vector2.UP * speed * delta


func _on_area_entered(area: Area2D) -> void:
	if area is Enemy or area is Bomb:
		queue_free()
