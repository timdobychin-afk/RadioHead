extends CharacterBody2D
class_name npc

const oshmetki = preload("uid://bsvtsjvm2cnle")
const corpse = preload("uid://c7vx83wo7dscg")
@export var HP: int = 100
enum types {Enemy_light,Enemy_solid,Enemy_fat,Friend_skuf,Friend_yakuza}
@export var visual_type = types.Friend_skuf

func _ready() -> void:
	match visual_type:
		types.Enemy_light:
			$Sprite.texture = load("uid://dx7cr8u8li247")
		types.Enemy_solid:
			$Sprite.texture = load("uid://p6wjcvsr4xfc")
		types.Enemy_fat:
			$Sprite.texture = load("uid://couqft01abgn")
		types.Friend_skuf:
			$Sprite.texture = load("uid://dcoqx7wqw68ti")
		types.Friend_yakuza:
			$Sprite.texture = load("uid://w06cklh6rjhq")

func _on_area_area_entered(area: Area2D) -> void:
	if area.has_meta("Bullet"):
		if area.dodge == false:
			HP -= area.get_meta("dmg", 0)
			$Damage.emitting = true
			check_hp()
			additional_reaction()
	if area.has_meta("melee"):
		HP -= area.get_meta("dmg", 0)
		$Damage.emitting = true
		check_hp()
		additional_reaction()

func additional_reaction():
	pass

func check_hp():
	if HP <= 0:
		dead()

func dead():
	await get_tree().process_frame
	$Area/Collision.disabled = true
	%Collision.disabled = true
	$shadow.visible = false
	$Sprite.visible = false
	$Dead_part.emitting = true
	$Dead_part2.emitting = true
	$Dead_part3.emitting = true
	if visual_type == types.Enemy_light or visual_type == types.Enemy_solid or visual_type == types.Enemy_fat:
		var inst = corpse.instantiate()
		match visual_type:
			types.Enemy_light:
				inst.type = 1
			types.Enemy_solid:
				inst.type = 2
			types.Enemy_fat:
				inst.type = 3
		$"..".add_child(inst)
		inst.global_position = global_position
		
	else:
		var inst = oshmetki.instantiate()
		$"..".add_child(inst)
		inst.global_position = global_position
	additional()
	wait()

func additional():
	pass

func wait():
	await get_tree().create_timer(8).timeout
	queue_free()
