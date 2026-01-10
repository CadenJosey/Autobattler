extends Node2D

@onready var tile_map = $TileMap
const GRID_WIDTH = 20
const GRID_HEIGHT = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	_generate_grid()
	_spawn_house()
	_spawn_kitty()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _generate_grid():
	for i in GRID_WIDTH:
		for j in GRID_HEIGHT:
			var grass_coords = [Vector2i(5, 0), Vector2i(6, 0), Vector2i(7, 0), Vector2i(0, 2)]
			var is_grass = randi_range(0, 3) # 25% chance for any tile to be grass
			
			if is_grass == 3:
				tile_map.set_cell(0, Vector2i(i, j), 0, grass_coords.pick_random())
			else:
				tile_map.set_cell(0, Vector2i(i, j), 0, Vector2i(0, 0))

func _spawn_kitty():
	var kitty_pos = Vector2i(randi_range(0, GRID_WIDTH-1), randi_range(0, GRID_HEIGHT-1))
	tile_map.set_cell(0, kitty_pos, 0, Vector2i(30, 7))

func _spawn_house():
	var x = randi_range(0, GRID_WIDTH-3)
	var y = randi_range(0, GRID_HEIGHT-3)
	var width = randi_range(3, 10)
	var height = randi_range(3, 10)
	
	# Try again if the house would be out of bounds
	if x + width > GRID_WIDTH - 1 or y + height > GRID_HEIGHT - 1:
		#print("retry")
		_spawn_house()
		return
	
	for i in width:
		for j in height:
			if i == 0 or j == 0 or i == width-1 or j == height-1:
				tile_map.set_cell(0, Vector2i(x + i, y + j), 0, Vector2i(6, 13))
