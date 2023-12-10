class_name GameOverLayout
extends ColorRect


@onready var score_label: Label = $Score


func set_score(score: int) -> void:
	score_label.text = "Score: " + str(score)
