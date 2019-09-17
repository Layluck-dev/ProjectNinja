extends RigidBody

const MAX_LIFE_TIME = 5
var lifeTime = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_max_contacts_reported(1)
	#set_use_continuous_collision_detection(true)
	#pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	#age the lazor
	lifeTime += delta
	
	#If the lazor is older than a certain age despawn
	if lifeTime > MAX_LIFE_TIME:
		despawn()
	
	#If the lazor collides with anything despawn
	var hitcount = get_colliding_bodies()
	if hitcount.size() > 0:
		despawn()

#despawn function, explosion to be added.
func despawn():
	
	#load the resulting 'explosion' and get it's spawn location
	var EXP = preload("res://EXP.tscn").instance()
	var spawnloc = get_global_transform()
	
	#despawn lazor
	queue_free()
	
	#set spawn location
	EXP.set_global_transform(spawnloc)
	
	#spawn explosion
	get_tree().get_root().add_child(EXP)
	
	