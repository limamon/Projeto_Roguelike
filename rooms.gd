extends Node2D

const SPAWN_ROOMS: Array = [preload("res://Rooms/SpawnRoom0.tscn"), preload("res://Rooms/SpawnRoom1.tscn")]
const INTERMEDIATE_ROOMS: Array = [preload("res://Rooms/room0.tscn"), preload("res://Rooms/Room1.tscn"), preload("res://Rooms/Room2.tscn"), preload("res://Rooms/Room3.tscn")]
const SPECIAL_ROOMS: Array = [preload("res://Rooms/SpecialRoom0.tscn"), preload("res://Rooms/SpecialRoom1.tscn")]
const END_ROOMS: Array = [preload("res://Rooms/EndRoom0.tscn")]
const SLIME_BOSS_SCENE: PackedScene = preload("res://Rooms/BossRoom.tscn")

const TILE_SIZE: int = 16
const FLOOR_TILE_INDEX: int = 1
const RIGHT_WALL_TILE_INDEX: int = 3
const LEFT_WALL_TILE_INDEX: int = 2

@export var num_levels: int = 5

@onready var player: CharacterBody2D = get_parent().get_node("Player")


func _ready() -> void:
	SavedData.num_floor += 1
	if SavedData.num_floor == 3:
		num_levels = 3
	_spawn_rooms()


func _spawn_rooms() -> void:
	var previous_room: Node2D
	var special_room_spawned: bool = false

	for i in num_levels:
		var room: Node2D

		if i == 0:
			room = SPAWN_ROOMS[randi() % SPAWN_ROOMS.size()].instantiate()
			player.position = room.get_node("PlayerSpawnPos").position
		else:
			if i == num_levels - 1:
				room = END_ROOMS[randi() % END_ROOMS.size()].instantiate()
			else:
				if SavedData.num_floor == 3:
					room = SLIME_BOSS_SCENE.instantiate()
				else:
					if (randi() % 3 == 0 and not special_room_spawned) or (i == num_levels - 2 and not special_room_spawned):
							room = SPECIAL_ROOMS[randi() % SPECIAL_ROOMS.size()].instantiate()
							special_room_spawned = true
					else:
						room = INTERMEDIATE_ROOMS[randi() % INTERMEDIATE_ROOMS.size()].instantiate()
			
			var previous_room_tilemap: TileMapLayer = previous_room.get_node("Pisos")
			var previous_room_door: StaticBody2D = previous_room.get_node("Doors/Door")
			var exit_tile_pos: Vector2i = previous_room_tilemap.local_to_map(previous_room_door.position) + Vector2i.UP * 2

			var corridor_height: int = randi() % 5 + 2
			
			for y in corridor_height:
				previous_room_tilemap.set_cell(exit_tile_pos + Vector2i(-2, -y), LEFT_WALL_TILE_INDEX, Vector2i.ZERO)
				previous_room_tilemap.set_cell(exit_tile_pos + Vector2i(-1, -y), FLOOR_TILE_INDEX, Vector2i.ZERO)
				previous_room_tilemap.set_cell(exit_tile_pos + Vector2i(0, -y), FLOOR_TILE_INDEX, Vector2i.ZERO)
				previous_room_tilemap.set_cell(exit_tile_pos + Vector2i(1, -y), RIGHT_WALL_TILE_INDEX, Vector2i.ZERO)
			
			var tilemap_pai = previous_room_tilemap.get_parent()
			if tilemap_pai is TileMapLayer:
				tilemap_pai.updtate_internals()

			var room_tilemap: TileMapLayer = room.get_node("Pisos") # Tilemap subistuido por bloquear e trocar de variavel
			room.position = previous_room_door.global_position + Vector2.UP * room_tilemap.get_used_rect().size.y * TILE_SIZE + Vector2.UP * (1 + corridor_height) * TILE_SIZE + Vector2.LEFT * room_tilemap.local_to_map(room.get_node("Entrance/Position2D2").position).x * TILE_SIZE
			
			# parei aqui, verificar os index de cada layer
			
		add_child(room)
		previous_room = room
