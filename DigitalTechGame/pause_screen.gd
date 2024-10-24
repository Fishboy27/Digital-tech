extends Control

var can_resume = false
# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	testmenu()

# Restart button
func _restart():
	resume()
	get_tree().reload_current_scene()

# Quit button
func _quit():
	get_tree().quit()

# Pausing the game and unpausing the game
func testmenu():
	if Input.is_action_just_pressed("ui_cancel") and !can_resume:
		pause()
		can_resume = true
	elif Input.is_action_just_pressed("ui_cancel") and can_resume:
		print("ye")
		resume()
		can_resume = false

# Resume
func resume():
	self.hide()
	get_tree().paused = false

# Pause
func pause():
	self.show()
	get_tree().paused = true

# Resume
func _back():
	resume()
