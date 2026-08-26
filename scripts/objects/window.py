from dataclasses import dataclass

from pyray import RED, Color


@dataclass
class Window:
    x: int = 0
    y: int = 0
    w: int = 100
    h: int = 100
    id: int = 0
    color: Color = RED
