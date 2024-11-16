extends CharacterBody2D

# Declare member variables here. Examples:
var speed = 10
var screen_width 
var screen_margin
var back_max = 100

signal scroll_right(delta)

func _ready():
	screen_width = get_viewport().size.x
	screen_margin = screen_width / 3  # Distance from the edge of the screen to start scrolling

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
		if global_position.x > back_max:
			velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	velocity = velocity.normalized() * speed
	move_and_collide(velocity)
