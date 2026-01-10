extends Node2D


var unitScene = preload("res://Scenes/Battle/unit.tscn")
var enemies : Array[Unit]
var adventurers : Array[Unit]


const KNIGHT = preload("res://Scenes/Battle/Adventurers/Knight.tres")
const CLERIC = preload("res://Scenes/Battle/Adventurers/Cleric.tres")
const PEASANT = preload("res://Scenes/Battle/Adventurers/Peasant.tres")
const WIZARD = preload("res://Scenes/Battle/Adventurers/Wizard.tres")

const SKELETON = preload("res://Scenes/Battle/Enemies/Skeleton.tres")
const SKELETON_PRIEST = preload("res://Scenes/Battle/Enemies/Skeleton_Priest.tres")
const SKELETON_WIZARD = preload("res://Scenes/Battle/Enemies/Skeleton_Wizard.tres")


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 3:
		new_adventurer(KNIGHT, _get_adventurer_spawn())
	new_adventurer(WIZARD, _get_adventurer_spawn())
	new_adventurer(CLERIC, _get_adventurer_spawn())

	for i in 3:
		new_enemy(SKELETON, _get_enemy_spawn())
	new_enemy(SKELETON_PRIEST, _get_enemy_spawn())
	new_enemy(SKELETON_WIZARD, _get_enemy_spawn())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func new_adventurer(_class: Adventurer, _start_position : Vector2) -> Unit:
	var adventurer = unitScene.instantiate() as Unit
	adventurer.new_adventurer(_class, _start_position)
	add_child(adventurer)
	
	adventurer.attack.connect(_on_adventurer_attack)
	adventurers.append(adventurer)
	return adventurer


func new_enemy(_type: Enemy, _start_position : Vector2) -> Unit:
	var enemy = unitScene.instantiate() as Unit
	enemy.new_enemy(_type, _start_position)
	add_child(enemy)
	
	enemy.attack.connect(_on_enemy_attack)
	enemies.append(enemy)
	return enemy


func _on_adventurer_attack(damage: int, target: Unit.TARGET):
	var enemies_to_remove = []
	
	match target:
		Unit.TARGET.ALL:
			for i in enemies:
				if i.hurt(damage): enemies_to_remove.append(i)
		Unit.TARGET.RANDOM:
			var random_enemy = enemies.pick_random()
			if random_enemy != null and random_enemy.hurt(damage):
				enemies_to_remove.append(random_enemy)
		Unit.TARGET.HEAL:
			var injured_allies : Array[Unit]
			var random_ally : Unit
			for i in adventurers:
				if i.current_health < i.max_health: injured_allies.append(i)
			
			if injured_allies.size() > 0:
				# If there are hurt allies to choose from
				random_ally = injured_allies.pick_random()
			else:
				# Otherwise just pick a random one
				random_ally = adventurers.pick_random()
			
			if random_ally != null: random_ally.heal(damage)
	
	# After the all enemies have been iterated through:
	for i in enemies:
		for j in enemies_to_remove:
			enemies.erase(j)
			j.queue_free()


func _on_enemy_attack(damage: int, target: Unit.TARGET):
	var adventurers_to_remove = []
	
	match target:
		Unit.TARGET.ALL:
			for i in adventurers:
				if i.hurt(damage): adventurers_to_remove.append(i)
		Unit.TARGET.RANDOM:
			var random_adventurer = adventurers.pick_random()
			if random_adventurer != null and random_adventurer.hurt(damage):
				adventurers_to_remove.append(random_adventurer)
		Unit.TARGET.HEAL:
			var injured_allies : Array[Unit]
			var random_ally : Unit
			for i in enemies:
				if i.current_health < i.max_health: injured_allies.append(i)
			
			if injured_allies.size() > 0:
				# If there are hurt allies to choose from
				random_ally = injured_allies.pick_random()
			else:
				# Otherwise just pick a random one
				random_ally = enemies.pick_random()
			
			if random_ally != null: random_ally.heal(damage)
	
	# After all adventurers have been iterated through:
	for i in adventurers:
		for j in adventurers_to_remove:
			adventurers.erase(j)
			j.queue_free()


func _get_adventurer_spawn() -> Vector2:
	var adventurer_num := adventurers.size()
	var spawn_point : Vector2
	spawn_point.x = 100 - (adventurer_num * 25)
	if adventurer_num % 2 == 0:
		spawn_point.y = 90
	else:
		spawn_point.y = 70
	
	return spawn_point


func _get_enemy_spawn() -> Vector2:
	var enemy_num := enemies.size()
	var spawn_point : Vector2
	spawn_point.x = 150 + (enemy_num * 22)
	if enemy_num % 2 == 0:
		spawn_point.y = 90
	else:
		spawn_point.y = 70
	
	return spawn_point
