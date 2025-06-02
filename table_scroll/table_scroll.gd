class_name TableScroll
extends GridContainer


@export var table_size: TableSize

@export_group("Scenes", "scene")
@export var scene_cell_top: PackedScene
@export var scene_cell_left: PackedScene
@export var scene_cell_grid: PackedScene


func _ready() -> void:
	# Connect the scrollbars of the containers to sync them.
	%ScrollTop.get_h_scroll_bar().scrolling.connect(_on_scroll_top_h_scrolling)
	%ScrollLeft.get_v_scroll_bar().scrolling.connect(_on_scroll_left_v_scrolling)
	%ScrollGrid.get_h_scroll_bar().scrolling.connect(_on_scroll_grid_h_scrolling)
	%ScrollGrid.get_v_scroll_bar().scrolling.connect(_on_scroll_grid_v_scrolling)
	
	# Fake some data
	_set_data([
		["", "Column 1", "Column 2", "Column 3", "Column 4", "Column 5"],
		["Row 1", 0, 0, 0, 0, 0],
		["Row 2", 0, 0, 0, 0, 0],
		["Row 3", 0, 0, 0, 0, 0],
		["Row 4", 0, 0, 0, 0, 0],
		["Row 5", 0, 0, 0, 0, 0],
		["Row 6", 0, 0, 0, 0, 0],
		["Row 7", 0, 0, 0, 0, 0],
		["Row 8", 0, 0, 0, 0, 0],
		["Row 9", 0, 0, 0, 0, 0],
		["Row 10", 0, 0, 0, 0, 0],
		["Row 11", 0, 0, 0, 0, 0],
		["Row 12", 0, 0, 0, 0, 0],
		["Row 13", 0, 0, 0, 0, 0],
		["Row 14", 0, 0, 0, 0, 0],
		["Row 15", 0, 0, 0, 0, 0],
		["Row 16", 0, 0, 0, 0, 0],
	])

#region Events scrollbar sync

func _on_scroll_top_h_scrolling() -> void:
	%ScrollGrid.scroll_horizontal = %ScrollTop.scroll_horizontal


func _on_scroll_left_v_scrolling() -> void:
	%ScrollGrid.scroll_vertical = %ScrollLeft.scroll_vertical


func _on_scroll_grid_h_scrolling() -> void:
	%ScrollTop.scroll_horizontal = %ScrollGrid.scroll_horizontal


func _on_scroll_grid_v_scrolling() -> void:
	%ScrollLeft.scroll_vertical = %ScrollGrid.scroll_vertical



#endregion
#region Private methods

## Set the given data in the table.
func _set_data(data: Array) -> void:
	# Set the top header
	var top: Array = data[0]
	for text in top.slice(1):
		var cell = scene_cell_top.instantiate()
		cell.text = text
		%Top.add_child(cell)
	
	# Configure the grid and set each row
	%Grid.columns = len(top) - 1
	for row in data.slice(1):
		# Set the left header
		var cell_left = scene_cell_left.instantiate()
		cell_left.text = row[0]
		%Left.add_child(cell_left)
		# Set the data in the grid
		for value in row.slice(1):
			var cell = scene_cell_grid.instantiate()
			cell.text = str(value)
			%Grid.add_child(cell)

#endregion
