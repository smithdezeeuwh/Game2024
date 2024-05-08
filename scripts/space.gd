extends Node3D
@onready var astroid = load("res://object/asteroid.tscn")
var astroid_count = 0
var MAX_ASTROID_COUNT = 1000
var MAX_SPAWN_RANGE = 1000
var MIN_SPAWN_RANGE = -1000
@onready var ship = $"space ship"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if astroid_count < MAX_ASTROID_COUNT:
		spawn_astroid()
		astroid_count += 1
	else:
		ship.loading_astroids(false)#this is to hide loading screen



	
	
func spawn_astroid():
	var new_astroid = astroid.instantiate()
	new_astroid.position = Vector3(randf_range(MIN_SPAWN_RANGE, MAX_SPAWN_RANGE), randf_range(MIN_SPAWN_RANGE, MAX_SPAWN_RANGE), randf_range(MIN_SPAWN_RANGE, MAX_SPAWN_RANGE))
	add_child(new_astroid)
	new_astroid.set_ore_type()
# Called every frame. 'delta' is the elapsed time since the previous frame.

