extends RigidBody2D

var type 

func _ready() -> void:
	move(Vector2(0,0))
	match type:
		1:
			$Sprite2D.texture = load("uid://bc7vgty0ddmin")
			$Blood.modulate = Color(0.227, 0.004, 0.0, 1.0)
		2:
			$Sprite2D.texture = load("uid://g4lltg24xgmp")
			$Blood.modulate = Color(0.129, 0.129, 0.522, 1.0)
		3:
			$Sprite2D.texture = load("uid://kng7kerqidb")
			$Blood.modulate = Color(0.698, 0.686, 0.667, 1.0)

func _on_area_area_entered(area: Area2D) -> void:
	if area.has_meta("melee"):
		var ww = Vector2.from_angle(global_position.angle_to_point(get_global_mouse_position()))
		move(ww)

func move(value: Vector2):
	if value == Vector2(0,0):
		var rot = randf_range(-360,360)
		var vector = Vector2(cos(rot), sin(rot))
		apply_central_impulse(vector * 4000)
		angular_velocity += randf_range(-90,90)
	else:
		apply_central_impulse(value * randf_range(0.01,1) * 2000) 
		angular_velocity += randf_range(-90,90)
