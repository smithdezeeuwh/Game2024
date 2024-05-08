extends CanvasLayer


@onready var main: Control = $Main
@onready var settings: Control = $Settings
@onready var difficulty = $Settings/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Difficulty
@onready var map_size_label = $Settings/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MapSizeLabel

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

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
	



#deletes save
func _on_delete_save_pressed():
	var file = FileAccess.open("user://" + "space_miner_save.txt", FileAccess.WRITE)
	file.store_string(str(0))


func _on_data_test_pressed():
	var file = FileAccess.open("user://" + "space_miner_save.txt", FileAccess.READ)
	var save_data_read = file.get_as_text(true)
	print(save_data_read)


func _on_mapsize_value_changed(value):
	map_size_label.text = "Map Size: " + str(value)
