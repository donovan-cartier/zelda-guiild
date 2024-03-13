extends Node

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var root: Node2D = get_tree().get_root().get_node("Game")
@onready var current_level: TileMap = root.get_node("Level1")
