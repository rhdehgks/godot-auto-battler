extends Resource
class_name Stat

# 진영
@export var camp: int = 0
# 공격 사거리
@export var attack_range: int = 1
# 이동 속도 (ex. 100 -> 초당 1칸 이동)
@export var move_speed: int = 200
# 공격 속도 (ex. 100 -> 초당 1회 공격)
@export var attack_speed: int = 200
# 현재 체력, 최대 체력
@export var health: int = 400
@export var max_health: int = 400
# 현재 마나, 최대 마나
@export var mana: int = 0
@export var max_mana: int = 10
# 물리, 마법 데미지
@export var physical_damage: int = 30
@export var magic_damage: int = 20
# 방어력, 마법 저항력
@export var armor: int = 10
@export var magic_resistance: int = 10
# 물리, 마법 관통력
@export var armor_penetration: int = 5
@export var magic_penetration: int = 5
# 흡혈 (단위: %)
@export var physical_vamp: int = 10
@export var magic_vamp: int = 10

# 치명타 (단위: %)
@export var critical_strike_chance: int = 30
