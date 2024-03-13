@tool
extends StaticBody2D

@onready var sprite = $Sprite
@onready var collision_shape = $CollisionShape
@onready var area2d = $Area2D
@export var is_opened: bool = false
@export var tilemap_to_open: PackedScene

func open():
	sprite.play("open")
	collision_shape.disabled = true
	
func close():
	sprite.play_backwards("open")
	collision_shape.disabled = false

func change_tile_map(tile_map_name):
	var new_tilemap = tilemap_to_open.instantiate()
	World.root.call_deferred("add_child", new_tilemap)
	World.root.call_deferred("remove_child",World.current_level)
	World.current_level = new_tilemap

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if is_opened:
		open()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		sprite.frame = is_opened

func _on_opened():
	open()

func _on_closed():
	close()

func _on_area_2d_body_entered(body):
	change_tile_map(tilemap_to_open)
