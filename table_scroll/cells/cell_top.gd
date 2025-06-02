extends PanelContainer


@export var table_size: TableSize

@export var text: String:
	set(value):
		text = value
		if not is_node_ready():
			await ready
		%Label.text = value


func _ready() -> void:
	custom_minimum_size.x = table_size.grid_size.x
	custom_minimum_size.y = table_size.top_height
