extends CharacterBody2D

# Declare member variables here. Examples:
var speed = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    velocity = Vector2()
    
    if Input.is_action_pressed("ui_right"):
        velocity.x += 1
    if Input.is_action_pressed("ui_left"):
        velocity.x -= 1
    if Input.is_action_pressed("ui_down"):
        velocity.y += 1
    if Input.is_action_pressed("ui_up"):
        velocity.y -= 1
    
    velocity = velocity.normalized() * speed
    move_and_collide(velocity)