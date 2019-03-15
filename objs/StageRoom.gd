extends Node2D

# person

var player = Char.new()
var Room_gd = load("res://d/baihuagu/baihuagu.gd")
var current_room = Room_gd.new()
var rooms = {}
var map_file = File.new()
# 1  2  3
# 4  5  6
# 7  8  9 
var neighbor_rooms = {}
var food

func _ready():
	rooms.current = $Rooms/room
	rooms.north = $Rooms/room_n
	rooms.south = $Rooms/room_s
	rooms.west = $Rooms/room_w
	rooms.east = $Rooms/room_e
	rooms.out = $Rooms/room_out
	rooms.in = $Rooms/room_in
	rooms.enter = $Rooms/room_enter
	rooms.westup = $Rooms/room_wu
	rooms.westdown = $Rooms/room_wd
	rooms.eastup = $Rooms/room_eu
	rooms.eastdown = $Rooms/room_ed
	creat_exits(current_room,neighbor_rooms)
	$RoomPanel/VBoxContainer/RoomName.bbcode_text = "[center]" + current_room.query("short") +"[/center]"
	$RoomPanel/VBoxContainer/Description.bbcode_text  = current_room.query("long")
	# load map
	map_file.open("res://doc/map/baihuagu",File.READ)
#	print(map_file.get_as_text())
	$RoomMessage/RichTextLabel.bbcode_text = map_file.get_as_text()
#	current_room.get_dir()
	food = load("res://clone/food/apple.gd").new()
	print_debug(food)
	object_panel(food)
	player = Global.this_player()
	# print_debug(player is GameObject)
	player.carry_object("/clone/food/apple")
	print_debug(player.query("objects"))
	character_panel(player)

func creat_exits(room:GameObject,neighbor_rooms):
	var x
	var line = Line2D.new()
	var exits = room.query("exits")
	$Rooms/room.show()
	$Rooms/room/RichTextLabel.bbcode_text = "[center]" + room.query("short") +"[/center]"
	for direct in exits:
		if exits[direct] :
			neighbor_room_creat(room,direct,neighbor_rooms)	
			
func neighbor_room_creat(room,direct,neighbor_rooms):
#	print(exits[direct] + ".gd")
	var exits = room.query("exits")
	neighbor_rooms[direct] = load(exits[direct] + ".gd").new()
	rooms[direct].show()
	rooms[direct].connect("pressed",self,"move_to_room",[direct])
	rooms[direct].get_child(0).bbcode_text = "[center]" + neighbor_rooms[direct].query("short") +"[/center]"
#	rooms[direct].get_child().(neighbor_rooms[direct].query("short"))
	pass			

func move_to_room(direct):
	current_room = neighbor_rooms[direct]
	neighbor_rooms = {}
	for i in rooms:
		rooms[i].hide()
	creat_exits(current_room,neighbor_rooms)
	$RoomPanel/VBoxContainer/RoomName.bbcode_text = "[center]" + current_room.query("short") +"[/center]"
	$RoomPanel/VBoxContainer/Description.bbcode_text = current_room.query("long")
	pass

		
func notify_fail(message:String):
	$AcceptDialog.show()
	$AcceptDialog.dialog_text = message
	pass
	
func message_ob(msg,ob):
	$ObjectMessage/RichTextLabel.bbcode_text = msg
#  object panel 	
func object_panel(ob:GameObject):
#		$ObjectRect.show()
		$ObjectRect/Name.bbcode_text = ob.query("name")
		$ObjectRect/Type.text = ob.query("type")
		$ObjectRect/Description.bbcode_text = ob.query("long")
		var props = []
		var prop_nodes = []
		prop_nodes.append($ObjectRect/GridContainer/Prop1)
		prop_nodes.append($ObjectRect/GridContainer/Prop2)
		prop_nodes.append($ObjectRect/GridContainer/Prop3)
		prop_nodes.append($ObjectRect/GridContainer/Prop4)
		prop_nodes.append($ObjectRect/GridContainer/Prop5)
		prop_nodes.append($ObjectRect/GridContainer/Prop6)
		prop_nodes.append($ObjectRect/GridContainer/Prop7)
		prop_nodes.append($ObjectRect/GridContainer/Prop8)
		
		props = creat_props(ob)
		for i in props.size() :
