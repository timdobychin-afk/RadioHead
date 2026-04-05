extends Camera2D

@export var target: Node2D
var shake_power = 0
var shake_dying = 0


func _physics_process(delta: float) -> void:
	if shake_power > 0:
		offset.x += randi_range(-1,1) * shake_power
		offset.y += randi_range(-1,1) * shake_power
	else:
		shake_power = 0
	offset.x = lerpf(offset.x, 0, 0.1)
	offset.y = lerpf(offset.y, 0, 0.1)
	shake_power -= shake_dying
	if Input.is_action_pressed("aim"):
		var mid_point = target.global_position.lerp(get_global_mouse_position(), 0.45)
		global_position = lerp(global_position, mid_point, 0.1)
	else:
		global_position = lerp(global_position, target.global_position, 0.1)

func apply_powers(power: int, speed: int):
	shake_power += power
	shake_dying = speed * 0.5
