extends StaticBody2D


@export var wall_polygon : Polygon2D
@export var wall_collision_polygon : CollisionPolygon2D

func _ready():
	wall_collision_polygon.polygon = PackedVector2Array(wall_polygon.polygon)

