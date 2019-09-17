extends Spatial

const MAX_LIFE_TIME = 10
var lifeTime = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	#var hitcount = $shockWave.get_slide_count()
	#if hitcount > 0:
		#var collision = $shockWave.get_slide_collision(0)
		#if collision.collider is RigidBody:
		#collision.collider.apply_impulse(collision.position, -collision.normal*0.1)
	
	if lifeTime < MAX_LIFE_TIME:
		lifeTime += delta
	
	#if lifeTime < MAX_LIFE_TIME/10:
#		var lightRange = $Flash.get_omni_range()
#		lightRange += delta * 3
#		$Flash.set_omni_range(lightRange)
	
	if lifeTime > 0.15:
		$Flash.hide()
	
	if lifeTime > MAX_LIFE_TIME/10:
		$Fast.set_emitting(false)
		
#		if $Flash.get_omni_range() > 0:
#			var lightRange = $Flash.get_omni_range()
#			lightRange -= delta * 3
#			$Flash.set_omni_range(lightRange)
	
	if lifeTime > MAX_LIFE_TIME/4:
		$Cloud.set_emitting(false)
	
	if lifeTime == MAX_LIFE_TIME or lifeTime > MAX_LIFE_TIME:
		
		queue_free()
