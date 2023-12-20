extends Node2D


@onready var tile_map: TileMap = $TileMap
@onready var generation_timer: Timer = $GenerationTimer
@onready var camera_2d: Camera2D = $Camera2D
@onready var generation_label: Label = $HUD/MarginContainer/GenerationLabel


const SIZE: Vector2i = Vector2i(256, 256)
const NEIGHBORS_DIRECTION: Array[TileSet.CellNeighbor] = [
	TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER,
	TileSet.CELL_NEIGHBOR_TOP_SIDE,
	TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER,
	TileSet.CELL_NEIGHBOR_LEFT_SIDE,
	TileSet.CELL_NEIGHBOR_RIGHT_SIDE,
	TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER,
	TileSet.CELL_NEIGHBOR_BOTTOM_SIDE,
	TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER
]


var tmp_map: Array = []
var generation: int = 1
var is_playing: bool = false


func _ready() -> void:
	generation_label.text = "GENERATION: " + str(generation)

	for i in SIZE.x:
		var row: Array = []
		for j in SIZE.x:
			row.append(Vector2i(1, 0))
		tmp_map.append(row)


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("start"):
		is_playing = true
	
	if Input.is_action_pressed("pause"):
		generation_timer.stop()
		is_playing = false

	if Input.is_action_pressed("left_click"):
		var cell_coordinates := tile_map.local_to_map(get_global_mouse_position())
		tile_map.set_cell(0, cell_coordinates, 1, Vector2i(0, 0))

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP):
		zoom_camera(-0.1, get_global_mouse_position())
		#camera_2d.zoom -= Vector2(.1, .1)
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN):
		zoom_camera(0.1, get_global_mouse_position())
		#camera_2d.zoom += Vector2(.1, .1)
		#camera_2d.zoom = camera_2d.zoom.clamp(Vector2(0, 0), Vector2(2, 2))



func _process(delta: float) -> void:
	if is_playing:
		update_field()
		is_playing = false
		generation_timer.start()


func _on_generation_timer_timeout() -> void:
	generation += 1
	generation_label.text = "GENERATION: " + str(generation)

	is_playing = true


func update_field() -> void:
	for i in SIZE.x:
		for j in SIZE.y:
			var is_alive: bool = tile_map.get_cell_atlas_coords(0, Vector2i(i, j)) == Vector2i(0, 0)
			var alive_neighbors: int = 0
			for direction in NEIGHBORS_DIRECTION:
				var neighbor_coordinates := tile_map.get_neighbor_cell(Vector2i(i, j), direction)
				var neighbor_is_alive: bool = tile_map.get_cell_atlas_coords(0, neighbor_coordinates) == Vector2i(0, 0)

				if neighbor_is_alive:
					alive_neighbors += 1
			
			if is_alive:
				if alive_neighbors in [2, 3]:
					tmp_map[i][j] = Vector2i(0, 0)
				else:
					tmp_map[i][j] = Vector2i(1, 0)
			else:
				if alive_neighbors == 3:
					tmp_map[i][j] = Vector2i(0, 0)
				else:
					tmp_map[i][j] = Vector2i(1, 0)

	for i in SIZE.x:
		for j in SIZE.y:
			tile_map.set_cell(0, Vector2i(i, j), 1, tmp_map[i][j])


func zoom_camera(zoom_factor, mouse_position):
	var viewport_size = get_viewport().size
	var previous_zoom = camera_2d.zoom
	camera_2d.zoom += camera_2d.zoom * zoom_factor
	camera_2d.zoom = camera_2d.zoom.clamp(Vector2(0, 0), Vector2(2, 2))	
	camera_2d.offset += ((viewport_size * 0.5) - mouse_position) * (camera_2d.zoom - previous_zoom)
