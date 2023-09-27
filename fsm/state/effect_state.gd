extends State

class_name InterruptedState

func handle(input: Dictionary) -> Dictionary:
	var output: Dictionary = {'state': 'idle'}
	var tween: Tween = input['tween']
	wait_for_tween(tween)
	var data: Dictionary = await done
	match data['message']:
		'interrupted': # 만약 interrupt 당한 것이라면
			tween.stop()
			token.ability.on_interrupted()
			output = data # interrupt 호출 시 넘겨진 data
		'tween ended':
			if 'effect' in input:
				input['effect'].call()
	return output
