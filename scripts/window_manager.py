from scripts.objects.window import Window
from pyray import *

class WindowManager():
    def __init__(self):
        self.windows = []
        self.dragged_window = None
        self.id = 0

    def addWindow(self, position, size = (0,0), colour = RED):
        self.windows.append(Window(position[0], position[1], size, self.id, colour))
        self.id += 1

    def getWindowIndexById(self, id):
        for i in range(0, len(self.windows)):
            if self.windows[i].id == id:
                return i

    # Draws windows, z-index is based on array position
    def drawWindows(self):
        for i in self.windows:
            x = i.x
            y = i.y
            draw_rectangle(x, y, i.size[0], i.size[1], i.colour)
            
    def manageWindowInputs(self):
        cursor = get_mouse_position()
        
        # Manages window moving
        if self.dragged_window != None:
            id = self.getWindowIndexById(self.dragged_window[0])
            self.windows[id].x += int(cursor.x - self.dragged_window[1])
            self.windows[id].y += int(cursor.y - self.dragged_window[2])
            self.dragged_window[1] = cursor.x
            self.dragged_window[2] = cursor.y
        
        # Detect mouse clicking a window, list is reversed to check top-down
        if is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
            for i in reversed(self.windows):
                if (cursor.x > i.x and cursor.x < i.x + i.size[0]) and (cursor.y > i.y and cursor.y < i.y + i.size[1]):
                    self.dragged_window = [i.id, cursor.x, cursor.y]            
                    window = i
                    self.windows.remove(i)
                    self.windows.append(window)
                    break
        elif is_mouse_button_released(MOUSE_BUTTON_LEFT):
            self.dragged_window = None