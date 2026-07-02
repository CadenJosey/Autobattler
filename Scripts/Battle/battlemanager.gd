extends Node2D


var unitScene = preload("res://Scenes/Unit/unit.tscn")
var enemies : Array[Unit]
var adventurers : Array[Unit]




# Called when the node enters the scene tree for the first time.
func _ready():
	new_adventurer(UnitDatabase.KNIGHT, _get_adventurer_spawn())
	new_adventurer(UnitDatabase.PEASANT, _get_adventurer_spawn())
	new_adventurer(UnitDatabase.WIZARD, _get_adventurer_spawn())
	new_adventurer(UnitDatabase.CLERIC, _get_adventurer_spawn())

	for i in 3:
		new_enemy(UnitDatabase.SKELETON, _get_enemy_spawn())
	new_enemy(UnitDatabase.SKELETON_WIZARD, _get_enemy_spawn())
	new_enemy(UnitDatabase.SKELETON_PRIEST, _get_enemy_spawn())


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


func _on_adventurer_attack(damage: int, pierce: int, target: Unit.TARGET):
	Unit.resolve_attack(damage, pierce, target, adventurers, enemies)


func _on_enemy_attack(damage: int, pierce: int, target: Unit.TARGET):
	Unit.resolve_attack(damage, pierce, target, adventurers, enemies)


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
