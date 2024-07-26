extends CharacterBody3D

var max_speed = 50
var min_speed = -20
var acceleration = 0.6
var pitch_speed = 1.5
var roll_speed = 1.9
var yaw_speed = 1.25  # Set lower for linked roll/yaw
var input_response = 8.0

var Velocity = Vector3.ZERO
var forward_speed = 0
var pitch_input = 0
var roll_input = 0
var yaw_input = 0

#mining
var ready_for_mining: bool = false
var astroid
var astroid_ore
var if_in_astroid_range:bool
var begin_mine = false
var mining_multiplier = 1
var mining_progress_value = 0.0


#storage
#iron,sliver,gold,diamond
var storage = [0, 0, 0, 0]
var storage_max = [10, 10, 10, 10 ]
var max_iron = 10
var max_copper = 10
var max_gold = 10
var max_diamond = 10
# ore sell multiplier 
var iron_ore_value = 1
var copper_ore_value = 2
var gold_ore_value = 3
var diamond_ore_value = 4

#fuel var
var fuel = 0

# money/ shop
var bank = 10000
var shop_upgrade_multiplier = 1.2
var booster_upgrade_cost = 5
var storage_upgrade_cost = 5
var mine_tool_upgrade_cost = 5
var booster_level = 1
var storage_level = 1
var mine_tool_level = 1

#save data
var file
#var save_data = [storage1,2,3,4,boosterlevel,storagelevel,minetoollevel,bank]
#save_data = [storage[0],storage[1],storage[2],storage[3],booster_level,storage_level,mine_tool_level,bank]
var save_data_read = [0,0,0,0,0,0,0,0]
var save_data_write = [0,0,0,0,0,0,0,0]


@onready var mine_tool_area = $mine_tool_area
@onready var mine_tool_mesh = $mine_tool_mesh
@onready var UI = $UI

func _ready():
	save_data_read_func()
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED'
	pass

func get_input(delta):
	if Input.is_action_pressed("menu"):
		get_tree().change_scene_to_file("res://main/main_menu.tscn")
	if Input.is_action_pressed("throttle_up"):
		forward_speed = lerpf(forward_speed, max_speed, acceleration * delta)
	if Input.is_action_pressed("throttle_down"):
		forward_speed = lerpf(forward_speed, min_speed, acceleration * delta)
	if Input.is_action_pressed("stop"):
		forward_speed = lerpf(forward_speed, 0, acceleration * 4 * delta)

	pitch_input = lerpf(pitch_input,
			Input.get_action_strength("pitch_up") - Input.get_action_strength("pitch_down"),
			input_response * delta)
	roll_input = lerpf(roll_input,
			Input.get_action_strength("roll_left") - Input.get_action_strength("roll_right"),
			input_response * delta)
	yaw_input = lerpf(yaw_input,
			Input.get_action_strength("yaw_left") - Input.get_action_strength("yaw_right"),
			input_response * delta)
	if Input.is_action_just_pressed("mine") and ready_for_mining == true:
		mine()
		


func _physics_process(delta):
	#auto saving
	save_data_write_func()
	get_input(delta)
	transform.basis = transform.basis.rotated(transform.basis.z, roll_input * roll_speed * delta)
	transform.basis = transform.basis.rotated(transform.basis.x, pitch_input * pitch_speed * delta)
	transform.basis = transform.basis.rotated(transform.basis.y, yaw_input * yaw_speed * delta)
	transform.basis = transform.basis.orthonormalized()
	Velocity = -transform.basis.z * forward_speed
	move_and_collide(Velocity * delta)
	can_astroid_be_mined_check()
	update_UI()
	mining_progress_fill(1)

func update_UI():
	UI.pass_info(fuel,storage, bank, booster_upgrade_cost, storage_upgrade_cost, mine_tool_upgrade_cost, storage_max)

	#mining func
func mine():
	var mining_done = false
	begin_mine = true
	UI.mining_progress_bar_visiblity(true)
	
	
	
#handles astroid and ore
func mine_finished():
	if if_in_astroid_range == true:
		astroid_ore = astroid.pass_ore()
		print(astroid_ore)
		astroid.mined()
		storage_func("add",astroid_ore, 1)
	
	#fills progress bar and allows for mining time
func mining_progress_fill(value):
	if begin_mine == true and mining_progress_value <= 100:
		mining_progress_value += value * mining_multiplier
		UI.set_mining_progress_bar(mining_progress_value)
	if mining_progress_value >= 100:
		mine_finished()
		mining_progress_value = 0
		begin_mine = false
		UI.mining_progress_bar_visiblity(false)
		UI.set_mining_progress_bar(mining_progress_value)
	
# checks for thing like mining range and if it still has ore
func can_astroid_be_mined_check():
	if if_in_astroid_range == true:
		if astroid.is_astroid_mined_check() == false:
			ready_for_mining = true
			mine_tool_mesh.show()
		else:
			ready_for_mining = false
			mine_tool_mesh.hide()
