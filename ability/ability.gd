extends Resource

# 어빌리티 클래스
# EffectState에서 Ability의 메서드를 적절히 호출해서 사용하게 된다.
class_name Ability

var caster: Token = null

# 어빌리티를 시전하는 함수.
# caster 토큰이 호출한다.
func cast() -> Dictionary:
	var effects = get_effects()
	var caster_effect: Dictionary = {}
	for token in effects:
		token = token as Token # 자동완성을 위해 임시 추가
		if token == caster: # 시전자 본인의 효과인 경우, 반환을 위해 저장
			caster_effect = effects[token]
		else:
			if 'state' in effects[token]: # 상태이상 효과가 존재하는 경우
				token.fsm.interrupt(effects[token])
			else: # 상태이상 효과가 없는 경우 (효과 즉시 호출)
				effects[token]['effect'].call()
	return caster_effect

# 각 Token을 키로 하는 딕셔너리에 정보를 저장해서 반환.
# Tween을 저장할 경우 state를 interrupted로 설정해야 한다.
# abstract (아래 코드는 테스트용이며, 자식 클래스에서 재정의하여 사용할 것)
func get_effects() -> Dictionary:
	var effects: Dictionary = {}
	return effects


func on_interrupted() -> void:
	pass
