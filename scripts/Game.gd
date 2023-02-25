extends Spatial
var florrArray=[]
var preFloor=null
var currentFlorr =null
var currentBuilding =null
var currentGroundFloor=null
var ufo=null
var floorCount=0
var buildingCount=0
onready var Road = preload("res://scenes/Road.tscn")
onready var UFOscene = preload("res://scenes/myship.tscn")
onready var Floorscene = preload("res://scenes/Ground.tscn")
onready var area = $Area
var sceneArray =[preload("res://scenes/Building1.tscn"),preload("res://scenes/Building2.tscn"),preload("res://scenes/Building3.tscn"),preload("res://scenes/Building4.tscn")]

func _spawnRoad():
	randomize()
	currentFlorr = Road.instance()
	currentFlorr.translation=preFloor.get_node("edge").global_transform.origin
	preFloor=currentFlorr
	add_child(currentFlorr)
	floorCount+=1
	#print(currentFlorr.global_translation)
	#print(florrArray)
func _spawnFloor():
	var goundfloor = Floorscene.instance()
	goundfloor.translation=Vector3(preFloor.get_node("buildingSpawn").global_transform.origin.x,-0.3,preFloor.get_node("buildingSpawn").global_transform.origin.z)
	add_child(goundfloor)
	currentGroundFloor=goundfloor
	buildingCount+=1
func _spawnBuilding():
	var buildingScene=sceneArray[randi()%sceneArray.size()]
	currentBuilding = buildingScene.instance()
	currentBuilding.translation=Vector3(currentGroundFloor.get_node("buildingSpawn").global_transform.origin.x,-1,currentGroundFloor.get_node("buildingSpawn").global_transform.origin.z)
	add_child(currentBuilding)
	buildingCount+=1
	#print(currentBuilding.translation)
func _ready():
	currentFlorr=Road.instance()
	currentFlorr.translation=Vector3(0,0,0)
	preFloor=currentFlorr
	add_child(currentFlorr)
	_spawnFloor()
	_spawnBuilding()
	floorCount+=1
	for x in range(20):
		_spawnRoad()
		_spawnFloor()
		_spawnBuilding()
	_spawnUFO()
	
	area.get_parent().remove_child(area)
	var newParent = get_node("myship")
	newParent.add_child(area)
	#print(preFloor.global_transform.origin)
	#print(preFloor.get_node("edge").global_transform.origin)

func _spawnUFO():
	ufo = UFOscene.instance()
	#ufo.translation=Vector3(0,-0.225,0)
	add_child(ufo)
	
func _process(delta):
	#print(preFloor.translation)
	#print(preFloor.get_node("edge").transform.origin)
	#print(get_tree().get_nodes_in_group("floor").size(),"-->",get_tree().get_nodes_in_group("Buildings").size())
	pass

func _on_Area_body_exited(body):
	body.queue_free()
	_spawnRoad()


func _on_Area_body_entered(body):
	body.queue_free()
	if body is StaticBody:
		pass
	elif body is KinematicBody and body.is_in_group("floor"):
		floorCount-=1
		buildingCount-=1
		_spawnRoad()
		_spawnFloor()
		_spawnBuilding()
		

func _on_Area_area_entered(area):
	pass # Replace with function body.
