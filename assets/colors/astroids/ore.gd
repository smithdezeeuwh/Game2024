extends Node3D

@onready var ore = $ore_mesh
# Called when the node enters the scene tree for the first time.
func _ready():
	mined()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func mined():
	ore.hide()

func unmined():
	ore.show()

