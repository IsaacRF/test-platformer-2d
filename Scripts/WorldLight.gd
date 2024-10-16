extends DirectionalLight2D

@export var day_color: Color
@export var noon_color: Color
@export var night_color: Color

enum DayState { DAY, NOON, NIGHT}
@onready var color_map: Dictionary = {
	DayState.DAY: day_color,
	DayState.NOON: noon_color,
	DayState.NIGHT: night_color
}

func _ready():
	#TODO: Force update the light at load for now. Can later be changed to add a clock check system
	update_light(DayState.NIGHT)

func update_light(day_state: DayState) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "color", color_map[day_state], 1)
