import pyray as pr

from scripts.window_manager import WindowManager

wM = WindowManager()
pr.init_window(800, 800, "Wow")
pr.set_target_fps(60)

wM.addWindow((20, 20), (20, 50), pr.RED)
wM.addWindow((100, 50), (100, 80), pr.GREEN)
wM.addWindow((100, 50), (100, 80), pr.YELLOW)
wM.addWindow((100, 50), (100, 80), pr.BLUE)

while not pr.window_should_close():
    pr.begin_drawing()
    pr.clear_background(pr.RAYWHITE)

    wM.drawWindows()
    wM.manageWindowInputs()

    pr.draw_text("Hello world!", 190, 200, 20, pr.BLACK)

    pr.end_drawing()

pr.close_window()
