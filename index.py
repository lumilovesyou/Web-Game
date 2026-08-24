from pyray import *
from scripts.objects.window import Window

init_window(800, 800, "Wow")
set_target_fps(60)

windows = [Window((20, 20), (100, 100), 0, BLUE), Window((40, 40), (100, 50), 1, RED)]
dragged_window = None

def getWindowIndexById(id):
    for i in range(0, len(windows)):
        if windows[i].id == id:
            return i

while not window_should_close():
    begin_drawing()
    clear_background(RAYWHITE)
    
    # Draws windows, z-index is based on array position
    for i in windows:
        x = i.x
        y = i.y
        draw_rectangle(x, y, i.size[0], i.size[1], i.colour)
    
    # Detect mouse clicking a window, list is reversed to check top-down
    cursor = get_mouse_position()
    
    if dragged_window != None:
        id = getWindowIndexById(dragged_window[0])
        windows[id].x += int(cursor.x - dragged_window[1])
        windows[id].y += int(cursor.y - dragged_window[2])

        dragged_window[1] = cursor.x
        dragged_window[2] = cursor.y
        print(f"x: {windows[id].x} x-offset: {dragged_window[1] - cursor.x} cursor: {cursor.x}")
        
    if is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
        for i in reversed(windows):
            if (cursor.x > i.x and cursor.x < i.x + i.size[0]) and (cursor.y > i.y and cursor.y < i.y + i.size[1]):
                dragged_window = [i.id, cursor.x, cursor.y]
                print("down")
                break
    elif is_mouse_button_released(MOUSE_BUTTON_LEFT):
        print("up")
        dragged_window = None
        
    print(dragged_window)
    
    draw_text("Hello world!", 190, 200, 20, BLACK)
    
    end_drawing()
    
close_window()