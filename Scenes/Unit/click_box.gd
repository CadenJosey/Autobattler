extends TextureRect

@onready var indicator: Node = $Indicator
@onready var unit: Node = get_parent()

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	indicator.visible = false  # hidden by default

func _on_mouse_entered() -> void:
	if get_parent().team == Unit.TEAM.PLAYER:
		indicator.visible = true

func _on_mouse_exited() -> void:
	indicator.visible = false
