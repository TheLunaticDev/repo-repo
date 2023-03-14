extends Resource

class_name Item

@export var id :int
@export var name :String
@export_multiline var description :String
@export var texture :Texture2D
@export var amount :int
@export var maxAmount :int
@export var value :int

func discard(quantity := 0) -> int:
	amount -= quantity
	if (amount < 0):
		amount = 0
	return amount
