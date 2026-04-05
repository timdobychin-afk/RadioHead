extends Node2D

@export var speed = 200
var moving = true
var dodge = false
const miss = preload("res://Obj/dodge.tscn")

func _physics_process(delta: float) -> void:
	if moving:
		position += transform.x * speed * delta

func destroy(type: int):
	call_deferred("slivi")
	match type:
		1:
			$Destroy_parts.emitting = true
		2:
			$Destroy_parts2.emitting = true
			$Destroy_parts3.emitting = true
	moving = false
	$partsd.emitting = false
	$Sprite.visible = false
	await get_tree().create_timer(2.0).timeout
	queue_free()

func slivi():
	$CollisionShape2D.disabled = true

func _on_body_entered(body: Node2D) -> void:
	if body.has_meta("enemy") == false:
		destroy(1)

func _on_area_entered(area: Area2D) -> void:
	if dodge == false:
		if area.has_meta("weap"):
			var inst = miss.instantiate()
			$"..".add_child(inst)
			inst.global_position = global_position
			inst.set_type(2)
		elif area.has_meta("enemy"):
			destroy(2)
	else:
		if area.has_meta("enemy"):
			var inst = miss.instantiate()
			$"..".add_child(inst)
			inst.global_position = global_position
			inst.set_type(1)
		if area.has_meta("weap"):
			var inst = miss.instantiate()
			$"..".add_child(inst)
			inst.global_position = global_position
			inst.set_type(2)
		dodge = false
