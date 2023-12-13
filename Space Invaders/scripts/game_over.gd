extends CanvasLayer


@onready var points_label: Label = %PointsLabel
@onready var lives_label: Label = %LivesLabel
@onready var state: Label = $MarginContainer/VBoxContainer/State
@onready var button: Button = $MarginContainer/VBoxContainer/Button


func _ready() -> void:
	points_label.text = ": " + str(PlayerData.points) + " POINTS"
	lives_label.text = ": " + str(PlayerData.lives) + " LIVES"
	
	if PlayerData.lives == 0:
		state.text = "GAME OVER"
		button.text = "RESTART"
	else:
		state.text = "CONGRATULATIONS"
		button.text = "CONTINUE"


func _on_button_pressed() -> void:
	if PlayerData.lives == 0:
		PlayerData.lives = 3

	get_tree().change_scene_to_file("res://scenes/world.tscn")
