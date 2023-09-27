extends State

class_name IdleState

# 공격 목표이다.
# 만약 해당 target이 공격 범위 내에 있으면 공격을 수행하고,
# 그렇지 않다면 해당 target까지의 경로를 따라 움직인다. (한칸만 움직임)
var target: Token = null

# 다음으로 이동할 위치
var next = null

# target이 공격 범위 내에 있는지 여부.
# 만약 false라면 이동을 해야 한다는 뜻
var can_attack: bool = false

var is_board_changed: bool = false

func init():
	target = null
	next = null
	can_attack = false
	is_board_changed = false

func _ready():
	Board.instance.board_changed.connect(_on_board_changed)
	
func _process(delta):
	queue_redraw()

func _draw():
	if target:
		if token.stat.health > 0:
			draw_line(Vector2i(0, 0), target.position - token.position, Color(token.stat.camp, 1 - token.stat.camp, 0), 3)

func _on_board_changed():
	is_board_changed = true

func handle(input: Dictionary) -> Dictionary:
	var output: Dictionary = {}
	while true:
		if token.stat.mana == token.stat.max_mana: # 마나가 다 찬 경우
			token.set_mana(0, false)
			var data: Dictionary = token.ability.cast()
			if 'state' in data:
				output = data
				break
			if 'effect' in data:
				data['effect'].call()
		if is_board_changed: # 보드 상태가 변한 경우
			search()
			is_board_changed = false
		if can_attack: # 현재 위치에서 바로 공격 가능한 경우
			output['state'] = 'attack'
			output['target'] = target
			break
		if next != null: # 다음 위치가 정해진 경우
			output['state'] = 'move'
			output['next'] = next
			break
		wait_for_time(0.3) # 잠시 대기
		var data: Dictionary = await done
		match data['message']:
			'interrupted': # 만약 interrupt 당한 것이라면
				output = data
				break
	return output
	
func search():
	# 변수 초기화
	can_attack = false
	next = null
	if not Board.is_token_valid(target):
		target = null
	# 바로 공격 가능한 다음 타겟을 구함.
	var next_target = get_target()
	
	# 타겟이 존재할 시
	if next_target:
		target = next_target
		can_attack = true
		return
	# 공격 가능한 다음 타겟이 없을 경우, 기존 타겟까지의 경로가 존재하는지 확인.
	if target:
		var path = Utility.get_single_path(token, target.crd)
		if len(path) > 1:
			next = path[1]
			return
	# 기존 타겟이 존재하지 않거나, 경로가 존재하지 않을 경우
	var attackables := Utility.get_attackables(token)
	var path := Utility.get_shortest_path(token, attackables)
	if len(path) > 1:
		target = Board.get_token(path[len(path) - 1])
		next = path[1]

func get_target() -> Token:
	if target:
		if Utility.get_distance(token.crd, target.crd) <= token.stat.attack_range:
			return target
	var nearest = Utility.get_nearest(token)
	if nearest != null and Utility.get_distance(token.crd, nearest) <= token.stat.attack_range:
		return Board.get_token(nearest)
	return null
