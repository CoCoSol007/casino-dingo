extends Control

# de 1 a 13
var num = 1
# de 1 a 4
var couleur = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	gen_rdm_cart()
	var nums_textures = get_nums()
	set_num_texture(nums_textures)
	var color_texture = get_color()
	set_color_texture(color_texture)
	

func set_color_texture(texture):
	for i in range(1, 3):
		var container = get_node("VBoxContainer"+ str(i))
		container.get_node("color").set_texture(texture)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func get_color():
	var col = "trefle"
	
	if couleur == 2:
		col = "carreau" 
	elif couleur == 2:
		col = "pique" 
	
	elif couleur == 4:
		col = "coeur" 
		
	return load(str("res://assets/PlayCartAssets/",col,".png"))

func set_num_texture(nums):
	for i in range(1, 3):
		var container = get_node("VBoxContainer"+ str(i))
		container.get_node("num").set_texture(nums[0])
		container.get_node("num2").set_texture(nums[1])

	
	
func get_nums():
	var new_num = str(num)
	var al = randi_range(1,4)
	if num == 1:
		new_num = "a"
		
	elif num == 10:
		
		if al == 1:
			new_num = "1"
		elif al == 2:
			new_num = "j"	
		elif al == 3:
			new_num = "q"	
		elif al == 4:
			new_num = "k"	
		
		
	
	var ret = [load(str("res://assets/PlayCartAssets/" , new_num , ".png")), null]
	
	if num == 10:
		if al == 1:
			ret[1] =  load("res://assets/PlayCartAssets/0.png")
	
	return ret

func gen_rdm_cart():
	num = randi_range(1,10)
	couleur = randi_range(1,4)
