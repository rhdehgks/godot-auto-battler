# 힙
# 예전에 구현한 것이어서 잘 기억은 안 나는데 어쨌든 잘 작동함.
class_name Heap

var _list := []
var _key: Callable
	
func _init(key = func(a, b): return a < b):
	_key = key

func push(value) -> void:
	_list.append(value)
	var idx = len(_list) - 1
	while idx > 0:
		var parent = (idx - 1) / 2
		if _key.call(_list[idx], _list[parent]):
			var temp = _list[idx]
			_list[idx] = _list[parent]
			_list[parent] = temp
			idx = parent
		else:
			break

func pop():
	if len(_list) == 0:
		return null
	var value = _list[0]
	_list[0] = _list[len(_list) - 1]
	_list.pop_back()
	var idx = 0
	while true:
		var left = 2 * idx + 1
		var right = 2 * idx + 2
		var next = idx
		if left < len(_list) and _key.call(_list[left], _list[next]):
			next = left
		if right < len(_list) and _key.call(_list[right], _list[next]):
			next = right
		if next != idx:
			var temp = _list[idx]
			_list[idx] = _list[next]
			_list[next] = temp
			idx = next
		else:
			break
	return value

func peek():
	return _list[0] if len(_list) != 0 else null
	
func size() -> int:
	return len(_list)
	
func is_empty() -> bool:
	return len(_list) == 0
	
func has(value) -> bool:
	for data in _list:
		if data == value:
			return true
	return false
