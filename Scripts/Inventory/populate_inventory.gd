extends Control

@onready var slotControl: Node = $InventorySlots
const INVENTORY_SLOT = preload("res://Scenes/Inventory/inventory_slot.tscn")


func _ready() -> void:
	for i in range(6):
		for j in range(6):
			var inv_slot := INVENTORY_SLOT.instantiate()
			slotControl.add_child(inv_slot)
