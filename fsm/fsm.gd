extends Node2D

# 유한 상태 기계
# Idle, Move, Attack, Skill, Stop, Die 등으로 나뉠 예정
# 어떤 State가 있는지 확실하게 정하고 가야할 듯.
class_name FSM

var states: Dictionary = {}
var current: String

# 자식 노드들을 Dictionary에 등록
func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child

# 현재 state를 반환
func get_current() -> String:
	return current

func get_state(state: String) -> State:
	if state in states:
		return states[state]
	else:
		return null

# state를 실행한다.
func execute(state: String = 'idle'):
	#states['idle'].init()
	
	current = state
	var data: Dictionary = {}
	while true:
		data = await states[current].handle(data)
		if 'state' in data:
			if data['state'] == 'die':
				break
			current = data['state']

# state를 강제 종료시킨다. 
# data에는 다음 state에 대한 정보가 포함되어 있을 수 있음.
func interrupt(data: Dictionary = {}):
	data['message'] = 'interrupted'
	states[current].stop(data)
