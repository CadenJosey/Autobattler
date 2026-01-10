extends Node2D
class_name Unit
var random = RandomNumberGenerator.new()


@export var sprite_2d : Sprite2D
@onready var attack_bar = %AttackBar
@onready var health_bar = %HealthBar
@onready var attack_timer = %AttackTimer


const DAMAGE_NUMBER = preload("res://Scenes/Battle/damage_number.tscn")


var unit_name : String
var max_health : int
var current_health : int
var attack_speed : float
var damage_min : int
var damage_max : int
var defense : int
var start_position : Vector2
var target : Unit.TARGET

var attack_buffer : float


enum TARGET {
	RANDOM, # Choose a random member of the enemy team
	ALL,    # All enemies
	HEAL,   # Heal a random ally
	
}


signal attack(_damage: int, _target: Unit.TARGET)


func new_adventurer(_class : Adventurer, _start_position := Vector2(0, 0)):
	sprite_2d.texture = _class.sprite
	unit_name = _class.name
	max_health = _class.health
	current_health = max_health
	attack_speed = _class.attack_speed
	damage_min = _class.damage_min
	damage_max = _class.damage_max
	defense = _class.defense
	target = _class.target
	position = _start_position


func new_enemy(_type : Enemy, _start_position := Vector2(0, 0)):
	sprite_2d.texture = _type.sprite
	unit_name = _type.name
	max_health = _type.health
	current_health = max_health
	attack_speed = _type.attack_speed
	damage_min = _type.damage_min
	damage_max = _type.damage_max
	defense = _type.defense
	target = _type.target
	position = _start_position


func _ready():
	randomize()
	
	attack_buffer = randf_range(0, 1)
	attack_speed += attack_buffer
	
	# Set progress bars and start attack timer
	health_bar.max_value = max_health
	health_bar.value = current_health
	
	attack_timer.start(attack_speed)
	attack_bar.max_value = attack_speed
	attack_bar.value = attack_bar.max_value - attack_timer.time_left


func _process(delta):
	# Update progress bars
	health_bar.value = current_health
	attack_bar.max_value = attack_speed
	attack_bar.value = attack_bar.max_value - attack_timer.time_left


func _on_attack_timer_timeout():
	attack.emit(random.randi_range(damage_min, damage_max), target)
	attack_timer.start(attack_speed - attack_buffer)
	attack_bar.value = 0


func hurt(amount: int) -> bool:
	var _is_dead = false
	# Calculate damage after defense, can't be less than 0
	var _damage = max(0, amount - defense)
	
	var hit_number := DAMAGE_NUMBER.instantiate()
	self.get_parent().add_child(hit_number)
	hit_number.set_text(str(_damage))
	hit_number.position = self.position
	hit_number.set_color(Color.RED) if _damage > 0 else hit_number.set_color(Color.WHITE)
	
	current_health -= _damage
	if current_health <= 0: _is_dead = true
	
	return _is_dead


func heal(amount: int):
	var hit_number := DAMAGE_NUMBER.instantiate()
	self.get_parent().add_child(hit_number)
	hit_number.set_text(str(amount))
	hit_number.position = self.position
	hit_number.set_color(Color.GREEN)
	
	current_health = min(current_health + amount, max_health)
