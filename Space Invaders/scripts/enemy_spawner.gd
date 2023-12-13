class_name EnemySpawner
extends Node2D


signal bomb_shot(position: Vector2)


@onready var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
@onready var bomb_scene: PackedScene = preload("res://scenes/bomb.tscn")
@onready var diamond_particle_scene: PackedScene = preload("res://scenes/effects/diamond_explosion.tscn")
@onready var movement_timer: Timer = $MovementTimer


const ROWS: int = 5
const COLUMNS: int = 11
const ENEMY_SIZE: Vector2i = Vector2i(8, 8)
const HORIZONTAL_SPACING: int = 20
const VERTICAL_SPACING: int = 15
const Y_START_POSITION: int = 24
const X_INCREMENT: int = 15
const Y_INCREMENT: int = 15


var direction: Vector2 = Vector2(1, 0)
var max_timer_wait_time: float = 0.50
var min_timer_wait_time: float = 0.10
var timer_decrement: float


func _ready() -> void:
	timer_decrement = (max_timer_wait_time - min_timer_wait_time) / (ROWS * COLUMNS)
	var enemy_brown_resource: Resource = preload("res://resources/enemy_brown.tres")
	var enemy_green_resource: Resource = preload("res://resources/enemy_green.tres")
	var enemy_red_resource: Resource = preload("res://resources/enemy_red.tres")
	var enemy_yellow_resource: Resource = preload("res://resources/enemy_yellow.tres")
	
	var enemy_configuration: EnemyConfiguration
	
	for i in ROWS:
		if i == 0:
			enemy_configuration = enemy_yellow_resource
		elif i == 1:
			enemy_configuration = enemy_red_resource
		elif i == 2:
			enemy_configuration = enemy_green_resource
		else:
			enemy_configuration = enemy_brown_resource
	
		var row_width: float = (COLUMNS * (ENEMY_SIZE.x * 3)) + ((COLUMNS - 1) * HORIZONTAL_SPACING)
		var x_start_position: float = (global_position.x - (row_width * 2)) / 2
		
		for j in COLUMNS:
			var enemy_position: Vector2 = Vector2.ZERO
			
			enemy_position.x = x_start_position + (j * (ENEMY_SIZE.x * 3)) + (j * HORIZONTAL_SPACING)
			enemy_position.y = Y_START_POSITION + (i * (ENEMY_SIZE.y * 3)) + (i * VERTICAL_SPACING)
			
			spawn_enemy(enemy_configuration, enemy_position)


func spawn_enemy(configuration: EnemyConfiguration, enemy_position: Vector2) -> void:
	var enemy: Enemy = enemy_scene.instantiate()

	enemy.configuration = configuration
	enemy.destroyed.connect(on_enemy_destroyed)
	enemy.position = enemy_position

	add_child(enemy)


func _on_walls_area_entered(area: Area2D) -> void:
	if area is Enemy:
		if direction.y == 0:
			direction.y = 1


func _on_movement_timer_timeout() -> void:
	if direction.y == 1:
		position.y += direction.y * Y_INCREMENT
		direction.y = 0
		direction.x *= -1
	else:
		position.x += direction.x * X_INCREMENT


func on_enemy_destroyed(enemy_position: Vector2, points: int) -> void:
	var effect: DiamondExplosion = diamond_particle_scene.instantiate()
	effect.position = enemy_position
	effect.emitting = true

	add_child(effect)

	PlayerData.points += points
	movement_timer.wait_time -= timer_decrement


func _on_shoot_timer_timeout() -> void:
	var enemies: Array = get_children().filter(func (child): return child is Enemy)
	
	if not enemies.is_empty():
		var random_position: Vector2 = enemies.map(func (enemy): return enemy.global_position).pick_random()

		bomb_shot.emit(random_position)
	else:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
