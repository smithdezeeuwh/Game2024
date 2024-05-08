extends Node2D
@onready var marker = $marker
var cam
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	print("exit")
	marker.hide()


func _on_visible_on_screen_notifier_2d_screen_entered():
	marker.show()
