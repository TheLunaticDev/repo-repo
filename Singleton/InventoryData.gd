extends Resource

var distinctItemCount :int : set = _set_distinctItemCount, get = _get_distinctItemCount
var inventory :Array :set = _set_inventory

func _set_distinctItemCount(items :int) -> void:
	distinctItemCount = items
func _get_distinctItemCount() -> int:
	return distinctItemCount

func _set_inventory(items :Array) -> void:
	inventory = items
