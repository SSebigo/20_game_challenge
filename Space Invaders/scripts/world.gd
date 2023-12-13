extends Node2D


@onready var player: Player = $Player
@onready var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")
@onready var bomb_scene: PackedScene = preload("res://scenes/bomb.tscn")
@onready var diamond_particle_scene: PackedScene = preload("res://scenes/effects/diamond_explosion.tscn")
@onready var lives_label: Label = $LivesLabel
@onready var points_label: Label = $PointsLabel
@onready var enemy_spawner: EnemySpawner = $EnemySpawner
@onready var player_respawn_timer: Timer = $PlayerRespawnTimer


var viewport_size: Vector2


func _ready() -> void:
	viewport_size = get_viewport_rect().size

	lives_label.text = "Lives: " + str(PlayerData.lives)
	points_label.text = "Points: " + str(PlayerData.points)


func _process(_delta: float) -> void:
	lives_label.text = "Lives: " + str(PlayerData.lives)
	points_label.text = "Points: " + str(PlayerData.points)


func _on_player_bullet_shot(player_position: Vector2) -> void:
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.position = player_position
	bullet.position.y = bullet.position.y - ((8.0 * 3.0) / 2)
	
	add_child(bullet)


func _on_projectile_garbage_area_entered(area: Area2D) -> void:
	if area is Bullet or area is Bomb:
		area.queue_free()


func _on_enemy_spawner_bomb_shot(bomb_position: Vector2) -> void:
	var bomb: Bomb = bomb_scene.instantiate()
	bomb.position = bomb_position
	bomb.position.y = bomb.position.y + ((8.0 * 3.0) / 2)
	
	add_child(bomb)


func _on_player_destroyed(player_position: Vector2) -> void:
	player.visible = false

	var effect: DiamondExplosion = diamond_particle_scene.instantiate()
	effect.position = player_position
	effect.emitting = true

	add_child(effect)

	PlayerData.lives -= 1
	
	if PlayerData.lives == 0:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	else:
		player_respawn_timer.start()


func _on_player_respawn_timer_timeout() -> void:
	player.visible = true
