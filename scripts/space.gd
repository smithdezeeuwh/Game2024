extends Node3D
@onready var astroid = load("res://object/asteroid.tscn")
@onready var station = load("res://object/space_station.tscn")
var astroid_count = 0
var MAX_ASTROID_COUNT = 1
var MAX_SPAWN_RANGE = 200
var MIN_SPAWN_RANGE = -200
@onready var ship = $"space ship"
var map_size
# Called when the node enters the scene tree for the first time.
func _ready():
	var file2 = FileAccess.open("res://" + "space_miner_save2.txt", FileAccess.READ)
	print(str(file2.get_as_text(true)))
	var map_size = int(file2.get_as_text(true))
	MAX_ASTROID_COUNT = MAX_ASTROID_COUNT * (10** map_size)
	MAX_SPAWN_RANGE = MAX_SPAWN_RANGE * map_size
	MIN_SPAWN_RANGE = MIN_SPAWN_RANGE * map_size
	for i in MAX_ASTROID_COUNT:
		spawn_astroid()
	ship.loading_astroids(false)
	for i in map_size:
		spawn_station()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	



	
	
func spawn_astroid():
	var new_astroid = astroid.instantiate()
	new_astroid.position = Vector3(randf_range(MIN_SPAWN_RANGE, MAX_SPAWN_RANGE), randf_range(MIN_SPAWN_RANGE, MAX_SPAWN_RANGE), randf_range(MIN_SPAWN_RANGE, MAX_SPAWN_RANGE))
	add_child(new_astroid)
	new_astroid.set_ore_type()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func spawn_station():
	var new_station = station.instantiate()
	new_station.position = Vector3(randf_range(MIN_SPAWN_RANGE, MAX_SPAWN_RANGE), randf_range(MIN_SPAWN_RANGE, MAX_SPAWN_RANGE), randf_range(MIN_SPAWN_RANGE, MAX_SPAWN_RANGE))
	add_child(new_station)
	
