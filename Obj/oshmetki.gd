extends RigidBody2D

var type 

func _ready() -> void:
	move()
	type = randi_range(1,3)
	match type:
		1:
			$Sprite2D.texture = load("uid://bjgaegj7o5wvg")
		2:
			$Sprite2D.texture = load("uid://cmmmymbe75ep3")
		3:
			$Sprite2D.texture = load("uid://ba8jditvd5pl")

func _on_area_area_entered(area: Area2D) -> void:
	if area.has_meta("melee") or area.has_meta("bullet"):
		move()

func move():
	var rot = randf_range(-360,360)
	var vector = Vector2(cos(rot), sin(rot))
	apply_central_impulse(vector * randi_range(-500,500))
	angular_velocity += randf_range(-90,90)
