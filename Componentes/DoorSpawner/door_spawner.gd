extends Area2D

@export var enemyCount = 10
@export var infantaria: PackedScene
@export var general: PackedScene
@export var infantariaGranadeira: PackedScene
@export var spawn_delay: float = 0.5 # Time between spawns

@onready var ativo = false
var enemies_to_spawn = 0
var spawn_timer: Timer

signal stoppedSpawning

func _ready():
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_delay
	spawn_timer.one_shot = false # We want it to keep ticking until we stop it
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(spawn_timer)

func spawn_enemies():
	enemies_to_spawn = enemyCount
	if enemies_to_spawn > 0:
		spawn_timer.start()

func _on_spawn_timer_timeout():
	if enemies_to_spawn <= 0:
		spawn_timer.stop()
		return

	if enemies_to_spawn == 1:
		_spawn_single_enemy("general")
	else:
		_spawn_single_enemy("infantaria")
	enemies_to_spawn -= 1
	if enemies_to_spawn <= 0:
		spawn_timer.stop()

func _spawn_single_enemy(type: String):
	if not infantaria or not general:
		return

	var collision_shape = $CollisionShape2D
	if not collision_shape:
		print_debug("Door spawner is missing a CollisionShape2D.")
		return

	var rect_shape = collision_shape.shape as RectangleShape2D
	if not rect_shape:
		print_debug("Door spawner's CollisionShape2D is not a RectangleShape2D.")
		return

	# Get the size of the rectangle to calculate the spawn area.
	var spawn_area_size = rect_shape.size

	# Calculate a random position inside the rectangle.
	# The origin (0,0) of a RectangleShape2D is its center.
	var random_x = randf_range(-spawn_area_size.x / 2, spawn_area_size.x / 2)
	var random_y = randf_range(-spawn_area_size.y / 2, spawn_area_size.y / 2)
	var random_local_position = Vector2(random_x, random_y)

	# Instantiate the enemy.
	var new_mob
	if (type == "infantaria"):
		new_mob = infantaria.instantiate()
	else:
		new_mob = general.instantiate()

	# Add the new mob to the "Door Enemies" group
	new_mob.add_to_group("FinalMobs")

	# Set the enemy's position.
	# The final position is the spawner's global position, plus the collision shape's offset from the spawner,
	# plus the random position inside the shape.
	new_mob.global_position = self.global_position + collision_shape.position + random_local_position

	# Add the enemy to the scene. Adding it as a sibling is often a good choice.
	get_parent().add_child(new_mob)


func _on_trigger_mobs_portao_area_entered(area):
	spawn_enemies()
	emit_signal("stoppedSpawning")
