extends State

class_name AttackState

func handle(input: Dictionary) -> Dictionary:
	var output: Dictionary = {'state': 'idle'}
	var target: Token = input['target']
	var tween: Tween = attack(target, token.stat.attack_speed)
	wait_for_tween(tween)
	var data: Dictionary = await done
	match data['message']:
		'interrupted': # 만약 interrupt 당한 것이라면
			tween.stop()
			output = data
		'tween ended':
			token.signals.attacked.emit(token.stat.physical_damage, target)
			target.signals.be_damaged.emit(token.stat.physical_damage, token)
	return output
	
func attack(target: Token, attack_speed: int) -> Tween:
	var token_pos = token.position
	var target_pos = Board.to_pos(target.crd)
	target_pos = token_pos + (target_pos - token_pos).normalized() * 16
	var time: float = 100.0 / attack_speed
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(token, "position", target_pos, time / 2).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	tween.tween_property(token, "position", token_pos, time / 2).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	return tween
