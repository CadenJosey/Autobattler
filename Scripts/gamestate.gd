extends Node

var party_inventory: Inventory
var party_units: Array[Unit]

func _ready():
	party_inventory = Inventory.new()
