extends Node2D
class_name Unit
var random = RandomNumberGenerator.new()


@export var sprite_2d : Sprite2D
@onready var attack_bar = %AttackBar
@onready var health_bar = %HealthBar
@onready var attack_timer = %AttackTimer


const DAMAGE_NUMBER = preload("res://Scenes/Battle/damage_number.tscn")


var unit_stats = StatBlock.new()
var attack_buffer : float

var equipment := {
	Item.ItemType.WEAPON: null,
	Item.ItemType.ARMOR: null,
	Item.ItemType.HELMET: null
}


enum TARGET {
	RANDOM, # Choose a random member of the enemy team
	ALL,    # All enemies
	HEAL,   # Heal a random ally
	
}


signal attack(_damage: int, _target: Unit.TARGET)


func new_adventurer(_class : Adventurer, _start_position := Vector2(0, 0)):
	sprite_2d.texture = _class.sprite
	unit_stats.unit_name = _class.name
	unit_stats.max_health = _class.health
	unit_stats.current_health = unit_stats.max_health
	unit_stats.attack_speed = _class.attack_speed
	unit_stats.damage_min = _class.damage_min
	unit_stats.damage_max = _class.damage_max
	unit_stats.defense = _class.defense
	unit_stats.pierce = _class.pierce
	unit_stats.target = _class.target
	position = _start_position


func new_enemy(_type : Enemy, _start_position := Vector2(0, 0)):
	sprite_2d.texture = _type.sprite
	unit_stats.unit_name = _type.name
	unit_stats.max_health = _type.health
	unit_stats.current_health = unit_stats.max_health
	unit_stats.attack_speed = _type.attack_speed
	unit_stats.damage_min = _type.damage_min
	unit_stats.damage_max = _type.damage_max
	unit_stats.defense = _type.defense
	unit_stats.pierce = _type.pierce
	unit_stats.target = _type.target
	position = _start_position


func _ready():
	randomize()
	
	attack_buffer = randf_range(0, 1)
	unit_stats.attack_speed += attack_buffer
	
	# Set progress bars and start attack timer
	health_bar.max_value = unit_stats.max_health
	health_bar.value = unit_stats.current_health
	
	attack_timer.start(unit_stats.attack_speed)
	attack_bar.max_value = unit_stats.attack_speed
	attack_bar.value = attack_bar.max_value - attack_timer.time_left


func _process(delta):
	# Update progress bars
	health_bar.value = unit_stats.current_health
	attack_bar.max_value = unit_stats.attack_speed
	attack_bar.value = attack_bar.max_value - attack_timer.time_left


func _on_attack_timer_timeout():
	attack.emit(random.randi_range(unit_stats.damage_min, unit_stats.damage_max), 
				unit_stats.pierce, 
				unit_stats.target
	)
	attack_timer.start(unit_stats.attack_speed - attack_buffer)
	attack_bar.value = 0


func resolve_attack(
		damage: int,
		pierce: int,
		target: Unit.TARGET,
		allies: Array[Unit],
		enemies: Array[Unit]
):
	var units_to_remove: Array[Unit] = []
	
	match target:
		Unit.TARGET.ALL:
			for enemy in enemies:
				if enemy.hurt(damage, pierce):
					units_to_remove.append(enemy)
		Unit.TARGET.RANDOM:
			var enemy = enemies.pick_random()
			if enemy != null and enemy.hurt(damage, pierce):
				units_to_remove.append(enemy)
		Unit.TARGET.HEAL:
			var injured_allies: Array[Unit] = []
			for ally in allies:
				if ally.unit_stats.current_health < ally.unit_stats.max_health:
					injured_allies.append(ally)
				var target_ally = (
					injured_allies.pick_random()
					if injured_allies.size() > 0
					else allies.pick_random()
				)
				if target_ally != null:
					target_ally.heal(damage)
	
	for unit in units_to_remove:
		enemies.erase(unit)
		unit.queue_free()


func hurt(amount: int, piercing: int) -> bool:
	var _is_dead = false
	# Calculate damage after defense, can't be less than 0
	var _effective_defense = max(0, unit_stats.defense - piercing)
	var _damage = max(0, amount - _effective_defense)
	
	var hit_number := DAMAGE_NUMBER.instantiate()
	self.get_parent().add_child(hit_number)
	hit_number.set_text(str(_damage))
	hit_number.position = self.position
	hit_number.set_color(Color.RED) if _damage > 0 else hit_number.set_color(Color.WHITE)
	
	unit_stats.current_health -= _damage
	if unit_stats.current_health <= 0: _is_dead = true
	
	return _is_dead


func heal(amount: int):
	var hit_number := DAMAGE_NUMBER.instantiate()
	self.get_parent().add_child(hit_number)
	hit_number.set_text(str(amount))
	hit_number.position = self.position
	hit_number.set_color(Color.GREEN)
	
	unit_stats.current_health = min(unit_stats.current_health + amount, unit_stats.max_health)
