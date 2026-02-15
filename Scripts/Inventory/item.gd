class_name Item
extends Resource

enum ItemType {
	HELMET,
	WEAPON,
	ARMOR
}

@export var name : String
@export var sprite : AtlasTexture
@export var type : Item.ItemType
@export var stat_modifiers : StatBlock
