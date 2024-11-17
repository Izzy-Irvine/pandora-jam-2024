extends Node2D

@export var max_velocity = 500
@export var acceleration = 2000
@export var overshoot_distance = 100
@export var health = 5
@export var speed_reduction_time = 0.25
@export var attack_strength = 20
@export var knockback_strength = 750

var velocity = 0
var direction = -1
var knocked_back = false

var active = false
var dead = false
var player = null
var speed_reduced = false
var speed_reduction_timer = null

func _ready() -> void:
	player = get_node("/root/Main/Player/CharacterBody2D")
	speed_reduction_timer = Timer.new()
	speed_reduction_timer.wait_time = speed_reduction_time  # Duration of speed reduction
	speed_reduction_timer.one_shot = true
	speed_reduction_timer.connect("timeout", self._on_speed_reduction_timeout)
	add_child(speed_reduction_timer)

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
	if not knocked_back:
		$AnimatedSprite2D.flip_h = velocity <= 0
	
	var distance = global_position.x - player.global_position.x
	var current_dir = -sign(distance)
	
	if abs(distance) >= overshoot_distance and current_dir != direction:
		direction *= -1

	if knocked_back:
		velocity = move_toward(velocity, 0, acceleration * delta)
		if velocity == 0:
			knocked_back = false
	else:	
		velocity += acceleration * direction * delta
		velocity = clamp(velocity, -max_velocity, max_velocity)
		
	position.x += velocity * delta


func die():
       dead = true
       $AudioStreamPlayer.play(0)
       $AnimatedSprite2D.play("die")


func damage(damage): 
	health -= damage
	
	if health <= 0:
		die()
	else:
		knocked_back = true
		var distance = global_position.x - player.global_position.x
		var current_dir = sign(distance)
		velocity = knockback_strength * current_dir
		#reduce_speed()

func reduce_speed():
	if not speed_reduced:
		max_velocity /= 2
		speed_reduced = true
		speed_reduction_timer.start()

func _on_speed_reduction_timeout():
	max_velocity *= 2
	speed_reduced = false

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "wake":
		active = true
		$AnimatedSprite2D.play("run")

func _on_body_entered(body: Node2D) -> void:
	if body == player and not dead:
		player.hurt(attack_strength)
