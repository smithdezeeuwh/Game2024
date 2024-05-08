extends Node3D
@onready var marker = $origin/marker
var cam
# Called when the node enters the scene tree for the first time.
func _ready():
	cam = get_viewport().get_camera_3d()
	$origin.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var markerpos = cam.unproject_position(self.global_transform.origin)
	$origin.position = markerpos
		



func _on_visible_on_screen_notifier_3d_screen_entered():
	$origin.show()
func _on_visible_on_screen_notifier_3d_screen_exited():
	$origin.hide()
