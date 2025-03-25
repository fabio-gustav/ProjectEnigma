class_name fish extends Node

#Note: if we add fish pictures eventually it would probably go into the arrays

# to be accesed with each name and descirption matching in this 2d array
static var fishNamesAndDescriptions = [["Name1", "Description1"], ["Name2", "Description2"], ["Name3", "Description3"], ["Name4", "Description4"], ["Name5", "Description5"]]

#for if you fish up trash
static var trashNamesAndDescriptions = [["Name1", "Description1"], ["Name2", "Description2"], ["Name3", "Description3"], ["Name4", "Description4"], ["Name5", "Description5"]]

var rarity : float # on a scale from 1.0 to 10.0 with 10 being the most rare
var weight : float
var value : float # maybe also used for fishe's catch difficulty
var fishName : String # note name is a key word apparently so thats why this isn't just name
var description : String
var type : String # to potentially be used if we want fish to be different based on location ex: river fish, sea fish, jungle fish, etc


#fishing ability is on a scale from 1.0 to 10.0 with 10 being the best
func makeFish(fishingAbility):
	var random = RandomNumberGenerator.new()
	rarity = random.randf_range(0.01, 1.0) * fishingAbility
	weight = random.randf_range(0.01, 5.0) * (fishingAbility/5) # so weight is more random
	value = rarity * weight
	var temp = fishNamesAndDescriptions[random.randf_range(0, fishNamesAndDescriptions.size())]
	fishName = temp[0]
	description = temp[1]
	type = "Sea Fish"
	
	
#called if you fish up trash instead of a fish
func makeTrash():
	var random = RandomNumberGenerator.new()
	rarity = 0
	weight = random.randf_range(0.2, 2.5)
	value = 0
	var temp = trashNamesAndDescriptions[random.randf_range(0, trashNamesAndDescriptions.size())]
	fishName = temp[0]
	description = temp[1]
	type = "Trash"
	
	
func toString():
	var temp = "Rarity: " + str(rarity) + "\nWeight: " + str(weight) + "\nValue: " + str(value) + "\nName: " + fishName + "\nDescription: " + description + "\nType: " + type;
	return temp
