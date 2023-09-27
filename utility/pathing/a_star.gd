class_name AStar

# 인접한 칸에 대해서만 구할 수 있음.
static func _get_g_cost(from: Vector2i, to: Vector2i) -> int:
	return 1000 if abs(to.x - from.x) != abs(to.y - from.y) else 1414

# 휴리스틱 함수
static func _get_h_cost(from: Vector2i, to: Vector2i) -> int:
	return 1000 * (abs(to.x - from.x) + abs(to.y - from.y))

# from에서 to까지의 최단경로를 반환한다.
static func get_single_path(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
	var opened := {}
	var closed := {}
	var parent := {}
	var g_cost := {}
	var h_cost := {}
	var heap := Heap.new(func(a, b): return g_cost[a] + h_cost[a] < g_cost[b] + h_cost[b])
	heap.push(from)
	g_cost[from] = 0
	h_cost[from] = _get_h_cost(from, to)
	parent[from] = null
	while not heap.is_empty():
		var cur: Vector2i = heap.pop()
		if cur == to:
			break
		opened.erase(cur)
		closed[cur] = true
		if Board.get_token(cur) and cur != from:
			continue
		for dir in Utility.directions:
			var next: Vector2i = cur + dir
			if not Board.is_in_bound(next) or next in closed:
				continue
			var new_cost = g_cost[cur] + _get_g_cost(cur, next)
			if next in opened:
				if g_cost[next] > new_cost:
					g_cost[next] = new_cost
					parent[next] = cur
			else:
				g_cost[next] = new_cost
				h_cost[next] = _get_h_cost(next, to)
				parent[next] = cur
				opened[next] = true
				heap.push(next)
	if to not in parent:
		return []
	var path: Array[Vector2i] = []
	var cur = to
	while cur != null:
		path.append(cur)
		cur = parent[cur]
	path.reverse()
	return path
