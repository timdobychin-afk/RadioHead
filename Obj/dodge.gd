extends Node2D

var type: int

func set_type(type_give: int):
	type = type_give
	print(type)

func _ready() -> void:
	$Label/ColorRect.size.x = $Label.size.x
	await get_tree().process_frame
	if type == 1:
		print("miss!")
		$Label.text ="MISS!!"
		$Label.add_theme_color_override("font_color",Color(0.856, 0.0, 0.0, 1.0))
	elif type == 2:
		print("huiss!")
		$Label.text ="weapon."
		$Label.add_theme_color_override("font_color",Color("2e9bf1ff"))
	var twm = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	var twp = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	twm.tween_property($Label,"position", Vector2(0,30),1.6)
	twp.tween_property($Label,"modulate", Color(0.965, 0.965, 0.965, 0.0),2)
	await get_tree().create_timer(2).timeout
	queue_free()
