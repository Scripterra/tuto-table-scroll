[![Made with Godot v4.4](https://img.shields.io/badge/Made_with-Godot_v4.4-478CBF?style=flat&logo=godot%20engine&logoColor=white)](https://godotengine.org)

# A Scrolling Table
Tutorial to create a table where the headers (top and left) follow the main content (grid).
If the grid is scrolled, then we want the headers to follow horizontally and vertically (cf. image below):

![scroll-diagonal](https://github.com/user-attachments/assets/4e2bb66d-02d3-4598-ba09-11fba8186462)

## Base structure of the widget
This widget is composed of 3 main elements (cf. image below):
- The top header: a scrolling container with a horizontal container.
- The left header: a scrolling container with a vertical container.
- The main content: a scrolling container with a grid container.

![scroll-table-base](https://github.com/user-attachments/assets/9ee8ec80-8e62-4482-aacd-ee5bf20a8f64)

## Synchronizing the views
To synchronize the views, we have to break it down into 2 behaviours:
- synchronizing the top header horizontal scroll with the grid horizontal scroll.
- synchronizing the left header vertical scroll with the grid vertical scroll.

![scroll-horizontal](https://github.com/user-attachments/assets/edac2219-47c7-4686-bdc8-31d8f15b2ae3)
![scroll-vertical](https://github.com/user-attachments/assets/810f6863-ae39-4955-bce4-187c1da30216)


