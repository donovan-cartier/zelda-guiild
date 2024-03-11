extends CharacterBody2D
class_name Player

const SPEED = 100.0
const MAX_SPEED = 100.0

#enum STATE {
	#IDLE,
	#ATTACKING,
	#MOVING
#}

var is_moving: bool = false
var is_attacking: bool = false

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var down_anchor: Node2D = %DownAnchor
@onready var right_anchor: Node2D = %RightAnchor
@onready var left_anchor: Node2D = %LeftAnchor
@onready var up_anchor: Node2D = %UpAnchor

@onready var hit_zone: Area2D = $HitZone
@onready var slash_effect: AnimatedSprite2D = $SlashEffect

var entities_in_hit_zone: Array = []

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2(Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED 
		velocity.x = clampf(velocity.x, -MAX_SPEED, MAX_SPEED)
		
		velocity.y = direction.y * SPEED
		velocity.y = clampf(velocity.y, -MAX_SPEED, MAX_SPEED)

		check_direction(direction)
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * 4)
		velocity.y = move_toward(velocity.y, 0, SPEED * 4)
	
	is_moving = velocity != Vector2.ZERO
	
	if Input.is_action_just_pressed("attack"):
		attack()
	
	animate()
	
	move_and_slide()

func check_direction(direction):
	if direction == Vector2(1, 0):
		sprite.animation = "right"
		apply_transform_from(hit_zone, right_anchor)
		apply_transform_from(slash_effect, right_anchor, -90.0, 5.0, direction)
	
	if direction == Vector2(-1, 0):
		sprite.animation = "left"
		apply_transform_from(hit_zone, left_anchor)
		apply_transform_from(slash_effect, left_anchor, -90.0, 5.0, direction)
		
	if direction == Vector2(0, -1):
		sprite.animation = "up"
		apply_transform_from(hit_zone, up_anchor)
		apply_transform_from(slash_effect, up_anchor, -90.0, 5.0, direction)
		
	if direction == Vector2(0, 1):
		sprite.animation = "down"
		apply_transform_from(hit_zone, down_anchor)
		apply_transform_from(slash_effect, down_anchor, -90.0, 5.0, direction)

func apply_transform_from(node, anchor, angle_offset: float = 0.0, position_offset: float = 0.0,  direction: Vector2 = Vector2.ZERO):
	node.position = anchor.position + (direction * position_offset)
	node.rotation = anchor.rotation + rad_to_deg(angle_offset)

func animate():
	if is_attacking:
		animation_player.play("attack")
	elif is_moving:
		animation_player.play("move")
	else:
		animation_player.play("idle")

func attack():
	is_attacking = true
	for entity in entities_in_hit_zone:
		entity.get_node("HealthComponent").damage(1)
		
	slash_effect.frame = 0
	slash_effect.play("default")
	animation_player.play("attack")
	
#region Signals
func _on_hit_zone_body_entered(body: Node2D) -> void:
	if body.has_node("HealthComponent"):
		entities_in_hit_zone.append(body)

func _on_hit_zone_body_exited(body: Node2D) -> void:
	if entities_in_hit_zone.has(body):
		entities_in_hit_zone.erase(body)
		
func _on_slash_effect_animation_finished() -> void:
	is_attacking = false
	
#endregion
