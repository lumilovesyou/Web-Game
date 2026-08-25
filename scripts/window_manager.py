from scripts.objects.window import Window
from pyray import *

class WindowManager():
    def __init__(self):
        self.windows = []
        self.dragged_window = None
        self.id = 0
        self.debug = True

    def addWindow(self, position, size = (0,0), colour = RED):
        self.windows.append(Window(position[0], position[1], size, self.id, colour))
        self.id += 1

    def getWindowIndexById(self, id):
        for i in range(0, len(self.windows)):
            if self.windows[i].id == id:
                return i

    # Draws windows, z-index is based on array position
    def drawWindows(self):
        set_mouse_cursor(MOUSE_CURSOR_DEFAULT)
        for i in self.windows:
            x,y = i.x,i.y
            draw_rectangle(x, y, i.size[0], i.size[1], i.colour)
            self._manageMouseShapes(x, y, i.size[0], i.size[1], 8)

    def _manageMouseShapes(self, x, y, w, h, g): #x, y, height, width, gap
        cursor = get_mouse_position()
        cX = round(cursor.x)
        cY = round(cursor.y)
        
        edges = []

        #Could be modified to also return clicks on window edges
        #Top
        if cX in range(x, x + w) and cY in range(y, y + g):
            edges.append("top")
        if (self.debug): draw_rectangle(x, y, w, g, RED) #Hitbox visualizer
        #Bottom
        if cX in range(x, x + w) and cY in range(y + h - g, y + h):
            edges.append("bottom")
        if (self.debug): draw_rectangle(x, y + h - g, w, g, RED) #Hitbox visualizer
        #Left
        if cX in range(x, x + g) and cY in range(y, y + h):
            edges.append("left")
        if (self.debug): draw_rectangle(x, y, g, h, ORANGE) #Hitbox visualizer
        #Bottom left
        if cX in range(x + w - g, x + w) and cY in range(y, y + h):
            edges.append("right")
        if (self.debug): draw_rectangle(x + w - g, y, g, h, ORANGE) #Hitbox visualizer
        
        #Match cases. Might be a cleaner way to do this tbh but I'm stupid so idk :shrug:
        if "top" in edges:
            if "left" in edges:
                set_mouse_cursor(MOUSE_CURSOR_RESIZE_NWSE)
            elif "right" in edges:
                set_mouse_cursor(MOUSE_CURSOR_RESIZE_NESW)
            else:
                set_mouse_cursor(MOUSE_CURSOR_RESIZE_ALL)
        elif "bottom" in edges:
            if "left" in edges:
                set_mouse_cursor(MOUSE_CURSOR_RESIZE_NESW)
            elif "right" in edges:
                set_mouse_cursor(MOUSE_CURSOR_RESIZE_NWSE)
            else:
                set_mouse_cursor(MOUSE_CURSOR_RESIZE_NS)
        elif "right" in edges or "left" in edges:
            set_mouse_cursor(MOUSE_CURSOR_RESIZE_EW)
            
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