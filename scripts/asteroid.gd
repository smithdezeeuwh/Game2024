extends Node3D

@onready var ore = $ore_mesh
@onready var ore_mesh_items : Array = [$ore_mesh/ore, $ore_mesh/ore2, $ore_mesh/ore3, $ore_mesh/ore4, $ore_mesh/ore5, $ore_mesh/ore6]
@export var astroid_ore_type = ""
var is_astroid_mined:bool

#ore color stuf
var iron = preload("res://assets/colors/iron_color.tres")
var copper = preload("res://assets/colors/copper_color.tres")
var gold = preload("res://assets/colors/gold_color.tres")
var diamond = preload("res://assets/colors/diamond_color.tres")





# Called when the node enters the scene tree for the first time.
func _ready():
	set_ore_type()
	unmined()
	color_set()
	#sets color of ore when spawned
	
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	color_set()
	
#called when astroid is mined
func mined():
	ore.hide()
	is_astroid_mined = true

func unmined():
	ore.show()
	is_astroid_mined = false
	
	#passes astroid ore type to ship script
func pass_ore():
	return astroid_ore_type
	#passes the state of astroid ore avaiblitty to ship script
func is_astroid_mined_check():
	return is_astroid_mined
	
func color_set():
	if astroid_ore_type == "iron":
		for j_index in range(ore_mesh_items.size()):
			ore_mesh_items[j_index].set_surface_override_material(0, iron)
	if astroid_ore_type == "copper":
		for j_index in range(ore_mesh_items.size()):
			ore_mesh_items[j_index].set_surface_override_material(0, copper)
	if astroid_ore_type == "gold":
		for j_index in range(ore_mesh_items.size()):
			ore_mesh_items[j_index].set_surface_override_material(0, gold)
	if astroid_ore_type == "diamond":
		for j_index in range(ore_mesh_items.size()):
			ore_mesh_items[j_index].set_surface_override_material(0, diamond)
	

func set_ore_type():
	var x
	if astroid_ore_type != "":
		x = round(randf_range(0,100))
		if x < 10:
			astroid_ore_type = "diamond"
		if x > 10 and x < 25:
			astroid_ore_type = "gold"
		if x > 25 and x < 50:
			astroid_ore_type = "copper"
		if x > 50 and x < 100:
			astroid_ore_type = "iron"
