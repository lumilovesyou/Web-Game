from pyray import RED

class Window:
    def __init__(self, position = (0,0), size = (0,0), id = 0, colour = RED):
        self.position = position
        self.size = size
        self.id = id
        self.colour = colour