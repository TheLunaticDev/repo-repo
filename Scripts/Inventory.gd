extends ColorRect

var gridContainerPosition :Vector2
var panelLocation = [Vector2(0,0), Vector2(94,0), Vector2(188,0), Vector2(281,0),
Vector2(374,0), Vector2(467,0), Vector2(0,105), Vector2(94,105),
Vector2(188, 105), Vector2(281, 105), Vector2(374,105), Vector2(467,105)]
var selectedPanel :int
var tween :Tween
@export var animationSpeed :float

func _ready() -> void:
	gridContainerPosition = $GridContainer.position
	selectedPanel = 0

func _process(delta: float) -> void:
	tween = get_tree().create_tween()
	var target_position = gridContainerPosition + panelLocation[selectedPanel]
	tween.tween_property($Selected, "position", target_position, animationSpeed).set_ease(Tween.EASE_OUT)
	#$Selected.position = gridContainerPosition + panelLocation[selectedPanel]
	if Input.is_action_just_pressed("ui_right"):
		selectedPanel += 1
		if selectedPanel > 11:
			selectedPanel = 0
	if Input.is_action_just_pressed("ui_left"):
		selectedPanel -= 1
		if selectedPanel < 0:
			selectedPanel = 11
	if Input.is_action_just_pressed("ui_up") || Input.is_action_just_pressed("ui_down"):
		if selectedPanel >= 0 and selectedPanel <= 5:
			selectedPanel += 6
		elif selectedPanel >= 6 and selectedPanel <= 11:
			selectedPanel -= 6
	print(selectedPanel)
