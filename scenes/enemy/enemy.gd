extends Node2D

@export var speed = 500

var active = false
var dead = false


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if active and not dead:
		position.x -= speed * delta
	if Input.is_action_just_pressed("ui_accept"):
		die()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$AnimatedSprite2D.play("wake")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func die():
	dead = true
	$AnimatedSprite2D.play("die")


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "wake":
		active = true
		$AnimatedSprite2D.play("run")
