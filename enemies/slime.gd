extends CharacterBody2D

const SPEED = 600.0
var is_player_in_hit_zone: bool = false

func _physics_process(delta: float) -> void:
	var target_position: Vector2 = World.player.global_position
	velocity = global_position.direction_to(target_position) * SPEED * delta
	
	move_and_slide()

func apply_damage(body):
	body.get_node("HealthComponent").damage(1)
	await get_tree().create_timer(1.0).timeout
	if is_player_in_hit_zone == true:
		apply_damage(body)

func _on_hit_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.has_node("HealthComponent"):
			is_player_in_hit_zone = true
			apply_damage(body)

func _on_hit_zone_body_exited(body: Node2D) -> void:
	if body is Player:
		is_player_in_hit_zone = false

func _die() -> void:
	queue_free()
