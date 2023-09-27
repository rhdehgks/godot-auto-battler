# 큐
# 원형큐로 제작할 예정. (어차피 유닛의 최대 개수는 64개니까.. 공간 낭비가 그리 심하진 않을 듯)
class_name Queue

var _queue: Array
var _size: int
var _rear: int
var _front: int

func _init(size: int = Board.board_size * Board.board_size):
	_queue = []
	_size = size + 1
	for i in range(_size):
		_queue.append(null)
	_rear = 0
	_front = 0

func is_empty() -> bool:
	return _rear == _front
	
func is_full() -> bool:
	return (_rear + 1) % _size == _front
	
func push(value):
	if is_full():
		return
	_rear = (_rear + 1) % _size
	_queue[_rear] = value
	
func pop():
	if is_empty():
		return
	_front = (_front + 1) % _size
	return _queue[_front]
