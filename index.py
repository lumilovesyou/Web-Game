from pyray import *

init_window(800, 450, "Wow")
set_target_fps(60)

while not window_should_close():
    begin_drawing()
    clear_background(RAYWHITE)
    draw_text("Hello world!", 190, 200, 20, BLACK)
    end_drawing()
    
close_window()