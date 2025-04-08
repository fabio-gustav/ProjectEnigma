extends Node

var money : int = 0
var health : int = 0
var max_health : int = 3
var energy : int = 3
var max_energy : int = 3
var max_money : int = 9999


func transaction(moneyChange):
	if (money + moneyChange < max_money && money + moneyChange > 0):
		money += moneyChange
		SignalBus.money_changed.emit()
	else:
		print("No")
