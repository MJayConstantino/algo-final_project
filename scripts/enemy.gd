extends Node3D

@export var target_path: NodePath  # Assign your player node here in the editor
var target: Node3D

@onready var physical_skel: Skeleton3D = $Physical/Armature/Skeleton3D

# Movement strength that you can adjust
var speed: float = 20.0

func _ready():
	# Start the ragdoll simulation for all physical bones
	physical_skel.physical_bones_start_simulation()
	target = get_node(target_path)

func _physics_process(delta):
	if target:
		# Get all the physical bones in the ragdoll
		var bones = physical_skel.get_children().filter(func(x): return x is PhysicalBone3D)
		if bones.size() == 0:
			return

		# Calculate the approximate center of mass of the ragdoll by averaging bone positions
		var center: Vector3 = Vector3.ZERO
		for bone in bones:
			center += bone.global_transform.origin
		center /= bones.size()
		
		# Calculate the movement direction from the center to the target
		var direction: Vector3 = (target.global_transform.origin - center).normalized()
		
		# Apply movement by setting linear_velocity for each bone (or add forces if preferred)
		for bone in bones:
			# Option 1: Directly set the velocity of each bone
			bone.linear_velocity = direction * speed
			# Option 2: Alternatively, you could use bone.apply_central_impulse(direction * speed * delta)
			# to apply an impulse force rather than directly setting the velocity.
