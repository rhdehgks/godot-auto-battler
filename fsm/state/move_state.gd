extends State

class_name MoveState

func handle(input: Dictionary) -> Dictionary:
	var next = input['next']
	var output: Dictionary = {'state': 'idle'}
	var tween = move(next, token.stat.move_speed)
	wait_for_tween(tween)
	var data: Dictionary = await done
	match data['message']:
		'interrupted': # 만약 interrupt 당한 것이라면
			tween.stop()
			output = data # interrupt 호출 시 넘겨진 data
	return output

func move(to: Vector2i, move_speed: int) -> Tween:
	var to_pos = Board.to_pos(to)
	Board.set_token(token.crd, null)
	Board.set_token(to, token)
	token.crd = to
	var time: float = 100.0 / move_speed
	var tween: Tween = create_tween()
	tween.tween_property(token, "position", to_pos, time).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
	return tween
