extends CanvasLayer

@onready var fuel_text = $MarginContainer/fuel
@onready var storage_text = $MarginContainer/storage
@onready var bank_text = $MarginContainer/bank
@onready var mining_progress_bar = $MarginContainer_progressbar/ProgressBar
@onready var shop = $shop
@onready var shop_text = $shop/MarginContainer_shop_buttons/Message
@onready var ship = get_parent()
@onready var mine_tool_button =$shop/MarginContainer_shop_buttons/upgrade_minetool
@onready var storage_button =$shop/MarginContainer_shop_buttons/upgrade_storage
@onready var booster_button =$shop/MarginContainer_shop_buttons/upgrade_booster
@onready var loading_screen = $loading_screen


#just values to be passed for ui 
var fuel
	#iron,sliver,gold,diamond
var storage = [0, 0, 0, 0]
var bank
var booster_upgrade_cost
var storage_upgrade_cost
var mine_tool_upgrade_cost
var storage_max	
#mining bar progress start
var begin_mine = false
var mining_multiplier = 1.0
# Called when the node enters the scene tree for the first time.
func _ready():
	mining_progress_bar.hide()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	upadate_text()
	update_screen_size()
	
func pass_info(fuel_pass, storage_pass, bank_pass,a, b, c, d):
	fuel = fuel_pass
	storage = storage_pass
	bank = bank_pass
	booster_upgrade_cost = a
	storage_upgrade_cost = b
	mine_tool_upgrade_cost = c
	storage_max = d

func upadate_text():
	fuel_text.text = str(fuel) + "        "
	storage_text.text = "   IRON:" + str(storage[0]) + "/" + str(storage_max[0])+"  COPPER:" + str(storage[1]) + "/" + str(storage_max[0])+"  GOLD:" + str(storage[2]) + "/" + str(storage_max[0])	+"  DIAMOND:" + str(storage[3]) + "/" + str(storage_max[0])
	
	bank_text.text = "bank:" + str(bank)
	booster_button.text = "booster upgrade:" + str(booster_upgrade_cost)
	storage_button.text = "storage upgrade:" + str(storage_upgrade_cost)
	mine_tool_button.text = "mine tool upgrade;" + str(mine_tool_upgrade_cost)

		
func set_mining_progress_bar(value):
	mining_progress_bar.value = value

func mining_progress_bar_visiblity(visible):
	if visible == true:
		mining_progress_bar.show()
	else:
		mining_progress_bar.hide()

func shop_visibility(bool):
	if bool == true:
		shop.show()
	else:
		shop.hide()
func update_screen_size():
	#print(str(DisplayServer.window_get_size().x))
	pass#might do later if i feel like it >;^)
	


func _on_upgrade_minetool_button_down():
	ship.shop("upgrade minetool")

func _on_upgrade_storage_button_down():
	ship.shop("upgrade storage")

func _on_upgrade_booster_button_down():
	ship.shop("upgrade booster")

func update_shop_text(text):
	shop_text.text = str(text)


func _on_sell_ore_button_down():
	ship.shop("sell ore")

func loading_astroids(bol):
	if bol == true:
		loading_screen.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		loading_screen.hide()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func _on_skip_loading_pressed():
	loading_astroids(false)
