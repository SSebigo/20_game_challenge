extends CanvasLayer


@onready var invader_brown_texture: TextureRect = %InvaderBrownTexture
@onready var invader_brown_label: Label = %InvaderBrownLabel
@onready var invader_green_texture: TextureRect = %InvaderGreenTexture
@onready var invader_green_label: Label = %InvaderGreenLabel
@onready var invader_red_texture: TextureRect = %InvaderRedTexture
@onready var invader_red_label: Label = %InvaderRedLabel
@onready var invader_yellow_texture: TextureRect = %InvaderYellowTexture
@onready var invader_yellow_label: Label = %InvaderYellowLabel
@onready var invaders_timer: Timer = $InvadersTimer


var control_array: Array[Control] = []


func _ready() -> void:
	control_array.append_array([
		invader_brown_texture,
		invader_brown_label,
		invader_green_texture,
		invader_green_label,
		invader_red_texture,
		invader_red_label,
		invader_yellow_texture,
		invader_yellow_label,
	])
	
	for control in control_array:
		control.modulate = Color.TRANSPARENT


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_invaders_timer_timeout() -> void:
	var control: Control = control_array.pop_front()
	if control != null:
		control.modulate = Color.WHITE
	else:
		invaders_timer.stop()
