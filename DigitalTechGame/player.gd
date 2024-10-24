extends CharacterBody2D

var speed = 500.0
var jump_velocity = -350.0
var gravity = 600.0
var dash_speed = 50000.0 
var dashing = false
var unlock = true
var wall_jump = 0
var can_shoot = true
var camera_change = false
var BAZINGA = randi_range(0, 100)
var chng = false
var canjump = false
var coyote = false
var lastfloor = false
var double_jump = true
var fallify = false
var jumpify = false
var deathify = true
@export var bullet_scene: PackedScene
@onready var global = get_node("/root/Global")

func _physics_process(delta):
	# Gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

# Direction
	var direction = Input.get_axis("Left", "Right")

# Jumping
	if Input.is_action_just_pressed("Jump") and not $AnimatedSprite2D/RayCast2D.is_colliding() and canjump:
		if (coyote or lastfloor):
			velocity.y = jump_velocity
			jumpify = true
	elif Input.is_action_just_pressed("Jump") and double_jump:
		velocity.y = jump_velocity
		jumpify = false
	elif Input.is_action_just_pressed("Jump") and $AnimatedSprite2D/RayCast2D.is_colliding():
		velocity.y = jump_velocity
		velocity.x += 300 * -$AnimatedSprite2D.scale.x
		$AnimatedSprite2D.scale.x = -$AnimatedSprite2D.scale.x
		lock(0.3)

	if jumpify:
		double_jump = true
		canjump = false
	else:
		double_jump = false

	if is_on_floor() or is_on_wall():
		canjump = true
		coyote = true
		$Jump_timer.stop()
		fallify = false

	if not lastfloor and not fallify:
		coyote = false
	else:
		coyote = true

	if not lastfloor:
		fallify = true
		$Jump_timer.start()

# Stopping wallslide
	if is_on_wall() and velocity.y > 0 and not Input.is_action_pressed("Drop"):
		gravity = 200.0
	else:
		gravity = 600.0

# Changing camera zoom
	if camera_change:
		$Camera2D.zoom = Vector2(1, 1)
	else:
		$Camera2D.zoom = Vector2(2, 2)

# Movement
	if direction:
		if unlock:
			if deathify:
				if not dashing:
					if Input.is_action_just_pressed("Dash"):
						velocity.x = lerp(velocity.x, direction * dash_speed, 0.2)
						$Dash_timer.start() 
						dashing = true
				velocity.x = lerp(velocity.x, direction * speed, 0.2)
				$AnimatedSprite2D.scale.x = direction
			if Input.is_action_pressed("Left") or Input.is_action_pressed("Right") and unlock:
				$AnimatedSprite2D.play("Run")
	elif is_on_floor():
		velocity.x = lerp(velocity.x, 0.0, 0.2)

	if not is_on_floor() and not Input.is_anything_pressed():
		velocity.x = lerp(velocity.x, 0.0, 0.01)
	elif not is_on_floor():
		velocity.x = lerp(velocity.x, 0.0, 0.05)

# Idle
	if not Input.is_anything_pressed() and deathify:
		$AnimatedSprite2D.play("Idle")

# Jump
	if Input.is_action_pressed("Jump") and not is_on_floor() and deathify:
		$AnimatedSprite2D.play("Jump")

	#if Input.is_action_just_pressed("Restart"):
		#get_tree().reload_current_scene()
		#global.health = 1

# Shoot
	if Input.is_action_just_pressed("Shoot") and deathify:
		_shoot()
	
	if Input.is_action_just_pressed("chng"):
		chng = true
	
	if Input.is_action_just_pressed("chng2"):
		chng = false

	#if Input.is_action_just_pressed("ui_cancel"):
		#get_tree().quit()

	#if chng:
		#$Camera2D.enabled = false
	#if not chng:
		#$Camera2D.enabled = true
	
	#$Boss_health/HEALTH.value = global.health
	#$Boss_health/PERCENT.value = global.health

	move_and_slide()

# If is on floor
	lastfloor = is_on_floor()

# Lock
func lock(_time):
	$Wall_jump.start(_time)
	unlock = false

# Death
func _spikes(area):
	if area.has_meta("Spikes"):
		deathify = false
		lock(1)
		$AnimatedSprite2D.play("Death")
		await get_tree().create_timer(1).timeout
		deathify = true
		get_tree().reload_current_scene()
		global.health = 10
		global.visiblify = false

# Winning
func _door(area):
	if area.has_meta("Door"):
		get_tree().change_scene_to_file("res://win.tscn")

# Going to the next level
func _to_level_2(area):
	if area.has_meta("to_level_2"):
		get_tree().change_scene_to_file("res://level_2.tscn")

func _to_level_3(area):
	if area.has_meta("to_level_3"):
		get_tree().change_scene_to_file("res://level_3.tscn")

func _on_area_2d_area_entered(area):
	if area.has_meta("bossfight"):
		get_tree().change_scene_to_file("res://testing_level.tscn")

# Dashing
func _Dash_Time():
	dashing = false

# Wall jump
func _wall_jump():
	unlock = true

# Shoot
func _shoot():
	if can_shoot:
		var bullet = bullet_scene.instantiate()
		bullet.position = $AnimatedSprite2D/bullet_spawn.global_position
		bullet.direction = $AnimatedSprite2D.scale.x
		add_sibling(bullet)
		can_shoot = false
		$Shoot_timer.start()
		$Shoot.playing = true

# Shoot timer
func _on_shoot_timer_timeout():
	can_shoot = true

# Camera zoom
func _camera_zoom(area):
	if area.has_meta("Camera_change"):
		camera_change = true

# Uncamera zoom
func _normal(area):
	if area.has_meta("normalise"):
		camera_change = false

# Making the boss health bar visible
func _Boss_fight(area):
	if area.has_meta("boosfight"):
		global.visiblify = true

# Coyote jumps
func _on_jump_timer_timeout():
	fallify = false
	print("fallfalse")
