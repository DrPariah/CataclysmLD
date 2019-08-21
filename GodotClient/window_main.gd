extends Node2D
var player_node = preload( "res://Player.tscn")
onready var camera = $Camera2D
var cell_size = Vector2( 32, 32 )

func _ready():
	camera.position = $Player.position

func _process(delta):
	if manager_connection.should_update_localmap:
		$terrain_tileset.clear()
		var draw_x = null
		var draw_y = null
		# loop through the chunks finding smallest x and y for our origin draw point
		for chunk in manager_connection.localmap_chunks:
			for tile in chunk['tiles']:
				if draw_x == null: # first tile. set both because we need both.
					draw_x = tile['position']['x']
					draw_y = tile['position']['y']
				if(tile['position']['x'] < draw_x):
					draw_x = tile['position']['x']
				if(tile['position']['y'] < draw_y):
					draw_y = tile['position']['y']
		# now we have a draw_x, and draw_y origin. loop through again and draw the tiles.
		for chunk in manager_connection.localmap_chunks:
			for tile in chunk['tiles']:
				var tile_index = $terrain_tileset.get_tileset().find_tile_by_name(tile["terrain"]["ident"])
				var xy = Vector2( (tile['position']['x'] - draw_x), (tile['position']['y'] - draw_y) )
				$terrain_tileset.set_cellv( xy, tile_index )
				
		# finally set back to false until we recieve a new localmap from the server
		manager_connection.should_update_localmap = false