extends CharacterBody2D

var bullet_scene = preload("res://scenes/projectiles/bullet.tscn")
var magic_bullet_scene = preload("res://scenes/projectiles/magic_bullet.tscn")

# Declare member variables here. Examples:
var speed = 5
var screen_width 
var screen_height 
var screen_margin
@export var up_max = 200
var sprite_size
@export var health = 100

var cur_gun_timeout = 0
@export var gun_timeout = 0.2
var cur_magic_timeout = 0
@export var magic_timeout = 1

var is_walking = false

signal scroll_right(delta)

func _ready():
	screen_width = get_viewport().get_visible_rect().size.x
	screen_height = get_viewport().get_visible_rect().size.y
	var external_scale = get_node("/root/Main").get_node("Player").scale
	sprite_size = $CollisionShape2D.shape.get_rect().size * external_scale
	screen_margin = screen_width / 2  # Distance from the edge of the screen to start scrolling
	$AnimatedSprite2D.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cur_gun_timeout = max(cur_gun_timeout - delta, 0)
	cur_magic_timeout = max(cur_magic_timeout - delta, 0)
	velocity = Vector2()
	
	is_walking = false
	var dead = health <= 0
	
	if Input.is_action_pressed("ui_right") and not dead:
		$AnimatedSprite2D.play("walk")
		is_walking = true
		velocity.x = 1
	elif Input.is_action_pressed("ui_left") and not dead:
		$AnimatedSprite2D.play("walk")
		is_walking = true
		if global_position.x > (sprite_size.x / 2):
			velocity.x = -1

	if Input.is_action_pressed("ui_down") and not dead:
		$AnimatedSprite2D.play("walk")
		is_walking = true
		if global_position.y < screen_height - (sprite_size.y / 2):
			velocity.y = 1
	elif Input.is_action_pressed("ui_up") and not dead:
		$AnimatedSprite2D.play("walk")
		is_walking = true
		if global_position.y > up_max:
			velocity.y = -0.6
	
	if Input.is_action_pressed("fire_gun") and cur_gun_timeout == 0 and cur_magic_timeout == 0 and not dead:
		$AnimatedSprite2D.play("gun_attack")
		cur_gun_timeout = gun_timeout
		var bullet = bullet_scene.instantiate()
		bullet.position = position + Vector2(0, 1) * $AnimatedSprite2D.scale.x
		bullet.z_index = -1
		bullet.flipped = $AnimatedSprite2D.scale.x == -1
		get_parent().add_child(bullet)
	
	if Input.is_action_just_pressed("fire_wand") and cur_gun_timeout == 0 and cur_magic_timeout == 0 and not dead:
		$AnimatedSprite2D.play("magic_attack")
		cur_magic_timeout = magic_timeout
		var bullet = magic_bullet_scene.instantiate()
		bullet.scale = Vector2(2, 2)
		bullet.z_index = -1
		bullet.position = position + Vector2(15, 0) * $AnimatedSprite2D.scale.x
		bullet.flipped = $AnimatedSprite2D.scale.x == -1
		get_parent().add_child(bullet)

	velocity = velocity.normalized() * speed
	move_and_collide(velocity)

	if global_position.x > screen_width - screen_margin:
		emit_signal("scroll_right", global_position.x - (screen_width - screen_margin))
		global_position.x = screen_width - screen_margin
	
	if velocity.x < 0:
		$AnimatedSprite2D.scale.x = -1
	elif velocity.x > 0:
		$AnimatedSprite2D.scale.x = 1

func hurt(damage):
	if health <= 0:
		return
		
	health -= damage
	
	if health <= 0:
		$AnimatedSprite2D.play("death")


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "death":
		get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")
	elif is_walking:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")
