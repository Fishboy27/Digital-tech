extends ColorRect

var player = null
var direction = 1.0

@onready var global = get_node("/root/Global")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Movement
	if global.shoot:
		position.x += 0.01 * direction

# Going to the boss
func _on_area_2d_body_entered(body):
	global.shoot = false
	player = null
	position = $"..".position

# Shooting
func _on_shoot_body_entered(body):
	if body.name == ("Player"):
		player = body
		global.shoot = true
