extends Node

var rng := RandomNumberGenerator.new()

func _init():
	rng.seed = hash('apple4')
