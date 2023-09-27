class_name Dijkstra

# 인접한 칸에 대해서만 구할 수 있음.
static func _get_cost(from: Vector2i, to: Vector2i) -> int:
	return 1000 if abs(to.x - from.x) != abs(to.y - from.y) else 1414

# targets 배열에 담긴 좌표들까지의 최단경로들을 반환한다.
static func get_paths(from: Vector2i, targets: Array[Vector2i]) -> Dictionary:
	var opened := {}
	var closed := {}
	var parent := {}
	var cost := {}
	var heap := Heap.new(func(a, b): return cost[a] < cost[b])
	heap.push(from)
	cost[from] = 0
	parent[from] = null
	while not heap.is_empty():
		var cur: Vector2i = heap.pop()
		opened.erase(cur)
		closed[cur] = true
		if Board.get_token(cur) and cur != from:
			continue
		for dir in Utility.directions:
			var next: Vector2i = cur + dir
			if not Board.is_in_bound(next) or next in closed:
				continue
			var new_cost = cost[cur] + _get_cost(cur, next)
			if next in opened:
				if cost[next] > new_cost:
					cost[next] = new_cost
					parent[next] = cur
			else:
				cost[next] = new_cost
				parent[next] = cur
				opened[next] = true
				heap.push(next)
	var path := {}
	for target in targets:
		var path_to_target: Array[Vector2i] = []
		if not target in parent:
			continue
		var cur = target
		while cur != null:
			path_to_target.append(cur)
			cur = parent[cur]
		path_to_target.reverse()
		path[target] = path_to_target
	return path
				
	
