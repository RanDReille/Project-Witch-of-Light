extends "res://Game Assets/Entities/entity.gd"

var contact_damage = 10

func _physics_process(delta):
	pass

func _on_hitbox_body_entered(body):
	if body == Global.game.player && contact_damage > 0:
		body.take_damage(contact_damage, self.global_position)
		
