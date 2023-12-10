extends Node2D


enum State { GAME_OVER, PLAYING, PAUSED }


@onready var player: Paddle = $Player
@onready var game_over_layout: GameOverLayout = $GameOverLayout
@onready var lives_label: Label = $Lives
@onready var damage_sfx: AudioStreamPlayer = $DamageSFX


const COLUMNS: int = 16
const ROWS: int = 8


var ball: Ball
var bricks: Array
var state: State = State.PLAYING
var score: int = 0
var lives: int = 3


func _ready() -> void:
	lives_label.text = "Lives: " + str(lives)

	ball = preload("res://scenes/ball.tscn").instantiate()
	ball.brick_destroyed.connect(_on_brick_destroyed)
	add_child(ball)

	var viewport_size: Vector2 = get_viewport_rect().size

	var brick: PackedScene = preload("res://scenes/brick.tscn")
	var start: Vector2 = Vector2((viewport_size.x - COLUMNS * 70 - (COLUMNS - 1) * 5) / 2, 50)

	for row in range(ROWS):
		for column in range(COLUMNS):
			var brick_instance = brick.instantiate()
			brick_instance.position = Vector2(start.x + column * (70 + 5), start.y + row * 30)
			brick_instance.add_to_group("bricks")
			add_child(brick_instance)
			bricks.append(brick_instance)


func _process(_delta: float) -> void:
	if state == State.PLAYING:
		if lives == 0:
			state = State.GAME_OVER
			game_over_layout.set_score(score)
			game_over_layout.visible = true
			player.pause()
			ball.pause()

			# make everything thing invisible
			ball.visible = false
			for brick in get_tree().get_nodes_in_group("bricks"):
				brick.visible = false


func _on_damage_area_body_entered(body:Node2D) -> void:
	damage_sfx.play()
	if body is Ball:
		body.reset_position()
		body.reset_speed()
		lives -= 1
		lives_label.text = "Lives: " + str(lives)


func _on_brick_destroyed() -> void:
	score += 1
