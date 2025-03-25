extends Node

var inventory = []
var equipmentBonus : float # max of sqrt(10)
var skillLevel : float # max of sqrt(10) Note: this variable will be determined by the players skill at the fishing game

func catchFish(fishingAbility):
	var random = RandomNumberGenerator.new()
	var trashChance = 0.10/fishingAbility #trashChance starts at 10% and decreases with your fishing ability
	var fishToCatch = fish.new()
	
	if (random.randf_range(0.01, 1.0) > trashChance):
		fishToCatch.makeFish(fishingAbility)
	else:
		fishToCatch.makeTrash()
	inventory.append(fishToCatch)
	

func viewInventory():
	for fish in inventory:
		print(fish.toString() + "\n")#to be replaced with actually changing a list later
		
func fishingGame(equipment):
	equipmentBonus = equipment
	
	#the game is gambling(so fun!)
	var random = RandomNumberGenerator.new()
	skillLevel = random.randf_range(0.01, sqrt(10))
	#end of game code

	var fishingAbility = equipmentBonus * skillLevel
	catchFish(fishingAbility)
	print("You caught a fish!")# to be replaced with an in game thing later
	
