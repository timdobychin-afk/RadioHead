extends CharacterBody2D

const bullet = preload("res://Obj/bullet.tscn")
const SPEED = 600
const weapon = preload("res://Obj/weapon.tscn")

var current_weapon = "rifle"
var ammo_size = 30
var ammo = 30
var ammo_in_stock = 90
var cooldown_weapon = 0.12

var reload
var cooldown: float

var in_dialogue: bool = false
var dialogue:Array
var dialogue_step: int = 0

func _ready() -> void:
	change_weapon("rifle")

func _physics_process(delta: float) -> void:
	$line.look_at(get_global_mouse_position())
	$line.scale.x = global_position.distance_to(get_global_mouse_position()) /255
	var direction := Input.get_vector("A", "D", "W","S")
	velocity = direction * SPEED
	if reload:
		$Weapon.rotation_degrees += 30
	else:
		lerp_angle($Weapon.rotation_degrees, 0, 0.1)
	look_at(get_global_mouse_position())
	if cooldown > 0:
		cooldown -= delta
	
	if !reload:
		match current_weapon:
			"rifle":
				if Input.is_action_pressed("Attack") and ammo > 0 and cooldown <= 0:
					cooldown = cooldown_weapon
					ammo -= 1
					update()
					%Camera.apply_powers(10,10)
					var inst = bullet.instantiate()
					%Bullets.add_child(inst)
					inst.global_position = $Weapon/Marker2D.global_position
					inst.rotation = rotation
			"melee":
				if Input.is_action_just_pressed("Attack") and ammo > 0 and cooldown <= 0:
					cooldown = cooldown_weapon
					ammo -= 1
					update()
					%Camera.apply_powers(25,10)
					$melee/Sprite.visible = true
					$melee/Area/Collision.disabled = false
					await get_tree().create_timer(0.1).timeout
					$melee/Sprite.visible = false
					$melee/Area/Collision.disabled = true
	if Input.is_action_just_pressed("Reload"):
		$Reload_time.start()
		reload = true
	
	if Input.is_action_pressed("Drop") and current_weapon != "melee":
		%Camera.apply_powers(15,5)
		var inst = weapon.instantiate()
		%Bullets.add_child(inst)
		inst.global_position = global_position
		inst.rotation = rotation
		inst.type = current_weapon
		inst.move()
		change_weapon("melee")
	
	if Input.is_action_just_pressed("Interact"):
		if in_dialogue:
			if $"../Dialogue".visible == false:
				$"../Dialogue".visible = true
				$"../Dialogue/Label".text = dialogue[dialogue_step]
			else:
				dialogue_step += 1
				if dialogue_step <= dialogue.size() -1:
					$"../Dialogue/Label".text = dialogue[dialogue_step]
				else: 
					change_dialogue(null)
	move_and_slide()

func update():
	$"../hud/ammo".text = str(ammo)
	$"../hud/ammo_in_stock".text = str(ammo_in_stock)

func _on_reload() -> void:
	reload = false
	var add_size = ammo_size - ammo
	ammo_in_stock -= add_size
	ammo += add_size
	update()
	$Weapon.rotation_degrees = 0
	reload = false

func add_weapon(type: String, node: Node):
	if current_weapon == "melee":
		change_weapon(type)
		node.pick_up()
		print("pick_up: ", type)

func change_weapon(type: String):
	match type:
		"melee":
			$Weapon/sprite.visible = false
			$"../hud/TextureRect".texture = load("uid://co1l37qpv1o8p")
			ammo_size = 67
			ammo = 67
			ammo_in_stock = 0
			cooldown_weapon = 0.5
		"rifle":
			$Weapon/sprite.visible = true
			$"../hud/TextureRect".texture = load("uid://bhw6awiirxqa0")
			ammo_size = 20
			ammo = 20
			ammo_in_stock = 60
			cooldown_weapon = 0.13
	current_weapon = type
	update()

func change_dialogue(given_dialogue):
	dialogue_step = 0
	if given_dialogue == null:
		in_dialogue = false
		dialogue = ["BUUUUUUUUUUUG!!!"]
		$"../Dialogue".visible = false
		return
	in_dialogue = true
	dialogue = given_dialogue
