extends AnimatedSprite2D

func _ready() -> void:
	play("explosion")


func _on_SpawEplosion_animation_finished() -> void:
	queue_free()
