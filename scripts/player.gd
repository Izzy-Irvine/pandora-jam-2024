extends CharacterBody2D

var bullet_scene = preload("res://scenes/sprites/bullet.tscn")
var magic_bullet_scene = preload("res://scenes/sprites/magicBullet.tscn")

# Declare member variables here. Examples:
var speed = 10
var screen_width 
var screen_height 
var screen_margin
var up_max = 120
var sprite_size
var health = 100

var fire_timeout = 0

signal scroll_right(delta)

func _ready():
	screen_width = get_viewport().size.x
	screen_height = get_viewport().size.y
	var external_scale = get_node("/root/Main").get_node("Player").scale
	sprite_size = $Sprite2D.texture.get_size() * external_scale
	screen_margin = screen_width / 4  # Distance from the edge of the screen to start scrolling

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fire_timeout = max(fire_timeout - delta, 0)
	velocity = Vector2()

	if Input.is_action_pressed("ui_right"):
		if global_position.x > screen_width - screen_margin:
			print("Scrolling")
			emit_signal("scroll_right", delta)
		else:
			velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		if global_position.x > (sprite_size.x / 2):
			velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		if global_position.y < screen_height - (sprite_size.y / 2):
			velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		if global_position.y > up_max:
			velocity.y -= 0.6
			
	if Input.is_action_pressed("fire_gun") and fire_timeout == 0:
		fire_timeout = 0.2
		var bullet = bullet_scene.instantiate()
		bullet.position = position
		bullet.flipped = $Sprite2D.flip_h
		get_parent().add_child(bullet)
	
	if Input.is_action_pressed("fire_wand") and fire_timeout == 0:
		fire_timeout = 1
		var bullet = magic_bullet_scene.instantiate()
		bullet.position = position
		bullet.flipped = $Sprite2D.flip_h
		get_parent().add_child(bullet)

	velocity = velocity.normalized() * speed
	move_and_collide(velocity)
	
	if velocity.x < 0 and not $Sprite2D.flip_h:
		$Sprite2D.flip_h = true
	elif velocity.x > 0 and $Sprite2D.flip_h:
		$Sprite2D.flip_h = false

func hurt(damage):
	health -= damage
	if health <= 0:
		get_tree().quit()
