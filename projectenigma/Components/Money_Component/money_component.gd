extends Node
class_name Money_Component

@export var MAX_MONEY := 9999
@export var money:float
signal money_change

func _ready() -> void:
	money = 0
	PlayerVariables.money = 0
	SignalBus.connect("changeMoney", transaction)
	
func transaction(moneyChange):
	if (money + moneyChange < MAX_MONEY && money + moneyChange > 0):
		money += moneyChange
		PlayerVariables.money = money
		SignalBus.money_changed.emit()
	else:
		print("No")
