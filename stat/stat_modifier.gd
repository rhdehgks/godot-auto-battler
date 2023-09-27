# 스탯 수정자
# 영구히 변경되는 것이 아닌 일시적 버프에 의한 스탯 변경을 저장하고 적용시킨다.
class_name StatModifier

# 체력과 마나 같은 경우는 현재/최대 스탯이 나눠져 있음.
# 최대 스탯을 대상으로 하는 버프의 경우는 현재/최대 각각에 모두 적용되지만, 버프가 해제될 때는
# 최대 스탯에 대해서만 해제한다.

var _modifier_list: Array[Dictionary] = []

	
func add_modifier(modifier: Dictionary):
	pass
	
func remove_modifier():
	pass
