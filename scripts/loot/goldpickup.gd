extends Area3D

@export var gold_amount: int = 1

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.has_method("add_gold"):
		body.add_gold(gold_amount)
		queue_free()