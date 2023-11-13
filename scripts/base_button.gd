extends Panel

@onready var label = $Label
@onready var button = $Button
@export var parameter_name:String
@export var button_name:String

signal pressed

func _ready():
	label.text = parameter_name
	button.text = button_name

func _on_button_pressed():
	pressed.emit()
