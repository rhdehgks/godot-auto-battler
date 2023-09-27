extends Ability

class_name GrabAbility

func get_effects() -> Dictionary:
	var effects: Dictionary = {}
	
	var target: Token = null
	var target_dist: int = 0
	
	var to: Vector2i
	var to_dist: int = 999999999
	
	for i in range(Board.board_size):
		for j in range(Board.board_size):
			var crd: Vector2i = Vector2i(i, j)
			var token: Token = Board.get_token(crd)
			if token == null:
				var dist: int = Utility.get_weighted_distance(caster.crd, crd)
				if to_dist > dist:
					to = crd
					to_dist = dist
			elif token.stat.camp != caster.stat.camp:
				var dist: int = Utility.get_weighted_distance(caster.crd, token.crd)
				if target_dist < dist:
					target = token
					target_dist = dist
	
	if target == null:
		return {}
	
	Board.set_token(target.crd, null)
	Board.set_token(to, target)
	target.crd = to
	
	var tween: Tween = target.create_tween()
	tween.tween_property(target, "position", Board.to_pos(to), 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): caster.fsm.get_state('idle').target = target)
	tween.tween_callback(func(): caster.set_health(200)).set_delay(0.05)
	tween.tween_callback(func(): target.set_health(-200)).set_delay(0.05)
	effects[target] = {'state': 'interrupted', 'tween': tween}
	
	return effects

func on_interrupted() -> void:
	pass
