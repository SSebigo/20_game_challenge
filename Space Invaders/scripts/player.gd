class_name Player
extends Area2D


signal bullet_shot(position: Vector2)
signal destroyed(position: Vector2)


@onready var sprite: Sprite2D = $Sprite2D
@onready var bullet_timer: Timer = $BulletTimer
@onready var laser_sfx: AudioStreamPlayer = $LaserSFX
@onready var explosion_sfx: AudioStreamPlayer = $ExplosionSFX


@export var speed: float = 300.0


var sprite_size: Vector2 = Vector2.ZERO
var viewport_size: Vector2 = Vector2.ZERO
var can_shoot: bool = true


func _ready() -> void:
	sprite_size = sprite.get_rect().size * scale
	viewport_size = get_viewport_rect().size


func _process(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO

	if Input.is_action_pressed("move_left"):
		direction.x = -1
	elif Input.is_action_pressed("move_right"):
		direction.x = 1
	
	if Input.is_action_just_pressed("shoot") and can_shoot:
		bullet_shot.emit(position)
		laser_sfx.play()
		can_shoot = false
		bullet_timer.start()
	
	position.x += direction.x * speed * delta
	position.x = clamp(position.x, 0 + sprite_size.x / 2, viewport_size.x - sprite_size.x / 2)


func _on_bullet_timer_timeout() -> void:
	can_shoot = true


func _on_area_entered(area: Area2D) -> void:
	if area is Bomb:
		explosion_sfx.play()
		destroyed.emit(position)
