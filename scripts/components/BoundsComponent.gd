class_name BoundsComponent
extends Node

signal bounds_ready(rect: Rect2)

func _ready():
	var col = get_parent().get_node("CollisionShape2D")
	var rect = col.global_transform * Rect2(-col.shape.size / 2, col.shape.size)
	bounds_ready.emit.call_deferred(rect)
