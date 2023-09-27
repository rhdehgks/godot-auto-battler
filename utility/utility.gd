# 길찾기와 관련된 정적 메서드들이 정의되어 있음.
# 다만 길찾기와 관련 없는 메서드들도 있어서.. 클래스 이름을 바꿔야 하나 고민 중
# 또한, 일관성을 위해 웬만한 메서드들은 Token을 직접 반환하는 대신
# Vector2i를 반환한다. (어차피 해당 좌표로 Board.get_token을 하면 됨)
class_name Utility

static var directions: Array[Vector2i] = [
	Vector2i(0, 1), Vector2i(0, -1), Vector2i(1, 0),
	Vector2i(-1, 0), Vector2i(-1, -1),
	Vector2i(1, -1), Vector2i(-1, 1), Vector2i(1, 1)
]

# 좌표 간 거리 구하기 (대각선에 대한 가중치 없음)
static func get_distance(from: Vector2i, to: Vector2i) -> int:
	var dx: int = abs(to.x - from.x)
	var dy: int = abs(to.y - from.y)
	return max(dy, dx)
	
static func get_weighted_distance(from: Vector2i, to: Vector2i) -> int:
	var dx: int = abs(to.x - from.x)
	var dy: int = abs(to.y - from.y)
	var line: int = abs(dy - dx)
	var diag: int = min(dy, dx)
	return 1000 * line + 1414 * diag

# key 함수를 만족하는 가장 가까운 토큰 반환.
# Vector2i를 반환해야하나, null 값 반환을 위해 type 명시하지 않음.
static func get_nearest(from: Token, key: Callable = func(token: Token):
	return token.stat.camp != from.stat.camp):
	var nearest: Token = null
	for token in Board.get_tokens():
		if token == from:
			continue
		if key.call(token):
			if not nearest or get_distance(from.crd, token.crd) < get_distance(from.crd, nearest.crd):
				nearest = token
			elif get_distance(from.crd, token.crd) == get_distance(from.crd, nearest.crd):
				if get_weighted_distance(from.crd, token.crd) < get_weighted_distance(from.crd, nearest.crd):
					nearest = token
	if not nearest:
		return null
	return nearest.crd
	
# from으로부터 span 내에 존재하는 토큰들의 위치를 반환.
static func get_adjacents(from: Token, span: int = from.stat.attack_range, key: Callable = func(token: Token):
	return token.stat.camp != from.stat.camp) -> Array[Vector2i]:
	var adjacents: Array[Vector2i] = []
	for x in range(from.crd.x - span, from.crd.x + span + 1):
		for y in range(from.crd.y  - span, from.crd.y + span + 1):
			if not Board.is_in_bound(Vector2i(x, y)):
				continue
			var token = Board.get_token(Vector2i(x, y))
			if token and token != from:
				if key.call(token):
					adjacents.append(token.crd)
	return adjacents
	
# 현재 도달 가능한 토큰들의 위치를 반환.
# BFS 방식으로 구한다.
static func get_reachables(from: Token, key: Callable = func(token: Token):
	return token.stat.camp != from.stat.camp) -> Array[Vector2i]:
	var queue := Queue.new()
	var visited := {}
	var reachables: Array[Vector2i] = []
	queue.push(from.crd)
	while not queue.is_empty():
		var cur: Vector2i = queue.pop()
		var token: Token = Board.get_token(cur)
		if token and token != from:
			if key.call(token):
				reachables.append(token.crd)
			continue
		for dir in directions:
			var next: Vector2i = cur + dir
			if next in visited or not Board.is_in_bound(next):
				continue
			visited[next] = true
			queue.push(next)
	return reachables

# 현재 도달 가능하면서 적을 공격 가능한 위치들을 반환.
# BFS 방식으로 구한다.
static func get_attackables(from: Token, key: Callable = func(token: Token):
	return token.stat.camp != from.stat.camp) -> Array[Vector2i]:
	var queue := Queue.new()
	var visited := {}
	var attackables: Array[Vector2i] = []
	queue.push(from.crd)
	while not queue.is_empty():
		var cur: Vector2i = queue.pop()
		var cur_token = Board.get_token(cur)
		if cur_token and cur_token != from:
			continue
		for token in Board.get_tokens():
			if not key.call(token):
				continue
			if get_distance(cur, token.crd) <= from.stat.attack_range:
				attackables.append(cur)
				break
		for dir in directions:
			var next: Vector2i = cur + dir
			if next in visited or not Board.is_in_bound(next):
				continue
			visited[next] = true
			queue.push(next)
	return attackables

# from에서 target 좌표들까지의 최단경로를 사전 형태로 반환
static func get_paths(from: Token, targets: Array[Vector2i]) -> Dictionary:
	if len(targets) == 0:
		return {}
	var paths = Dijkstra.get_paths(from.crd, targets)
	return paths

# from에서 target 좌표들까지의 최단경로 중 가장 짧은 경로를 반환
static func get_shortest_path(from: Token, targets: Array[Vector2i]) -> Array[Vector2i]:
	var paths := get_paths(from, targets)
	if len(paths) == 0:
		return []
	var path: Array[Vector2i] = []
	for target in targets:
		if len(path) == 0 or len(path) > len(paths[target]):
			path = paths[target]
	return path

# A* 알고리즘을 이용해 단일 타겟까지의 최단경로를 구함.
static func get_single_path(from: Token, target: Vector2i) -> Array[Vector2i]:
	var path = AStar.get_single_path(from.crd, target)
	return path
