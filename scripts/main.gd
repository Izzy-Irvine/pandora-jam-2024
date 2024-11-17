extends Node2D

var player = null
var level = null
var screen_amount = null

func _ready():
	player = $Player/CharacterBody2D
	player.connect("scroll_right", Callable(self, "_on_player_scroll_right"))
	level = $Level

	var screen_width = get_viewport().size.x
	screen_amount = screen_width / 4  # Amount to scroll


func _on_player_scroll_right(delta):
	level.position.x -= screen_amount * delta  # Scroll speed
	
	$Sky.position.x -= screen_amount * delta * 0.1
	$Hills.position.x -= screen_amount * delta * 0.5
	$Stones.position.x -= screen_amount * delta
