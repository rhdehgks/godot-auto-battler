extends Ability

class_name WarpAbility

func get_effects() -> Dictionary:
	var effects: Dictionary = {}
	
	var empty_tiles: Array[Vector2i] = []
	
	for i in range(Board.board_size):
		for j in range(Board.board_size):
			var crd: Vector2i = Vector2i(i, j)
			if Board.get_token(crd) == null:
				empty_tiles.append(crd)
				
	var to: Vector2i = empty_tiles[Game.rng.randi_range(0, len(empty_tiles) - 1)]
	
	Board.set_token(caster.crd, null)
	Board.set_token(to, caster)
	caster.crd = to
	
	var tween: Tween = caster.create_tween()
	tween.tween_property(caster, "modulate", Color(1, 1, 1, 0), 0.3).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	tween.tween_callback(func(): caster.position = Board.to_pos(to))
	tween.tween_callback(func(): caster.set_health(500)).set_delay(0.05)
	tween.tween_property(caster, "modulate", Color(1, 1, 1, 1), 0.3).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	effects[caster] = {'state': 'interrupted', 'tween': tween}
	return effects

func on_interrupted() -> void:
	caster.modulate = Color(1, 1, 1, 1)
