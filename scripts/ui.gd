extends Control

var player = null
var health_label = null
var magic_cooldown_rect_width = 200

func _ready():
	player = get_node("/root/Main/Player/CharacterBody2D")
	health_label = $HealthLabel
	queue_redraw()

func _process(delta):
	update_health_label(player.health)
	update_magic_cooldown(player.cur_magic_timeout, player.magic_timeout)

func update_health_label(health):
	health_label.text = "Health: " + str(health)

func update_magic_cooldown(current, max):
	var health_percentage = float(current) / max
	var rect_width = min(magic_cooldown_rect_width, health_percentage * magic_cooldown_rect_width)
	$ColorRect.size.x = rect_width
