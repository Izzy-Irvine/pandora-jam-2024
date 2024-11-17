extends Node2D

var player = null
var level = null
var screen_width = 0
var screen_margin = 0

func _ready():
	screen_width = get_viewport().get_visible_rect().size.x
	screen_margin = screen_width / 2
	player = $Player/CharacterBody2D
	player.connect("scroll_right", Callable(self, "_on_player_scroll_right"))
	level = $Level

func _on_player_scroll_right(screen_amount):
	print("Scrolling right", screen_amount)	
	level.position.x -= screen_amount  # Scroll speed
	
	$Sky.position.x -= screen_amount * 0.1
	$Hills.position.x -= screen_amount * 0.5
	$Stones.position.x -= screen_amount

func _process(delta: float) -> void:
	if player.global_position.x > screen_width - screen_margin:
		var not_dead = 0
		for child in level.get_children():
			if "Enemy" in child.name:
				if player.global_position.distance_to(child.global_position) > 1.5 * screen_width:
					continue
				if !child.dead:
					not_dead += 1
		if not_dead == 0:
			get_tree().change_scene_to_file("res://scenes/win.tscn")