extends CharacterBody2D

# Declare member variables here. Examples:
var speed = 10
var screen_width 
var screen_height 
var screen_margin
var up_max = 120
var sprite_size

signal scroll_right(delta)

func _ready():
	screen_width = get_viewport().size.x
	screen_height = get_viewport().size.y
	var external_scale = get_node("/root/Main").get_node("Player").scale
	sprite_size = $Sprite2D.texture.get_size() * external_scale
	screen_margin = screen_width / 4  # Distance from the edge of the screen to start scrolling

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
			velocity.y -= 1

	velocity = velocity.normalized() * speed
	move_and_collide(velocity)
