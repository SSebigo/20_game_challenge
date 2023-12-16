class_name Asteroid
extends Area2D


signal destroyed(asteroid_type: AsteroidConfiguration.AsteroidType, asteroid_position: Vector2, points: int)


@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var big_collision: CollisionPolygon2D = $BigCollision
@onready var medium_collision: CollisionPolygon2D = $MediumCollision
@onready var small_collision: CollisionPolygon2D = $SmallCollision


var configuration: AsteroidConfiguration
var direction: Vector2
var speed: float
var viewport_size: Vector2


func _ready() -> void:
	viewport_size = get_viewport_rect().size

	sprite_2d.texture = configuration.sprite
	
	match configuration.type:
		AsteroidConfiguration.AsteroidType.BIG:
			big_collision.visible = true
		AsteroidConfiguration.AsteroidType.BIG:
			medium_collision.visible = true
		_:
			small_collision.visible = true


func _process(delta: float) -> void:
	position += direction * speed * delta
	
	screen_wrap()


func screen_wrap() -> void:
	position.x = wrapf(position.x, 0, viewport_size.x)
	position.y = wrapf(position.y, 0, viewport_size.y)


func _on_area_entered(area: Area2D) -> void:
	if area is Bullet:
		destroyed.emit(configuration.type, position, configuration.points)
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		PlayerData.lives -= 1
