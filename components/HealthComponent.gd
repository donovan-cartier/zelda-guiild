extends Node
class_name HealthComponent

@export var health: int = 3
@export var max_health: int = 3

func damage(amount: int):
	health -= amount
	if health <= 0:
		owner.queue_free()