#			if props[i]:
#			var path = "ObjectRect/GridContainer/Prop" + str(1)
			prop_nodes[i].show()
			prop_nodes[i].text = props[i]
	
func creat_props(ob:GameObject):
	var props = []
	for k in ob.dbase:
		match k:
			"unit":
				props.append("单位:" + ob.query(k))
			"value":
				props.append("价值:" + str(ob.query(k)))
			"material":
				props.append("材质:" + ob.query(k))
			"food_remaining":
				props.append("分量:" + str(ob.query(k)))
			"food_supply":
				props.append("饱腹:" + str(ob.query(k)))
			"water_supply":
				props.append("解渴:" + str(ob.query(k)))
			"max_liquid":
				props.append("容量:" + str(ob.query(k)))
			"liquid":
				var liquid = ob.query("liquid")
				for k in liquid:
					match k:
						"name":
							props.append("盛装:" + str(liquid.name))
						"remaining":
							props.append("分量:" + str(liquid.remaining))
						"drunk_supply":
							props.append("饮酒:" + str(liquid.drunk_supply))
						"water_supply":
							props.append("解渴:" + str(liquid.water_supply))
	return props
	

# cha panel

func character_panel(ob:GameObject):
	#		$CharacterRect.show()
			$CharacterPanel/PropContainer/HBoxContainer/VBoxContainer/Nackname.bbcode_text = ob.query("name")
			$CharacterPanel/PropContainer/HBoxContainer/VBoxContainer/Title.text = ob.query("titile")
			$CharacterPanel/PropContainer/HBoxContainer/VBoxContainer/Nackname.text = ob.query("nackname")
#			$CharacterRect/Description.bbcode_text = ob.query("long")
#			var props = []
#			var prop_nodes = []
#			prop_nodes.append($CharacterRect/GridContainer/Prop1)
#			prop_nodes.append($CharacterRect/GridContainer/Prop2)
#			prop_nodes.append($CharacterRect/GridContainer/Prop3)
#			prop_nodes.append($CharacterRect/GridContainer/Prop4)
#			prop_nodes.append($CharacterRect/GridContainer/Prop5)
#			prop_nodes.append($CharacterRect/GridContainer/Prop6)
#			prop_nodes.append($CharacterRect/GridContainer/Prop7)
#			prop_nodes.append($CharacterRect/GridContainer/Prop8)
#
#			props = creat_character_props(ob)
#			for i in props.size() :
#	#			if props[i]:
#	#			var path = "CharacterRect/GridContainer/Prop" + str(1)
#				prop_nodes[i].show()
#				prop_nodes[i].text = props[i]
		
func creat_character_props(ob:GameObject):
	var props = []
	for k in ob.dbase:
		match k:
			"qi":
				props.append("气血:" + str(ob.query(k)))
			"jing":
				props.append("精神:" + str(ob.query(k)))
			"nei":
				props.append("内力:" + str(ob.query(k)))
			"food":
				props.append("食物:" + str(ob.query(k)))
			"water":
				props.append("饮水:" + str(ob.query(k)))
			"water_supply":
				props.append("解渴:" + str(ob.query(k)))
			"max_liquid":
				props.append("容量:" + str(ob.query(k)))
			"liquid":
				var liquid = ob.query("liquid")
				for k in liquid:
					match k:
						"name":
							props.append("盛装:" + str(liquid.name))
						"remaining":
							props.append("分量:" + str(liquid.remaining))
						"drunk_supply":
							props.append("饮酒:" + str(liquid.drunk_supply))
						"water_supply":
							props.append("解渴:" + str(liquid.water_supply))
	return props


func _process(delta):
#	$RichTextLabelCharacter.bbcode_text = character_panel(me)
	pass	

func _on_ChatClose_pressed():
	$ChatMessagePanel.hide()
	pass # Replace with function body.


func _on_ActionButton1_pressed():
	# food.do_eat(player)
	var msg = food.do_eat(player)
	var old_msg = $ObjectMessage/RichTextLabel.bbcode_text
	# print_debug(old_msg)
	object_panel(food)
	$ObjectMessage/RichTextLabel.bbcode_text = old_msg + msg
	pass # Replace with function body.
