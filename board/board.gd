extends Node2D

# 보드.
# 복잡한 알고리즘 없이 토큰(들)을 구하는 메서드들이 정의되어 있음.
# 좌표 변환도 담당함.
class_name Board

static var board_size: int = 8
static var tile_size: int = 64
static var _board: Array[Array]
static var token_list: Array[Token]

# 씬에 존재하는 Board의 좌표를 참조하기 위해 선언
static var board_position: Vector2

# static signal이 없기 때문에, 해당 변수를 통해 우회적으로 emit을 해야 함.
static var instance: Board

# 보드 위의 토큰들의 배치가 달라질 경우 방출됨.
signal board_changed

func _init():
	instance = self
	init_board()

func _ready():
	token_list = []
	for child in get_children():
		if child is Token:
			child.init()
			token_list.append(child)
			set_token(child.crd, child)
	board_position = position


# 보드 초기화
func init_board() -> void:
	_board = []
	for i in range(board_size):
		_board.append([])
		for j in range(board_size):
			_board[i].append(null)

func start_game():
	token_list.shuffle()
	await get_tree().create_timer(0.5).timeout
	for token in token_list:
		token.fsm.execute()
		await get_tree().process_frame

# position -> coord
static func to_crd(pos: Vector2) -> Vector2i:
	return Vector2i(pos.x / tile_size, pos.y / tile_size)

# coord -> position
static func to_pos(crd: Vector2i) -> Vector2:
	return Vector2(crd.x * tile_size, crd.y * tile_size)

# 좌표가 범위 내에 있는지
static func is_in_bound(crd: Vector2i):
	return crd.x >= 0 and crd.x < board_size and crd.y >= 0 and crd.y < board_size

static func get_tokens() -> Array[Token]:
	return token_list

# key 메서드로 필터링해서 토큰 구하기
# 기본 인자를 이용하면 token이 목록 그대로 반환됨.
# 다만 항상 목록을 복사하게 된다는 부작용이 존재함..
static func get_tokens_by(key: Callable = func(token: Token): return true) -> Array[Token]:
	var tokens: Array[Token] = []
	for token in token_list:
		if key.call(token):
			tokens.append(token)
	return tokens

# 좌표에 맞는 토큰 반환
# 존재하지 않는 경우 null 반환
# 범위 확인이나 좌표에 대한 null 체크를 해야하나 고민.
static func get_token(crd: Vector2i) -> Token:
	var token: Token = _board[crd.x][crd.y]
	return token

# key 조건에 맞는지 여부 반환
# null인 경우 항상 false 반환
static func check_token(token: Token, key: Callable = func(token: Token): return true) -> bool:
	if not token:
		return false
	return key.call(token)

# 좌표에 토큰을 할당
static func set_token(crd: Vector2i, token: Token) -> void:
	_board[crd.x][crd.y] = token
	instance.board_changed.emit()

static func erase_token(token: Token) -> void:
	token_list.erase(token)
	
static func remove_token(token: Token) -> void:
	erase_token(token)
	set_token(token.crd, null)
	token.visible = false
	
static func is_token_valid(token: Token) -> bool:
	if not token:
		return false
	return token in token_list

# 보드 비우기
static func clear() -> void:
	for i in range(board_size):
		for j in range(board_size):
			_board[i][j] = null
