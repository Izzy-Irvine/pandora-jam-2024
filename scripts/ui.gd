extends Control

var player = null
var health_label = null
var magic_cooldown_rect_width = 200
var previous_health = 0

func _ready():
	player = get_node("/root/Main/Player/CharacterBody2D")
	health_label = $HealthLabel
	previous_health = player.health
	queue_redraw()

func _process(delta):
	if player.health < previous_health:
		animate_health_label()
	previous_health = player.health
	update_health_label(player.health)
	update_magic_cooldown(player.cur_magic_timeout, player.magic_timeout)

func update_health_label(health):
	health_label.text = "Health: " + str(health)

func update_magic_cooldown(current, max):
	var health_percentage = float(current) / max
	var rect_width = min(magic_cooldown_rect_width, health_percentage * magic_cooldown_rect_width)
	$ColorRect.size.x = rect_width

func animate_health_label():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(health_label, "scale", Vector2(1.5, 1.5), 0.01)
	tween.tween_property(health_label, "modulate", Color(1, 0, 0), 0.01)  # Tween to red
	tween.tween_callback(Callable(self, "_on_tween_completed"))

func _on_tween_completed():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(health_label, "scale", Vector2(1, 1), 0.5)
	tween.tween_property(health_label, "modulate", Color(1, 1, 1), 0.5)  # Tween back to white
