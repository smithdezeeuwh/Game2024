extends "res://scripts/ship.gd"
class_name Quest

@export_group("quest properties")
@export var quest_name: String = ""
@export var quest_type: String = "" 
@export var quest_completed: bool = false
__init__(self, quest_name, quest_type):

