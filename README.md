[![Made with Godot v4.4](https://img.shields.io/badge/Made_with-Godot_v4.4-478CBF?style=flat&logo=godot%20engine&logoColor=white)](https://godotengine.org)

# A Scrolling Table
Tutorial to create a table where the headers (top and left) follow the main content (grid).

<img alt="scroll-diagonal.gif" src="https://github.com/user-attachments/assets/f01c336e-4503-4a7c-a50d-86ada8ed6a27" width="480px"/>

## 1. Base structure of the widget
This widget is composed of 3 main elements (cf. image below):
- The top header: a scrolling container with a horizontal container.
- The left header: a scrolling container with a vertical container.
- The main content: a scrolling container with a grid container.

<img alt="scroll-table-base.png" src="https://github.com/user-attachments/assets/48ebc73f-b444-4367-86b9-a584d70a7fe9" width="480px"/>

In Godot, we use a `GridContainer` to layout these elements. Therefore, we need a fourth element as the first child of the grid.

`table_scroll.tscn`

<img alt="table-scroll-tree.png" src="https://github.com/user-attachments/assets/42be222d-defe-4855-9c76-717cbd33540c"/>

**TODO:** Some parameters have to be set for the scrolling containers.

## 2. Synchronizing the views
To synchronize the views, we have to break it down into 2 behaviours:
- Synchronizing the top header horizontal scroll with the grid horizontal scroll.
- Synchronizing the left header vertical scroll with the grid vertical scroll.

<img alt="scroll-horizontal.gif" src="https://github.com/user-attachments/assets/54eac061-f1a2-4314-a07c-2d508f528b2d" width="480px"/>
<img alt="scroll-vertical.gif" src="https://github.com/user-attachments/assets/ebfd3c03-cb7a-48a4-b548-fc5df67cc920" width="480px"/>

### 2.1. Ensuring element sizes
A very important part is to ensure that:
- The content of the grid container and the content of the horizontal container of the top header have the same width.
- The content of the grid container and the content of the vertical container of the left header have the same height.

We define a cell for each container that will contain its specific size and some data to display:
- The top header cell and the grid cell share the same width.
- The left header cell and the grid cell share the same height.

<img alt="scroll-table-cell.png" src="https://github.com/user-attachments/assets/ec8ed886-d6fc-4e98-9ee1-4f12df5b6b5b" width="480px"/>

The horizontal margin used in the horizontal container and the grid container should be the same.

The vertical margin used in the verical container and the grid container should be the same.

### 2.2. Syncronizing the scroll bars
Then, we have to link the different scroll bars of the scrolling containers.
- Horizontal:
  - If the top header scrolling container is scrolled horizontally, the grid scrolling container have to scroll horizontally.
  - If the grid scrolling container is scrolled horizontally, the top header scrolling container have to scroll horizontally.
- Vertical:
  - If the left header scrolling container is scrolled vertically, the grid scrolling container have to scroll vertically.
  - If the grid scrolling container is scrolled vertically, the left header scrolling container have to scroll vertically.

In the editor, the script for the `table_scroll.tscn` is:
```gdscript
# table_scroll.gd

func _ready() -> void:
    # Connect the scrollbars of the containers to sync them.
    %ScrollTop.get_h_scroll_bar().scrolling.connect(_on_scroll_top_h_scrolling)
    %ScrollLeft.get_v_scroll_bar().scrolling.connect(_on_scroll_left_v_scrolling)
    %ScrollGrid.get_h_scroll_bar().scrolling.connect(_on_scroll_grid_h_scrolling)
    %ScrollGrid.get_v_scroll_bar().scrolling.connect(_on_scroll_grid_v_scrolling)

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

```