#checks if astroid has entered mining tool area
func _on_mine_tool_area_body_entered(body):
	if body.is_in_group("astroid"):
		astroid = body.get_parent()
		if_in_astroid_range = true
		
#checks if astroid has exited mining tool area
func _on_mine_tool_area_body_exited(body):
	if body.is_in_group("astroid"):
		if_in_astroid_range = false
		mine_tool_mesh.hide()

#checks if ship has enter space station docking area
func _on_docking_area_area_entered(area):
	if area.is_in_group("docking_area"):
		docking_space_station()
	
#checks if ship has exited space station docking aera	
func _on_docking_area_area_exited(area):
	if area.is_in_group("docking_area"):
		undocking_space_station()



	
#gets called when ship enters space station area 3d
func docking_space_station():
	shop_visible(true)	
	
func undocking_space_station():
	shop_visible(false)

func shop_visible(activation):
	if activation == true:
		UI.shop_visibility(true) 
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if activation == false:
		UI.shop_visibility(false) 
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func shop(command):
	if command == "sell ore":
		storage_func("sell", "n/a", "n/a")
	if command == "upgrade booster":
		if bank >= booster_upgrade_cost:
			upgrade("booster")
			
			bank -= booster_upgrade_cost
			booster_upgrade_cost = round(booster_upgrade_cost * 1.4)
			
	if command == "upgrade minetool":
		if bank >= mine_tool_upgrade_cost and mining_multiplier !=50:
			bank -= mine_tool_upgrade_cost
			mine_tool_upgrade_cost = round(mine_tool_upgrade_cost * 1.4)
			upgrade("minetool")
			
	if command == "upgrade storage":
		if bank >= storage_upgrade_cost: 
			bank -= storage_upgrade_cost
			storage_upgrade_cost = round(storage_upgrade_cost * 1.4)
			upgrade("storage")
			



# storgage fun handles all storage add/sell
func storage_func(command, ore, amount):
	if command == "add":
		if ore == "iron":
			storage[0] += amount
			if storage[0] > storage_max[0]:
				storage[0] = storage_max[0]
		if ore == "copper":
			storage[1] += amount
			if storage[1] > storage_max[1]:
				storage[1] = storage_max[1]
		if ore == "gold":
			storage[2] += amount
			if storage[2] > storage_max[2]:
				storage[2] = storage_max[2]
		if ore == "diamond":
			storage[3] += amount
			if storage[3] > storage_max[3]:
				storage[3] = storage_max[3]
	if command == "sell":
			bank += storage[0] * iron_ore_value
			storage[0] = 0
			bank += storage[1] * copper_ore_value
			storage[1] = 0
			bank += storage[2] * gold_ore_value
			storage[2] = 0
			bank += storage[3] * diamond_ore_value
			storage[3] = 0

#this is just a func to pass from space.gd to ui.gd to hide astroid loading screen
func loading_astroids(bol):
	UI.loading_astroids(bol)

#saves data for use in game scene
func save_data_write_func():
	var file = FileAccess.open("res://" + "space_miner_save.txt", FileAccess.WRITE)
	save_data_write = [storage[0],storage[1],storage[2],storage[3],booster_level,storage_level,mine_tool_level,bank]
	#print(str(save_data_write) + "write")
	var save_string
	save_string = str(save_data_write[0]) + " " +str(save_data_write[1]) + " " +str(save_data_write[2]) + " " +str(save_data_write[3]) + " " +str(save_data_write[4]) + " " +str(save_data_write[5]) + " " +str(save_data_write[6])+ " " + str(save_data_write[7])
	file.store_string(save_string)

#used when opening game to old save
func save_data_read_func():
	var file = FileAccess.open("res://" + "space_miner_save.txt", FileAccess.READ)
	var save_data_read_array: Array
	save_data_read = file.get_as_text(true)
	if int(save_data_read) != 0:
		save_data_read_array = save_data_read.split(" ")
		for i in 8:
			save_data_read_array[i]  = int(save_data_read_array[i])
		print("save_data_read_array")
		print(save_data_read_array)
		storage[0] = save_data_read_array[0]
		storage[1] = save_data_read_array[1]
		storage[2] = save_data_read_array[2]
		storage[3] = save_data_read_array[3]
		for i in save_data_read_array[4]-1:
			upgrade("booster")
		for i in save_data_read_array[5]-1:
			upgrade("storage")
		for i in save_data_read_array[6]-1:
			upgrade("minetool")
		bank = save_data_read_array[7]

func upgrade(item):
	if item == "booster":
		max_speed = max_speed * shop_upgrade_multiplier
		booster_level += 1
	if item == "minetool":
		mining_multiplier = mining_multiplier + 1
		mine_tool_level += 1
	if item == "storage":
		storage_level += 1
		for i in len(storage_max):
			storage_max[i] = round(storage_max[i] * shop_upgrade_multiplier)
	else:
		pass
