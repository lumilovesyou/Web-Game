from pyray import *
from scripts.objects.window import Window

init_window(800, 800, "Wow")
set_target_fps(60)

windows = [Window((20, 20), (100, 100), 0, BLUE)]

while not window_should_close():
    begin_drawing()
    clear_background(RAYWHITE)
    
    for i in windows:
        x = i.position[0]
        y = i.position[0]
        draw_rectangle(x, y, x + i.size[0], y + i.size[1], window.colour)
    
    draw_text("Hello world!", 190, 200, 20, BLACK)
    
    end_drawing()
    
close_window()