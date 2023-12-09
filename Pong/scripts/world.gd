class_name World
extends Node2D

@onready var score_left: Label = $ScoreLeft
@onready var score_right: Label = $ScoreRight
@onready var ball_timer: Timer = $BallTimer
@onready var score_sfx: AudioStreamPlayer2D = $ScoreSFX


var ball: Ball
var score: Array = [0, 0]


func _ready() -> void:
	ball = preload("res://scenes/ball.tscn").instantiate()
	add_child(ball)


func _on_left_goal_body_entered(_body: Node2D) -> void:
	score[1] += 1
	score_right.text = str(score[1])
	score_sfx.play()
	start_ball_timer()


func _on_right_goal_body_entered(_body: Node2D) -> void:
	score[0] += 1
	score_left.text = str(score[0])
	score_sfx.play()
	start_ball_timer()


func start_ball_timer() -> void:
	ball_timer.start()


func _on_ball_timer_timeout() -> void:
	ball.reset_speed()
	ball.reset_position()
