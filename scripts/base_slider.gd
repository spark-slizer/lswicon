extends Panel

@onready var label = $Label
@onready var slider = $HSlider
@export var parameter_name:String
@export var value_ending:String
@export var value:float
@export var min_value:float
@export var max_value:float

func _ready():
	slider.min_value = min_value
	slider.max_value = max_value
	slider.value = value

func _process(_delta):
	value = slider.value
	label.text = parameter_name+": "+str(slider.value)+value_ending
