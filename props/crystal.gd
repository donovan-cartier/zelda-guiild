extends StaticBody2D

@onready var sprite : Sprite2D = $Sprite
signal open

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _die() -> void:
	sprite.modulate = Color(0, 0.81176471710205, 0.09411764889956)
	open.emit()
