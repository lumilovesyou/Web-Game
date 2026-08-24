from pyray import *
from scripts.window_manager import *

wM = WindowManager()
init_window(800, 800, "Wow")
set_target_fps(60)

wM.addWindow((0,0), (20, 0), RED)
wM.addWindow((100,50), (100,80), GREEN)

while not window_should_close():
    begin_drawing()
    clear_background(RAYWHITE)
    
    wM.drawWindows()
    wM.manageWindowInputs()
    
    draw_text("Hello world!", 190, 200, 20, BLACK)
    
    end_drawing()
    
close_window()