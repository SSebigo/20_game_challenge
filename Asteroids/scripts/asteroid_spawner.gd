class_name AsteroidSpawner
extends Node2D


@onready var big_asteroid_resource: Resource = preload("res://resources/big_asteroid.tres")
@onready var medium_asteroid_resource: Resource = preload("res://resources/medium_asteroid.tres")
@onready var small_asteroid_resource: Resource = preload("res://resources/small_asteroid.tres")
@onready var asteroid_scene: PackedScene = preload("res://scenes/asteroid.tscn")
@onready var explosion_vfx_scene: PackedScene = preload("res://scenes/effects/explosion_vfx.tscn")


const MAX_ASTEROIDS_PER_ROUND: int = 20
const MIN_ASTEROID_SPEED: float = 100.0
const MAX_ASTEROID_SPEED: float = 200.0


var astroids_in_round: int = 5


func _ready() -> void:
	create_asteroids(big_asteroid_resource, astroids_in_round)


func _process(delta: float) -> void:
	var asteroids: Array = get_children().filter(func (child): return child is Asteroid)
	
	if asteroids.is_empty():
		astroids_in_round += 1
		create_asteroids(big_asteroid_resource, astroids_in_round)


func on_asteroid_destroyed(asteroid_type: AsteroidConfiguration.AsteroidType, asteroid_position: Vector2, points: int) -> void:
	var effect: ExplosionVFX = explosion_vfx_scene.instantiate()
	effect.position = asteroid_position
	effect.emitting = true
	
	add_child(effect)

	match asteroid_type:
		AsteroidConfiguration.AsteroidType.BIG:
			create_asteroids(medium_asteroid_resource, 2, asteroid_position)
		AsteroidConfiguration.AsteroidType.MEDIUM:
			create_asteroids(small_asteroid_resource, 2, asteroid_position)
		_:
			pass
	
	PlayerData.points += points


func create_asteroids(resource: Resource, number_of_asteroids: int, asteroid_position: Vector2 = Vector2()) -> void:
	for i in range(number_of_asteroids):
		var asteroid: Asteroid = asteroid_scene.instantiate()
		asteroid.configuration = resource
		asteroid.position = asteroid_position
		asteroid.speed = randf_range(MIN_ASTEROID_SPEED, MAX_ASTEROID_SPEED)
		asteroid.rotation = randf_range(-180, 180)
		asteroid.direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
		
		asteroid.destroyed.connect(on_asteroid_destroyed)
		
		call_deferred("add_child", asteroid)
