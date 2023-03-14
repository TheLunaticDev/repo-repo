extends ColorRect

signal dialogue_started
signal dialogue_ended
signal dialogue_skipped

var dialogues :Dictionary
var currentDialogues :Dictionary
var currentDialogueId :int
var tween :Tween
@export var readingSpeed := 200.0 # words per second
@export_file var dialogueLocation :String
@export_file var potraitLocation :String
@onready var Name := $Name
@onready var Text := $Text
@onready var Potrait := $Potrait

func _ready() -> void:
	load_dialogues()

func _process(_delta: float) -> void:
	if Text.visible_ratio < 1.0:
		$Pointer.visible = false
		if Input.is_action_just_pressed("ui_accept"):
			tween.stop()
			$Text.visible_ratio = 1.0
			emit_signal("dialogue_skipped")
	else:
		$Pointer.visible = true
		if Input.is_action_just_pressed("ui_accept"):
			advance_dialogue()

func load_dialogues() -> void:
	var file = FileAccess.open(dialogueLocation, FileAccess.READ)
	if file == null:
		print("Cannot find file.")
		return
	var content = file.get_as_text()
	if content == "":
		print("Found empty file.")
		return
	dialogues = JSON.parse_string(content)
	if dialogues == null:
		print("Error parsing the JSON file.")
		return
	file = null

func get_dialogues(Id :String) -> void:
	for id in dialogues:
		if id == Id:
			currentDialogues = dialogues[Id]
			start_dialogue()
			return
	print("Couldn't find the specified dialogue. Maybe check your id (String)?")

func start_dialogue() -> void:
	emit_signal("dialogue_started")
	self.visible = true
	currentDialogueId = 1
	show_dialogue()

func show_dialogue() -> void:
	Text.visible_ratio = 0.0
	Name.text = currentDialogues[str(currentDialogueId)]["Name"]
	var unknownPotrait = potraitLocation + "unknown.png"
	var potraitName = potraitLocation + Name.text + currentDialogues[str(currentDialogueId)]["Expression"] + ".png"
	Potrait.texture = load(potraitName)
	if Potrait.texture == null:
		Potrait.texture = load(unknownPotrait)
	Text.text = currentDialogues[str(currentDialogueId)]["Text"]
	show_gradual_dialogue()

func advance_dialogue() -> void:
	currentDialogueId += 1
	if (currentDialogueId <= currentDialogues.size()):
		show_dialogue()
	else:
		emit_signal("dialogue_ended")
		self.visible = false

func show_gradual_dialogue() -> void:
	tween = get_tree().create_tween()
	var characters = Text.text.length()
	tween.tween_property(Text, "visible_ratio", 1.0, (characters / (readingSpeed * 5)) * 60)
