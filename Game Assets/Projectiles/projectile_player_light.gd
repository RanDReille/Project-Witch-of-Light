extends "res://Game Assets/Projectiles/projectile.gd"

func interact_with_body(body):
	if body.is_in_group("Enemy"):
		if Global.game.player_berserk_timer <= 0:
			Global.game.player_berserk += Global.game.player_stat["berserk_hit_gain"]
		body.take_damage(damage, global_position)
		return true
	return false
