extends CharacterBody2D

var bullet_scene = preload("res://scenes/projectiles/bullet.tscn")
var magic_bullet_scene = preload("res://scenes/projectiles/magic_bullet.tscn")

# Declare member variables here. Examples:
var speed = 10
var screen_width 
var screen_height 
var screen_margin
var up_max = 120
var sprite_size
var health = 100

var fire_timeout = 0

var is_walking = false

signal scroll_right(delta)

func _ready():
	screen_width = get_viewport().get_visible_rect().size.x
	screen_height = get_viewport().get_visible_rect().size.y
	var external_scale = get_node("/root/Main").get_node("Player").scale
	sprite_size = $CollisionShape2D.shape.get_rect().size * external_scale
	screen_margin = screen_width / 4  # Distance from the edge of the screen to start scrolling
	$AnimatedSprite2D.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fire_timeout = max(fire_timeout - delta, 0)
	velocity = Vector2()
	
	is_walking = false
	
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite2D.play("walk")
		is_walking = true
		if global_position.x > screen_width - screen_margin:
			emit_signal("scroll_right", delta)
		else:
			velocity.x = 1
	elif Input.is_action_pressed("ui_left"):
		$AnimatedSprite2D.play("walk")
		is_walking = true
		if global_position.x > (sprite_size.x / 2):
			velocity.x = -1

	if Input.is_action_pressed("ui_down"):
		$AnimatedSprite2D.play("walk")
		is_walking = true
		if global_position.y < screen_height - (sprite_size.y / 2):
			velocity.y = 1
	elif Input.is_action_pressed("ui_up"):
		$AnimatedSprite2D.play("walk")
		is_walking = true
		if global_position.y > up_max:
			velocity.y = -0.6
	
	if Input.is_action_pressed("fire_gun") and fire_timeout == 0:
		$AnimatedSprite2D.play("gun_attack")
		fire_timeout = 0.2
		var bullet = bullet_scene.instantiate()
		bullet.position = position + Vector2(0, 1)
		bullet.z_index = -1
		bullet.flipped = $AnimatedSprite2D.scale.x == -1
		get_parent().add_child(bullet)
	
	if Input.is_action_pressed("fire_wand") and fire_timeout == 0:
		$AnimatedSprite2D.play("magic_attack")
		fire_timeout = 1
		var bullet = magic_bullet_scene.instantiate()
		bullet.scale = Vector2(2, 2)
		bullet.z_index = -1
		bullet.position = position + Vector2(20, 0)
		bullet.flipped = $AnimatedSprite2D.scale.x == -1
		get_parent().add_child(bullet)

	velocity = velocity.normalized() * speed
	move_and_collide(velocity)
	
	if velocity.x < 0:
		$AnimatedSprite2D.scale.x = -1
	elif velocity.x > 0:
		$AnimatedSprite2D.scale.x = 1

func hurt(damage):
	health -= damage
	if health <= 0:
		get_tree().quit()


func _on_animated_sprite_2d_animation_finished() -> void:
	if is_walking:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")
