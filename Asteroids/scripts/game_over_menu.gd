extends CanvasLayer


@onready var points_label: Label = %PointsLabel


func _ready() -> void:
	points_label.text = "POINTS: " + str(PlayerData.points)


func _on_restart_button_pressed() -> void:
	PlayerData.points = 0
	PlayerData.lives = 3

	get_tree().change_scene_to_file("res://scenes/world.tscn")
