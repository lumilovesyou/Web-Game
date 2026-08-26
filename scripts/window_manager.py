import pyray as pr
from pyray import MouseButton, MouseCursor

# from pyray import MouseCursor
from scripts.enums import WindowInteractionState as WIS
from scripts.objects.window import Window


class WindowManager:
    def __init__(self):
        self.windows: list[Window] = []
        self.interacted_window: tuple[int, float, float] | None = None
        self.window_state: WIS = WIS.NONE
        self.id: int = 0
        self.debug: bool = True

    def addWindow(
        self,
        position: tuple[int, int] = (0, 0),
        size: tuple[int, int] = (100, 100),
        color: pr.Color = pr.RED,
    ):
        self.windows.append(
            Window(position[0], position[1], size[0], size[1], self.id, color)
        )
        self.id += 1

    def getWindowIndexById(self, id: int):
        for i in range(len(self.windows)):
            if self.windows[i].id == id:
                return i

    # Draws windows, z-index is based on array position
    def drawWindows(self):
        pr.set_mouse_cursor(MouseCursor.MOUSE_CURSOR_DEFAULT)
        for i in self.windows:
            x, y = i.x, i.y
            pr.draw_rectangle(x, y, i.w, i.h, i.color)
            _ = self._manageMouseShapes(x, y, i.w, i.h, 8)

    def _manageMouseShapes(
        self, x: int, y: int, w: int, h: int, g: int, gettingState: bool = False
    ):  # x, y, height, width, gap
        cursor = pr.get_mouse_position()
        cX = round(cursor.x)
        cY = round(cursor.y)

        edges = []

        # Could be modified to also return clicks on window edges
        # Top
        if cX in range(x, x + w) and cY in range(y, y + g):
            edges.append("top")
        if self.debug:
            pr.draw_rectangle(x, y, w, g, pr.RED)  # Hitbox visualizer
        # Bottom
        if cX in range(x, x + w) and cY in range(y + h - g, y + h):
            edges.append("bottom")
        if self.debug:
            pr.draw_rectangle(x, y + h - g, w, g, pr.RED)  # Hitbox visualizer
        # Left
        if cX in range(x, x + g) and cY in range(y, y + h):
            edges.append("left")
        if self.debug:
            pr.draw_rectangle(x, y, g, h, pr.ORANGE)  # Hitbox visualizer
        # Bottom left
        if cX in range(x + w - g, x + w) and cY in range(y, y + h):
            edges.append("right")
        if self.debug:
            pr.draw_rectangle(x + w - g, y, g, h, pr.ORANGE)  # Hitbox visualizer

        # Match cases. Might be a cleaner way to do this tbh but I'm stupid so idk :shrug:
        if "top" in edges:
            if "left" in edges:
                pr.set_mouse_cursor(MouseCursor.MOUSE_CURSOR_RESIZE_NWSE)
            elif "right" in edges:
                pr.set_mouse_cursor(MouseCursor.MOUSE_CURSOR_RESIZE_NESW)
            else:
                pr.set_mouse_cursor(MouseCursor.MOUSE_CURSOR_RESIZE_ALL)
        elif "bottom" in edges:
            if "left" in edges:
                pr.set_mouse_cursor(MouseCursor.MOUSE_CURSOR_RESIZE_NESW)
            elif "right" in edges:
                pr.set_mouse_cursor(MouseCursor.MOUSE_CURSOR_RESIZE_NWSE)
            else:
                pr.set_mouse_cursor(MouseCursor.MOUSE_CURSOR_RESIZE_NS)
        elif "right" in edges or "left" in edges:
            pr.set_mouse_cursor(MouseCursor.MOUSE_CURSOR_RESIZE_EW)

        if gettingState:
            return len(edges) > 0 and edges != ["top"]

    def manageWindowInputs(self):
        cursor = pr.get_mouse_position()

        # Manages window moving
        if self.interacted_window != None:
            id = self.getWindowIndexById(self.interacted_window[0])
            if id is None:
                raise ValueError(
                    "Corresponding window not found; Unable to assign `id` a value"
                )

            if self.window_state == WIS.DRAGGING:
                self.windows[id].x += int(cursor.x - self.interacted_window[1])
                self.windows[id].y += int(cursor.y - self.interacted_window[2])

            elif self.window_state == WIS.RESIZING:
                self.windows[id].w = max(
                    50, self.windows[id].w + int(cursor.x - self.interacted_window[1])
                )
                self.windows[id].h = max(
                    50, self.windows[id].h + int(cursor.y - self.interacted_window[2])
                )

            self.interacted_window = (self.interacted_window[0], cursor.x, cursor.y)

        # Detect mouse clicking a window, list is reversed to check top-down
        if pr.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT):
            for i in reversed(self.windows):
                if (cursor.x > i.x and cursor.x < i.x + i.w) and (
                    cursor.y > i.y and cursor.y < i.y + i.h
                ):
                    # Get the state of the grabbed window
                    if self._manageMouseShapes(i.x, i.y, i.w, i.h, 5, True):
                        self.window_state = WIS.RESIZING
                    else:
                        self.window_state = WIS.DRAGGING
                    self.interacted_window = (i.id, cursor.x, cursor.y)
                    window = i
                    self.windows.remove(i)
                    self.windows.append(window)
                    break
        elif pr.is_mouse_button_released(MouseButton.MOUSE_BUTTON_LEFT):
            self.interacted_window = None
            self.window_state = WIS.NONE
