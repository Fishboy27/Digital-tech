extends Control

@onready var global = get_node("/root/Global")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global.health < 0.01:
		global.visiblify = false
	if global.visiblify:
		visible = true
	else:
		visible = false
