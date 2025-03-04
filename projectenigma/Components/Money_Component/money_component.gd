extends Node
class_name Money_Component

@export var MAX_MONEY := 9999
@export var money:float
signal money_change

func _ready() -> void:
	money = 0
	PlayerVariables.money = 0
	
func transaction(moneyChange : float):
	money += moneyChange
	PlayerVariables.money = money
	SignalBus.money_changed.emit()
