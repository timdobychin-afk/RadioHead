extends RigidBody2D

@export var type = "rifle"

func _ready() -> void:
	$area/CollisionShape2D.disabled = true
	match type:
		"rifle":
			$Sprite.texture = load("uid://bhw6awiirxqa0")
	await get_tree().create_timer(0.3).timeout
	$area/CollisionShape2D.disabled = false

func _process(delta: float) -> void:
	pass

func pick_up():
	queue_free()

func _on_area_area_entered(area: Area2D) -> void:
	if area.has_meta("Bullet"):
		move()

func move():
	var rot = randf_range(-360,360)
	var vector = Vector2(cos(rot), sin(rot))
	apply_central_impulse(vector * randi_range(500,1000))
	angular_velocity += randf_range(-180,180)

func _on_area_body_entered(body: Node2D) -> void:
	if body.has_meta("player"):
		body.add_weapon(type, self)
