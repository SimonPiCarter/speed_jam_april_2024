class_name Spawner extends Node2D

@onready var spawn_point = $spawn_point
@onready var sprite_2d = $Sprite2D

var model_path : String = "res://scene/game/unit/unit.tscn"
var produce_time : float = 4
var unit_slots = []
var time_since_last_production : float = 0

var sprites = [
	preload("res://resource/broken_wall.png"),
	preload("res://resource/broken_wall_2.png"),
	preload("res://resource/broken_wall_3.png"),
]

func _ready():
	sprite_2d.texture = sprites[randi_range(0, sprites.size()-1)]

func _physics_process(delta):
	if Constants.paused:
		return
	time_since_last_production += delta
	if time_since_last_production >= produce_time:
		for i in range(0,unit_slots.size()):
			var stat = unit_slots[i].stats
			if stat == null:
				continue
			var new_unit = load(model_path).instantiate()
			new_unit.position = position + spawn_point.position + Vector2((2-i)*32, 0)
			new_unit.life = unit_slots[i].health * unit_slots[i].stats.health
			new_unit.revenue = stat.revenue + unit_slots[i].money
			get_parent().add_child(new_unit)
			if stat.sprite_frames != null:
				new_unit.animated_sprite_2d.sprite_frames = stat.sprite_frames
				new_unit.animated_sprite_2d.play("default")
			time_since_last_production = 0
