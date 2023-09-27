extends Node2D

class_name State

@onready var token: Token = get_parent().get_parent()

# 작업이 종료될 때 호출 됨.
signal done(data: Dictionary)

# time만큼 기다릴 때 호출함.
# 해당 함수를 직접 await하면 안 되고, 호출만 한 뒤 done signal을 await해야 함.
# 다른 await용 함수들도 이 형식대로 구현해야 함.
func wait_for_time(time: float):
	await get_tree().create_timer(time).timeout
	done.emit({'message': 'time ended'})

# Tween이 종료될 때까지 기다림.
func wait_for_tween(tween: Tween):
	await tween.finished
	done.emit({'message': 'tween ended'})

# 어차피 오버라이딩 될 예정이라 참고용으로 코드를 작성함.
# 사실 더 유연하게 코드를 작성할 수도 있겠지만
# 일단 signal과 handle, stop 정도만 정의해놓고 알아서 커스텀하기로 함.
func handle(input: Dictionary) -> Dictionary:
	var output: Dictionary = {}
	var data: Dictionary = await done
	return output

# FSM의 interrupt 함수에서 호출됨.
func stop(data: Dictionary):
	done.emit(data)
