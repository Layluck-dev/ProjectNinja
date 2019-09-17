extends Spatial

const SCHUT_SPEED = 100
const MAX_LAZOR_CHARGE = 5
const CHARGE_RATE = 5
var lazorCharge = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if (Input.is_action_just_pressed("ui_cancel")):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()
	if (Input.is_action_just_pressed("restart")):
		get_tree().reload_current_scene()
	
	#If the lazor has charge but isn't being charged decharge it
	if lazorCharge > 0:
		lazorCharge -= delta
	
	#Updates the charge bar
	$Player/ShutBar.set_value(lazorCharge)
	
	#schüt lazor
	if (Input.is_action_pressed("lmb")):
		
		#Charge lazor if it is below the max charge
		if lazorCharge < MAX_LAZOR_CHARGE:
			lazorCharge += delta * CHARGE_RATE
		
		#If the lazor is at max charge or above shoot
		if lazorCharge == MAX_LAZOR_CHARGE or lazorCharge > MAX_LAZOR_CHARGE:
			
			#get the spawn location and directions
			var spawnloc = $Player/Head/Camera/LazorSpawn.get_global_transform()
			var lazorDirection = $Player/Head/Camera.get_global_transform().basis
			var spawnvel = Vector3()
			
			#give the laser a forward velocity
			spawnvel -= lazorDirection.z * SCHUT_SPEED
			
			#instansiate the lazor and set the location and velocity
			var lazor = preload("res://Lazor.tscn").instance()
			lazor.set_global_transform(spawnloc)
			lazor.set_linear_velocity(spawnvel)
			
			#spawn lazor
			get_tree().get_root().add_child(lazor)
			
			#Reset lazor charge to 0
			lazorCharge = 0
		
func _input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
