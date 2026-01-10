extends Node2D

@onready var label = $Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= delta * 50
	position.x += delta * 10
	

func set_text(_text : String):
	label.text = _text


func set_color(_color : Color):
	label.add_theme_color_override("font_color", _color)


func _on_timer_timeout():
	queue_free()
