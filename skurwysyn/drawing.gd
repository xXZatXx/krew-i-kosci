extends MarginContainer
@export_category("Dimentions")
@export var width = 512
@export var height = 512
@export var pixelWidth = 8
@export var pixelHeight = 8
@export var pixelTemplate : Control
@export var pixelContainer : Control

var pixelList = []
var indexAgo = null
var colorAgo = null
var readyFinished = false
var mousePressed = false 
var rows = 0
var cols = 0

func _ready():
	pixelTemplate.custom_minimum_size = Vector2(pixelWidth, pixelHeight)
	pixelTemplate.size = Vector2(pixelWidth, pixelHeight)
	rows =  int(width/pixelWidth)
	cols =  int(height/pixelHeight)
	pixelContainer.columns = cols
	for x in (rows*cols):
			var pixel = pixelTemplate.duplicate()
			pixelList.append(pixel)
			pixelContainer.add_child(pixel)
	
	pixelTemplate.visible = false
	
	await get_tree().process_frame 
	readyFinished = true
func _draw():
	pass
	
func _input(event):
	if readyFinished:
		if event is InputEventMouseButton:
			# mouse clicked or unclicked
			if mousePressed:
				mousePressed = false
			else:
				mousePressed = true
			
		elif event is InputEventMouseMotion and event.position.x<=width+pixelWidth/2 and event.position.y<=height+pixelHeight/2: 
			if indexAgo != null and indexAgo >= 0 and colorAgo == Color(100, 100, 0):
				pixelList[indexAgo].color = Color(255, 255, 255)
			
			# mouse position
			var xCord = remap(event.position.x, 0, width, 0, rows)
			var yCord = remap(event.position.y, 0, height, 0, cols)
			
			xCord = floor(xCord)
			yCord = floor(yCord)
			
			var index = getIndex(xCord, yCord, rows)
			if index >= len(pixelList):
				index = len(pixelList)-1
			if pixelList[index].color != Color(255, 0, 0):
				pixelList[index].color = Color(100, 100, 0)
			if mousePressed:
				pixelList[index].color = Color(255, 0, 0)
			indexAgo = index
			colorAgo = pixelList[index].color
		
		
func getIndex(x, y, width):
	return int(((y-1)*width + x) -2)
	
