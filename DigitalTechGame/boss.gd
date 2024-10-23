extends CharacterBody2D


var SPEED = 75.0
var gravity = 600
var direction = -1.0
var player_chase = false
var player = null
var can_shoot = true
var shootable = false
var droneshot = true
var jump = false
var canjump = false
var stage1 = true
var invincible = false
var heal = false
var killable = false

@onready var global = get_node("/root/Global")
@export var shooting_thing: PackedScene
@export var shooting_drone: PackedScene

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if player_chase:
		position += (player.position - position) / SPEED
		if player.global_position.x < global_position.x:
			direction = -1.0
			$AnimatedSprite2D.scale.x = -direction
		else:
			direction = 1.0
			$AnimatedSprite2D.scale.x = -direction
	else:
		velocity.x = lerp(velocity.x, direction * SPEED * 5, 0.5)

	if killable and global.health <= 0 and not invincible and not stage1:
		queue_free()

	if global.health == 1 and stage1:
		SPEED = 0.1
		invincible = true
		can_shoot = false
		player_chase = false
		heal = true

	if global.health == 5 and stage1:
		_drone()
		droneshot = false
	if global.health == 5 and not stage1:
		_drone()
		droneshot = false
	if global.health == 4:
		droneshot = true

#turning
	if $AnimatedSprite2D/RayCast2D.is_colliding() or $AnimatedSprite2D/RayCast2D2.is_colliding() and not player_chase:
		#if $AnimatedSprite2D/RayCast2D.get_collider().has_meta():
		_flip()

	if shootable:
		_shoot()

	if not jump:
		$AnimatedSprite2D.play("Roll")

	if heal:
		global.health += 0.1
		$"../CanvasLayer/Boss_health/HEALTH".value = global.health
		await get_tree().create_timer(1.5).timeout
		canjump = true
		stage1 = false
		SPEED = 50
		invincible = false
		shootable = false
		heal = false
		killable = true

	if jump and canjump:
		position.y += (player.position.y - position.y) * 3 / SPEED
		$AnimatedSprite2D.play("Jump")
		canjump = false
		await get_tree().create_timer(3).timeout
		canjump = true

	move_and_slide()

func _flip():
	direction = -direction
	$AnimatedSprite2D.scale.x = -direction

func _death(area):
	if area.has_meta("bullet") and not invincible:
		global.health -= 1
		$"../CanvasLayer/Boss_health/HEALTH".value = global.health

func _on_detection_body_entered(body):
	if body.name == ("Player"):
		player = body
		player_chase = true
		position += direction * ((player.position - position) / lerp(velocity.x, direction * SPEED, 0.2))


func _on_detection_body_exited(body):
	if body.name == ("Player"):
		player = null
		player_chase = false
		velocity.x = lerp(velocity.x, direction * SPEED * 7, 0.5)

func _shoot():
	if can_shoot:
		var shooting_thing = shooting_thing.instantiate()
		shooting_thing.position = $AnimatedSprite2D/bullet_spawn.global_position
		shooting_thing.direction = $AnimatedSprite2D.scale.x
		add_sibling(shooting_thing)
		can_shoot = false
		await get_tree().create_timer(4).timeout
		can_shoot = true

func _drone():
	if droneshot:
		var shooting_drone = shooting_drone.instantiate()
		shooting_drone.position = $AnimatedSprite2D/drone_spawn.global_position
		shooting_drone.direction = $AnimatedSprite2D.scale.x
		add_sibling(shooting_drone)
		droneshot = false

func _on_shoot_body_entered(body):
	if body.name == ("Player"):
		shootable = true

func _on_shoot_body_exited(body):
	if body.name == ("Player"):
		shootable = false

func _on_jump_body_entered(body):
	if body.name == ("Player"):
		jump = true

func _on_jump_body_exited(body):
	if body.name == ("Player"):
		jump = false
