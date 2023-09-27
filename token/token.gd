@tool
extends Node2D

# 가독성을 위해 부모와 자식으로 분리함..
# 여기서는 변수 선언 및 (아마도)필수적인 컴포넌트들을 참조
class_name Token

@export var stat: Stat
@export var ability: Ability

@export var texture: CompressedTexture2D = null
# 디버깅용 변수 (오브젝트 식별용)
@export var id: int = 0
@export var debug: bool = false

@export var tag: String = ""


var signals: TokenSignal = TokenSignal.new()

var type: String = 'Token'
var crd: Vector2i
var fsm: FSM = null
var sprite: Sprite2D = null
var anim_tree: AnimationTree = null
var anim_player: AnimationPlayer = null

var health_bar: ProgressBar
var mana_bar: ProgressBar

@onready var label: RichTextLabel = $RichTextLabel

var attackers: Dictionary

func init():
	# 이 부분은 사실 반대로 해야하지 않나..생각 중
	# (어차피 생성을 동적으로 해야하기 때문에)
	crd = Board.to_crd(position)
	
	# Resource를 로컬로 저장
	stat = stat.duplicate()
	ability = ability.duplicate()
	
	ability.caster = self
	
	signals.be_damaged.connect(_on_be_damaged)
	signals.attacked.connect(_on_attacked)
	
	for child in get_children():
		if child is Sprite2D:
			sprite = child
		elif child is FSM:
			fsm = child
		elif child is AnimationTree:
			anim_tree = child
		elif child is AnimationPlayer:
			anim_player = child
#	if anim_tree:
#		anim_tree.active = true
	if texture:
		sprite.texture = texture
	
	health_bar = $HealthBar
	health_bar.max_value = stat.max_health
	health_bar.value = stat.health
	
	mana_bar = $ManaBar
	mana_bar.max_value = stat.max_mana
	mana_bar.value = stat.mana
	
	# label = $RichTextLabel
	# label.text = tag
	

func _ready():
	if texture:
		$Sprite2D.texture = texture
	
	# 아래 코드는 추후 삭제될 수도 있음.
	label.text = tag

func set_health(delta: int, is_relative = true):
	if is_relative:
		stat.health += delta
	else:
		stat.health = delta
	stat.health = min(stat.health, stat.max_health)
	health_bar.value = stat.health
	if stat.health <= 0:
		Board.remove_token(self)
		fsm.interrupt({'state': 'die'})
	
func set_mana(delta: int, is_relative = true):
	if is_relative:
		stat.mana += delta
	else:
		stat.mana = delta
	stat.mana = min(stat.mana, stat.max_mana)
	mana_bar.value = stat.mana

func _on_attacked(damage: int, target: Token):
	set_mana(1)
	
func _on_be_damaged(damage: int, source: Token):
	if stat.health <= 0:
		source.fsm.interrupt({'state': 'idle'})
		return
	set_mana(1)
	set_health(-damage)
