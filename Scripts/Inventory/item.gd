class_name Item
extends Resource
var random = RandomNumberGenerator.new()

enum ItemType {
	HELMET,
	WEAPON,
	ARMOR
}

@export var name : String
@export var sprite : AtlasTexture
@export var type : Item.ItemType
@export var stat_modifiers : StatBlock

func rand_item():
	var item_result = Item.new()
	item_result.type = ItemType.values().pick_random()
	item_result.sprite = preload("res://Assets/Sprites/Items/item.tres")
	item_result.name = "Test item"
	item_result.stat_modifiers = StatBlock.new()
	
	item_result.stat_modifiers.damage_max = 1
	item_result.stat_modifiers.damage_min = 1
	
	return item_result
