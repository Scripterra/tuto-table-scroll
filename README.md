[![Made with Godot v4.4](https://img.shields.io/badge/Made_with-Godot_v4.4-478CBF?style=flat&logo=godot%20engine&logoColor=white)](https://godotengine.org)

- [A Scrolling Table](#a-scrolling-table)
  - [1. Base structure of the widget](#1-base-structure-of-the-widget)
  - [2. Synchronizing the views](#2-synchronizing-the-views)
    - [2.1. Ensuring element sizes](#21-ensuring-element-sizes)
      - [2.1.1. The cells](#211-the-cells)
        - [2.1.1.1 Top cell](#2111-top-cell)
        - [2.1.1.2 Left cell](#2112-left-cell)
        - [2.1.1.3 Grid cell](#2113-grid-cell)
      - [2.1.2. The Containers margin](#212-the-containers-margin)
      - [2.1.3. Result](#213-result)
    - [2.2. Syncronizing the scroll bars](#22-syncronizing-the-scroll-bars)
  - [3. Set some data in the table from code](#3-set-some-data-in-the-table-from-code)


# A Scrolling Table
Tutorial to create a table where the headers (top and left) follow the main content (grid).

<img alt="scroll-diagonal.gif" src="https://github.com/user-attachments/assets/f01c336e-4503-4a7c-a50d-86ada8ed6a27" width="480px"/>

## 1. Base structure of the widget
This widget is composed of 3 main elements (cf. image below):
- The top header: a scrolling container with a horizontal container.
- The left header: a scrolling container with a vertical container.
- The main content: a scrolling container with a grid container.

<img alt="scroll-table-base.png" src="https://github.com/user-attachments/assets/48ebc73f-b444-4367-86b9-a584d70a7fe9" width="480px"/>

In Godot, we use a `GridContainer` to layout these elements. Therefore, we need a fourth element as the first child of the grid (the top left square on the image above). This table is encapsulated in a `MarginContainer` and in a `PanelContainer` to make it look a bit better.

`table_scroll.tscn`

<img alt="table-scroll-tree.png" src="https://github.com/user-attachments/assets/8be1e7ed-c24c-47bb-bad6-c204450426d9" width="400px"/>

In ordre to display the children of the `HeaderTop`, `HeaderLeft` and `Grid`, we have to configure the `ScrollContainers` to take as much place as possible.
In the Editor, selecting a `ScrollContainer`, clicking on ![image](https://github.com/user-attachments/assets/a21d318b-095c-4c6a-a4d7-d0cd22f03912) "Sizing settings for a children of a Container node" and setting:
- `ScrollTop` Horizontal alignment to `Fill` and `Expand`.
- `ScrollLeft` Vertical alignment to `Fill` and `Expand`.
- `ScrollGrid` both Horizontal and Vertical alignment to `Fill` and `Expand`.

## 2. Synchronizing the views
To synchronize the views, we have to break it down into 2 behaviours:
- Synchronizing the top header horizontal scroll with the grid horizontal scroll.
- Synchronizing the left header vertical scroll with the grid vertical scroll.

<img alt="scroll-horizontal.gif" src="https://github.com/user-attachments/assets/54eac061-f1a2-4314-a07c-2d508f528b2d" width="480px"/>
<img alt="scroll-vertical.gif" src="https://github.com/user-attachments/assets/ebfd3c03-cb7a-48a4-b548-fc5df67cc920" width="480px"/>

### 2.1. Ensuring element sizes
A very important part is to ensure that:
- The content of the grid container and the content of the horizontal container of the top header have the **same width**.
- The content of the grid container and the content of the vertical container of the left header have the **same height**.

We define a cell for each container that will contain its specific size and some data to display:
- The top header cell and the grid cell share the same width.
- The left header cell and the grid cell share the same height.

<img alt="scroll-table-cell.png" src="https://github.com/user-attachments/assets/ec8ed886-d6fc-4e98-9ee1-4f12df5b6b5b" width="480px"/>

We the use a `CustomResource` that will be given to each of the three cells as an `@export`.

```gdscript
# table_sizes.gd

class_name TableSize
extends Resource


## The minimum size of an element in the grid.
@export var grid_size: Vector2

## The height of a top header element.[br]
## The width is given by [member grid_size.x].
@export var top_height: float

## The width of a left header element.[br]
## The height is given by [member grid_size.y].
@export var left_width: float
```

Create a new resource based on `TableSize`: `table_sizes.tres`

![image](https://github.com/user-attachments/assets/f2774f20-98de-4a62-a5d2-d7259ed4729f)

#### 2.1.1. The cells
For this basic tutorial, a cell will be very simple and only displays text.

We'll create 3 different cells:
- `CellTop`: for the top header.
- `CellLeft`: for the left header.
- `CellGrid`: for the grid.

Each cell is a `PanelContainer` with a `Label` inside.

![image](https://github.com/user-attachments/assets/986a0e1e-45e2-4f1a-b98a-ba0f922e33e2)

The script associated take in input the `TableSizes` `CustomResource` and the text to be displayed in the label.

```gdscript
# Common part for each cell_[...].gd

extends PanelContainer


@export var table_size: TableSize

@export var text: String:
    set(value):
        text = value
        if not is_node_ready():
            await ready
        %Label.text = value
```

Then we need to set the minimum size of each cell base on the values in the `TableSizes` resource.

##### 2.1.1.1 Top cell
```gdscript
func _ready() -> void:
    custom_minimum_size.x = table_size.grid_size.x
    custom_minimum_size.y = table_size.top_height
```

##### 2.1.1.2 Left cell
```gdscript
func _ready() -> void:
    custom_minimum_size.x = table_size.left_width
    custom_minimum_size.y = table_size.grid_size.y
```

##### 2.1.1.3 Grid cell
```gdscript
func _ready() -> void:
	custom_minimum_size.x = table_size.grid_size.x
	custom_minimum_size.y = table_size.grid_size.y
```

#### 2.1.2. The Containers margin
The margin (`Theme Overrides/Separation`) of the `HeaderTop`, `HeaderLeft` and `Grid` are important to ensure a consistent width and height:
- The horizontal margin used in `HeaderTop` and in `Grid` should be the same.
- The vertical margin used in `HeaderLeft` and in `Grid` should be the same.

Keeping the default values works great!

#### 2.1.3. Result

After adding some data in the table, we have this result:
- Adding 5 `CellTop` as children of the `HeaderTop`.
- Adding 12 `CellLeft` as children of the `HeaderLeft`.
- Adding 60 `CellGrid` as children of the `Grid`.

![image](https://github.com/user-attachments/assets/74aa00cd-2106-4688-9efb-6cd36ee67966)


### 2.2. Syncronizing the scroll bars
Now, we have to link the different scroll bars of the scrolling containers.
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


## 3. Set some data in the table from code

For example, we want to display this data sheet:

|        | Column 1 | Column 2 | Column 3 | Column 4 | Column 5 |
|:-------|:--------:|:--------:|:--------:|:--------:|:--------:|
| Row 1  | 0        | 0        | 0        | 0        | 0        |
| Row 2  | 0        | 0        | 0        | 0        | 0        |
| Row 3  | 0        | 0        | 0        | 0        | 0        |
| Row 4  | 0        | 0        | 0        | 0        | 0        |
| Row 5  | 0        | 0        | 0        | 0        | 0        |
| Row 6  | 0        | 0        | 0        | 0        | 0        |
| Row 7  | 0        | 0        | 0        | 0        | 0        |
| Row 8  | 0        | 0        | 0        | 0        | 0        |
| Row 9  | 0        | 0        | 0        | 0        | 0        |
| Row 10 | 0        | 0        | 0        | 0        | 0        |
| Row 11 | 0        | 0        | 0        | 0        | 0        |
| Row 12 | 0        | 0        | 0        | 0        | 0        |
| Row 13 | 0        | 0        | 0        | 0        | 0        |
| Row 14 | 0        | 0        | 0        | 0        | 0        |
| Row 15 | 0        | 0        | 0        | 0        | 0        |


Let's create a function that take in input the data we want to display:
- First, we remove children from the containers `HeaderTop`, `HeaderLeft` and `Grid`.
- Then, we add a `CellTop` for each column from "Column 1".
- Finally, for each row of the remaining array, we add the first element as a `CellLeft` and the others as `CellGrid`.

```gdscript
# table_scroll.gd
# [...]

func _set_data(data: Array) -> void:
    # Remove all children from the Containers
    for child in %HeaderTop.get_children(): child.queue_free()
    for child in %HeaderLeft.get_children(): child.queue_free()
    for child in %Grid.get_children(): child.queue_free()

    # Set the top header
    var top: Array = data[0]
    for text in top.slice(1):  # From element n°1 to the end of the array
        var cell = scene_cell_top.instantiate()
        cell.text = text
        %HeaderTop.add_child(cell)

    # Configure the grid and set each row
    %Grid.columns = len(top) - 1
    for row in data.slice(1):
        # Set the left header
        var cell_left = scene_cell_left.instantiate()
        cell_left.text = row[0]
        %HeaderLeft.add_child(cell_left)
        # Set the data in the grid
        for value in row.slice(1):
            var cell = scene_cell_grid.instantiate()
            cell.text = str(value)
            %Grid.add_child(cell)
```
