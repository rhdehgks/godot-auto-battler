# 시그널들을 모아놓기 위한 클래스
class_name TokenSignal

signal be_damaged(damage: int, source: Token)
signal killed(target: Token)
signal be_killed(source: Token)
signal attacked(damage: int, target: Token)
signal be_attacked(damage: int, target: Token)
signal cast_skill(data: Dictionary)
signal hit_by_skill(data: Dictionary)
signal moved(data: Dictionary)
signal be_moved(data: Dictionary)
