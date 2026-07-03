extends Node2D


var unitScene = preload("res://Scenes/Unit/unit.tscn")
var monsters : Array[Unit]
var adventurers : Array[Unit]


# Called when the node enters the scene tree for the first time.
func _ready():
	new_adventurer(UnitDatabase.KNIGHT, _get_adventurer_spawn())
	new_adventurer(UnitDatabase.PEASANT, _get_adventurer_spawn())
	new_adventurer(UnitDatabase.WIZARD, _get_adventurer_spawn())
	new_adventurer(UnitDatabase.CLERIC, _get_adventurer_spawn())

	for i in 3:
		new_monster(UnitDatabase.SKELETON, _get_monster_spawn())
	new_monster(UnitDatabase.SKELETON_WIZARD, _get_monster_spawn())
	new_monster(UnitDatabase.SKELETON_PRIEST, _get_monster_spawn())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func new_adventurer(_class: Adventurer, _start_position : Vector2) -> Unit:
	var adventurer = unitScene.instantiate() as Unit
	adventurer.new_adventurer(_class, _start_position)
	add_child(adventurer)
	
	adventurer.attack.connect(_on_attack)
	adventurers.append(adventurer)
	return adventurer


func new_monster(_type: Monster, _start_position : Vector2) -> Unit:
	var monster = unitScene.instantiate() as Unit
	monster.new_monster(_type, _start_position)
	add_child(monster)
	
	monster.attack.connect(_on_attack)
	monsters.append(monster)
	return monster


func _on_attack(unit: Unit, target: Unit.TARGET):
	unit.resolve_attack(unit, target, adventurers, monsters)


func _get_adventurer_spawn() -> Vector2:
	var adventurer_num := adventurers.size()
	var spawn_point : Vector2
	spawn_point.x = 100 - (adventurer_num * 25)
	if adventurer_num % 2 == 0:
		spawn_point.y = 90
	else:
		spawn_point.y = 70
	
	return spawn_point


func _get_monster_spawn() -> Vector2:
	var monster_num := monsters.size()
	var spawn_point : Vector2
	spawn_point.x = 150 + (monster_num * 22)
	if monster_num % 2 == 0:
		spawn_point.y = 90
	else:
		spawn_point.y = 70
	
	return spawn_point
