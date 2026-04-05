extends npc
class_name enemy

@export var weapon_type = "rifle"
@export var fire_rate: float = 0.2 
@export var patrol_radius: float = 200.0  
@export var patrol_wait_time: float = 3.0 # Пауза ПОСЛЕ достижения точки

@export_group("Movement Settings")
@export var chase_speed: float = 250.0   # Скорость погони за игроком
@export var patrol_speed: float = 120.0  # Скорость спокойного патрулирования
@export var rotation_speed: float = 20.0

enum state {IDLE, SHOOT, SEARCH}

@onready var agent = $Agent
@onready var shoot_timer = Timer.new()
@onready var patrol_timer = Timer.new()

const bullet_scene = preload("res://Obj/enemy_bullet.tscn")

var cur_state = state.IDLE
var target: Node2D
var can_shoot: bool = true
var start_pos: Vector2 

func _ready() -> void:
	super._ready()
	start_pos = global_position 
	
	# Настройка таймера стрельбы
	add_child(shoot_timer)
	shoot_timer.wait_time = fire_rate
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(func(): can_shoot = true)
	
	# Настройка таймера патруля
	add_child(patrol_timer)
	patrol_timer.wait_time = patrol_wait_time
	patrol_timer.one_shot = true
	patrol_timer.timeout.connect(_on_patrol_timer_timeout)
	
	_on_patrol_timer_timeout()

func _physics_process(_delta: float) -> void:
	check_rays()
	
	match cur_state:
		state.IDLE:
			move_logic(_delta)
		state.SEARCH:
			if is_instance_valid(target):
				agent.target_position = target.global_position
			move_logic(_delta)
		state.SHOOT:
			shoot_logic(_delta)

func move_logic(_delta):
	if agent.is_navigation_finished():
		velocity = Vector2.ZERO
		if cur_state == state.IDLE and patrol_timer.is_stopped():
			patrol_timer.start()
		return

	var next_path_pos = agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_pos)
	
	if direction.length() > 0:
		rotation = lerp_angle(rotation, direction.angle(), rotation_speed * _delta)
		
		# Выбираем скорость в зависимости от состояния
		var current_move_speed = patrol_speed if cur_state == state.IDLE else chase_speed
		
		velocity = direction * current_move_speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO

func shoot_logic(_delta):
	velocity = Vector2.ZERO 
	patrol_timer.stop()
	
	if is_instance_valid(target):
		var dir_to_player = global_position.direction_to(target.global_position)
		rotation = lerp_angle(rotation, dir_to_player.angle(), rotation_speed * _delta)
		
		if can_shoot:
			spawn_bullet()

func spawn_bullet():
	can_shoot = false
	shoot_timer.start()
	var b = bullet_scene.instantiate()
	b.global_position = $Weapon/Marker2D.global_position
	b.rotation = rotation
	get_tree().current_scene.add_child(b)

func check_rays():
	if $View_sine.get_child_count() == 0: return
	if $View_sine.get_child(0).enabled == false: return

	var found_player = false
	for i in $View_sine.get_children():
		if i is RayCast2D and i.is_colliding():
			var collider = i.get_collider()
			if collider and collider.has_meta("player"):
				target = collider
				found_player = true
				break
	
	if found_player:
		cur_state = state.SHOOT
	elif target != null:
		cur_state = state.SEARCH
	else:
		cur_state = state.IDLE

func _on_patrol_timer_timeout():
	if cur_state == state.IDLE:
		var random_offset = Vector2(
			randf_range(-patrol_radius, patrol_radius),
			randf_range(-patrol_radius, patrol_radius)
		)
		agent.target_position = start_pos + random_offset

func additional_reaction():
	if cur_state == state.IDLE: 
		rotation_degrees += 90

func additional():
	$Weapon/sprite.visible = false
	for ray in $View_sine.get_children():
		if ray is RayCast2D:
			ray.enabled = false
	target = null
	cur_state = state.IDLE
	can_shoot = false
	patrol_timer.stop()
