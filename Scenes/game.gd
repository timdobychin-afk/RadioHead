extends Node2D


func _ready() -> void:
	_on_timer_timeout()
	$Dialogue.visible = false

func _on_timer_timeout() -> void:
	var tws = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tws.tween_property($hud/Label, "scale", Vector2(1.1,1.1), 2.5).from(Vector2(0.9,0.9))
	
	tws.tween_property($hud/Label, "scale", Vector2(0.9,0.9), 2.5).from(Vector2(1.1,1.1))
	$hud/Label/Timer.start()
	

func _on_change_timeout() -> void:
	$Dialogue/TextureRect2.texture = load("uid://boourcquds8gb")
	await get_tree().create_timer(0.1).timeout
	$Dialogue/TextureRect2.texture = load("res://Images/Characters Faces/Character_FaceNPC5.1.2.png")
	await get_tree().create_timer(0.1).timeout
