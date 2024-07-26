extends CanvasLayer


@onready var main: Control = $Main
@onready var settings: Control = $Settings
@onready var blackjack: Control = $Blackjack
@onready var playercardslabel: Control = $Blackjack/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Player_cards_label
@onready var dealercardslabel: Control = $Blackjack/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/dealer_cards_Label
@onready var gamemessagelabel: Control = $Blackjack/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/game_message_label
@onready var banklabel:Control = $Blackjack/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/bank_label
#@onready var difficulty = $Settings/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Difficulty
@onready var map_size_label = $Settings/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MapSizeLabel
@onready var betslider: Control = $Blackjack/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/bet_slider
@onready var bet_label:Control =  $Blackjack/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/bet_label



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var file2 = FileAccess.open("res://" + "space_miner_save2.txt", FileAccess.READ)
	map_size_label.text = "Map Size: " + str(file2.get_as_text(true))
	save_data_read_func()
	

func _on_button_play_pressed():
	get_tree().change_scene_to_file("res://main/space.tscn")


func _on_button_setting_pressed():
	main.visible = false
	settings.visible = true


func _on_button_quit_pressed():
	get_tree().quit()


func _on_settings_back_pressed():
	main.visible = true
	settings.visible = false
	blackjack.visible = false
	
	



#deletes save
func _on_delete_save_pressed():
	var file = FileAccess.open("res://" + "space_miner_save.txt", FileAccess.WRITE)
	file.store_string(str(0))


func _on_data_test_pressed():
	var file = FileAccess.open("res://" + "space_miner_save.txt", FileAccess.READ)
	var save_data_read = file.get_as_text(true)
	print(save_data_read)


func _on_mapsize_value_changed(value):
	map_size_label.text = "Map Size: " + str(value)
	var file2 = FileAccess.open("res://" + "space_miner_save2.txt", FileAccess.WRITE)
	file2.store_string(str(value))



func _on_button_blackjack_pressed():
	main.visible = false
	blackjack.visible = true
	
	


	
	#################################### black jack ###################################

var deck = []
var used_cards = []
var player_card = []
var dealer_card = []
var player_score
var dealer_score
var choice = "null"
var ongoing_game = false
var new_card
var choice_loop = false
var bank 
var betsliderposition = 0
var player_bet = 0

func reset_deck():
	deck.clear()
	for i in range(10):
		for z in range(4):
			deck.append(i + 1)
	for q in range(30):
		deck.append(10)
	deck.shuffle()
	print(deck)
	
func _physics_process(delta):
	banklabel.text = "your money: $" + str(bank)
	betslider.min_value = 0
	betslider.max_value = bank
	if ongoing_game:
		betslider.set_editable(false)
	else:
		betslider.set_editable(true)

func sum(array):
	var sum = 0.0
	for element in array:
		sum += element
	return sum

func game_reset():
	game_message_text_update("game reset")
	dealer_cards_text_update("no cards")
	player_cards_text_update("no cards")
	reset_deck()
	player_card.clear()
	dealer_card.clear()
	player_card.append(deck.pop_front())
	player_card.append(deck.pop_front())
	dealer_card.append(deck.pop_front())
	dealer_card.append(deck.pop_front())
	player_score = sum(player_card)
	dealer_score = sum(dealer_card)
	player_cards_text_update(player_card)
	choice_loop = true
	ongoing_game = true

func game():
	if choice_loop:
		if player_score > 21:
			game_message_text_update("Dealer wins (Player Loss Because Player Score is exceeding 21)")
			player_bet_result("loss")
			choice_loop = false
			ongoing_game = false
			game_end()

func game_end():
	while dealer_score < 17:
		new_card = deck.pop_front()
		dealer_card.append(new_card)
		dealer_score += new_card
	ongoing_game = false
	choice_loop = false
	dealer_cards_text_update(dealer_card)
	if player_score <= 21:
		if dealer_score > 21:
			game_message_text_update("Player wins (Dealer Loss Because Dealer Score is exceeding 21)")
			player_bet_result("win")
		elif player_score > dealer_score:
			game_message_text_update("Player wins (Player Has Higher Score than Dealer)")
			player_bet_result("win")
		elif dealer_score > player_score:
			game_message_text_update("Dealer wins (Dealer Has Higher Score than Player)")
			player_bet_result("loss")
		else:
			game_message_text_update("It's a tie.")
			player_bet_result("tie")
	save_data_write_func()  # Ensure the data is saved after each game

func _on_button_hit_pressed():
	if not ongoing_game:
		save_data_read_func()
		game_reset()
		ongoing_game = true
	else:
		if choice_loop:
			new_card = deck.pop_front()
			player_card.append(new_card)
			player_score = sum(player_card)
			player_cards_text_update(player_card)
			if player_score > 21:
				game_message_text_update("Dealer wins (Player Loss Because Player Score is exceeding 21)")
				player_bet_result("loss")
				choice_loop = false
				ongoing_game = false
				game_end()
				save_data_write_func()  # Ensure the data is saved after a loss

func _on_button_stop_pressed():
	if choice_loop:
		game_end()

func game_message_text_update(text):
	playercardslabel.text = str(text)

func dealer_cards_text_update(text):
	dealercardslabel.text = "dealer cards: " + str(text)

func player_cards_text_update(text):
	gamemessagelabel.text = "Player cards: " + str(text)

func bet_start(bet):
	player_bet = bet
	bank -= bet

func player_bet_result(action):
	if action == "win":
		bank += 2 * player_bet
	elif action == "loss":
		pass
	elif action == "tie":
		bank += player_bet

func save_data_read_func():
	var file = FileAccess.open("res://space_miner_save.txt", FileAccess.READ)
	if file:
		var save_data_read = file.get_as_text()
		var save_data_read_array: Array = save_data_read.split(" ")
		if save_data_read_array.size() == 8:
			bank = int(save_data_read_array[7])
		file.close()

func _on_bet_slider_value_changed(value):
	betsliderposition = value
	bet_label.text = "your bet: $" + str(betsliderposition)

func save_data_write_func():
	var file = FileAccess.open("res://space_miner_save.txt", FileAccess.WRITE)
	var save_string = "0 0 0 0 0 0 0 " + str(bank)
	file.store_string(save_string)
	file.close()
