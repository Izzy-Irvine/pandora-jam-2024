extends Node2D

@export var max_velocity = 500
@export var acceleration = 2000
@export var overshoot_distance = 100

var velocity = 0
var direction = -1

var active = false
var dead = false
var player = null


func _ready() -> void:
	player = get_node("/root/Main/Player/CharacterBody2D")


func _process(delta: float) -> void:
	if active and not dead:
		move(delta)
	if Input.is_action_just_pressed("ui_accept") and active and not dead:
		die()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$AnimatedSprite2D.play("wake")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	#queue_free()
	pass


func move(delta: float):
	$AnimatedSprite2D.flip_h = velocity <= 0
	
	var distance = global_position.x - player.global_position.x
	var current_dir = -sign(distance)
	
	if abs(distance) >= overshoot_distance and current_dir != direction:
		direction *= -1
	
	velocity += acceleration * direction * delta
	velocity = clamp(velocity, -max_velocity, max_velocity)
	
	position.x += velocity * delta


func die():
	dead = true
	$AnimatedSprite2D.play("die")


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "wake":
		active = true
		$AnimatedSprite2D.play("run")


func _on_body_entered(body: Node2D) -> void:
	if body == player:
		player.hurt(20)
	pass # Replace with function body.
