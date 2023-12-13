class_name Enemy
extends Area2D


signal destroyed(position: Vector2, points: int)


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var explosion_sfx: AudioStreamPlayer = $ExplosionSFX


var configuration: EnemyConfiguration


func _ready() -> void:
	animated_sprite_2d.animation = configuration.animation
	animated_sprite_2d.play(configuration.animation)


func _on_area_entered(area: Area2D) -> void:
	if area is Bullet:
		explosion_sfx.play()
		destroyed.emit(position, configuration.points)
		visible = false


func _on_explosion_sfx_finished() -> void:
	queue_free()
