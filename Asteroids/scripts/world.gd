extends Node2D


@onready var player: Player = $Player
@onready var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")
@onready var lives_label: Label = $LivesLabel
@onready var points_label: Label = $PointsLabel


func _ready() -> void:
	lives_label.text = "LIVES: " + str(PlayerData.lives)
	points_label.text = "POINTS: " + str(PlayerData.points)


func _process(_delta: float) -> void:
	lives_label.text = "LIVES: " + str(PlayerData.lives)
	points_label.text = "POINTS: " + str(PlayerData.points)


func _on_player_bullet_shot(player_position: Vector2, player_rotation: Vector2) -> void:
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.position = player_position
	bullet.direction = player_rotation
	
	add_child(bullet)
