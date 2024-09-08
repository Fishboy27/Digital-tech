extends CharacterBody2D

var speed = 500.0
var jump_velocity = -350.0
var gravity = 600.0
var max_jumps = 2
var jump_count = 1
var dash_speed = 50000.0 
var dashing = false
var unlock = true
var wall_jump = 0
var can_shoot = true
var camera_change = false
var BAZINGA = randi_range(0, 100)
@export var bullet_scene: PackedScene
@onready var global = get_node("/root/Global")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = Input.get_axis("Left", "Right")

	if Input.is_action_just_pressed("Jump") and max_jumps > jump_count and not $AnimatedSprite2D/RayCast2D.is_colliding():
			velocity.y = jump_velocity
			jump_count = jump_count + 1
	elif Input.is_action_just_pressed("Jump") and $AnimatedSprite2D/RayCast2D.is_colliding():
		velocity.y = jump_velocity
		velocity.x += 300 * -$AnimatedSprite2D.scale.x
		$AnimatedSprite2D.scale.x = -$AnimatedSprite2D.scale.x
		lock(0.3)

	if is_on_floor():
		jump_count = 1

	if is_on_wall():
		jump_count = 1

	if is_on_wall() and velocity.y > 0 and not Input.is_action_pressed("Drop"):
		gravity = 200.0
	else:
		gravity = 600.0

	if camera_change:
		$Camera2D.zoom = Vector2(1, 1)
	else:
		$Camera2D.zoom = Vector2(2, 2)

	if direction:
		if unlock:
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

	if not Input.is_anything_pressed():
		$AnimatedSprite2D.play("Idle")

	if Input.is_action_pressed("Jump") and not is_on_floor():
		$AnimatedSprite2D.play("Jump")

	if Input.is_action_just_pressed("Restart"):
		get_tree().reload_current_scene()
		global.health = 20

	if Input.is_action_just_pressed("Shoot"):
		_shoot()
	
	#$Boss_health/HEALTH.value = global.health
	#$Boss_health/PERCENT.value = global.health

	move_and_slide()

func lock(_time):
	$Wall_jump.start(_time)
	unlock = false

func _spikes(area):
	if area.has_meta("Spikes"):
		get_tree().reload_current_scene()
		global.health = 20

func _door(area):
	if area.has_meta("Door"):
		get_tree().change_scene_to_file("res://win.tscn")

func _to_level_2(area):
	if area.has_meta("to_level_2"):
		get_tree().change_scene_to_file("res://level_2.tscn")

func _to_level_3(area):
	if area.has_meta("to_level_3"):
		get_tree().change_scene_to_file("res://level_3.tscn")

func _Dash_Time():
	dashing = false

func _wall_jump():
	unlock = true

func _shoot():
	if can_shoot:
		var bullet = bullet_scene.instantiate()
		bullet.position = $AnimatedSprite2D/bullet_spawn.global_position
		bullet.direction = $AnimatedSprite2D.scale.x
		add_sibling(bullet)
		can_shoot = false
		$Shoot_timer.start()
		$Shoot.playing = true

func _on_shoot_timer_timeout():
	can_shoot = true

func _camera_zoom(area):
	if area.has_meta("Camera_change"):
		camera_change = true

func _normal(area):
	if area.has_meta("normalise"):
		camera_change = false

#func _Boss_fight(area):
	#if area.has_meta("bossfight"):
		#camera_change = true
		#$Boss_health.visible = true
