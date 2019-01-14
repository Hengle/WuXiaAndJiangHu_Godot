extends "res://characters/Character.gd"

var skill_anim = null
func _ready():
	# $Balloon.hide()
	pass
	
func _process(delta):
	if can_move:
		for dir in moves.keys():
			if Input.is_action_pressed(dir):
				facing = dir
				if dir == 'left':
					$Balloon.flip_h = true
					$Balloon.offset = Vector2(-16,0)
				elif dir == 'right':
					$Balloon.flip_h = false
					$Balloon.offset = Vector2(16,0)
				else:
					$Balloon.flip_h = false
					$Balloon.offset = Vector2(0,0)
				move(facing)
	
	if Input.is_action_pressed("A"):
		#attack(facing)
		$"Balloon/AnimationPlayer".play("ballon05")
		#$"Skill/AnimatedSprite".play('default')
		# $Balloon.hide()
	if Input.is_action_just_pressed("B"):
		skill_anim = $Skill/Area2D/AnimatedSprite
		#skill_anim.show()
		skill_anim.position = moves[facing]*48
		skill_anim.play('default')
		skill_anim.frame = 0
		$Skill/Label/AnimationPlayer.play("anim_skill")
		#skill_anim.hide()
	