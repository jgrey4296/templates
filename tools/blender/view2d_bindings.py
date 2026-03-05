## view2d_bindings.py -*- mode: python -*-
"""


"""
# ruff.ignore.in.file

view2d_bindings = [("View2D",
  {"space_type": 'EMPTY', "region_type": 'WINDOW'},
  {"items":
   [("view2d.scroller_activate", {"type": 'MIDDLEMOUSE', "value": 'PRESS'}, None),
    ("view2d.pan", {"type": 'MIDDLEMOUSE', "value": 'PRESS'}, None),
    ("view2d.pan", {"type": 'MIDDLEMOUSE', "value": 'PRESS', "shift": True}, None),
    ("view2d.pan", {"type": 'TRACKPADPAN', "value": 'ANY'}, None),
    ("view2d.scroll_right", {"type": 'WHEELDOWNMOUSE', "value": 'PRESS', "ctrl": True}, None),
    ("view2d.scroll_right", {"type": 'WHEELRIGHTMOUSE', "value": 'PRESS'}, None),
    ("view2d.scroll_left", {"type": 'WHEELUPMOUSE', "value": 'PRESS', "ctrl": True}, None),
    ("view2d.scroll_left", {"type": 'WHEELLEFTMOUSE', "value": 'PRESS'}, None),
    ("view2d.scroll_down", {"type": 'WHEELDOWNMOUSE', "value": 'PRESS', "shift": True}, None),
    ("view2d.scroll_up", {"type": 'WHEELUPMOUSE', "value": 'PRESS', "shift": True}, None),
    ("view2d.ndof", {"type": 'NDOF_MOTION', "value": 'ANY'}, None),
    ("view2d.zoom_out", {"type": 'WHEELOUTMOUSE', "value": 'PRESS'}, None),
    ("view2d.zoom_in", {"type": 'WHEELINMOUSE', "value": 'PRESS'}, None),
    ("view2d.zoom_out", {"type": 'NUMPAD_MINUS', "value": 'PRESS', "repeat": True}, None),
    ("view2d.zoom_in", {"type": 'NUMPAD_PLUS', "value": 'PRESS', "repeat": True}, None),
    ("view2d.zoom", {"type": 'TRACKPADPAN', "value": 'ANY', "ctrl": True}, None),
    ("view2d.smoothview", {"type": 'TIMER1', "value": 'ANY', "any": True}, None),
    ("view2d.scroll_down", {"type": 'WHEELDOWNMOUSE', "value": 'PRESS'}, None),
    ("view2d.scroll_up", {"type": 'WHEELUPMOUSE', "value": 'PRESS'}, None),
    ("view2d.scroll_right", {"type": 'WHEELDOWNMOUSE', "value": 'PRESS'}, None),
    ("view2d.scroll_left", {"type": 'WHEELUPMOUSE', "value": 'PRESS'}, None),
    ("view2d.zoom", {"type": 'MIDDLEMOUSE', "value": 'PRESS', "ctrl": True}, None),
    ("view2d.zoom", {"type": 'TRACKPADZOOM', "value": 'ANY'}, None),
    ("view2d.zoom_border", {"type": 'B', "value": 'PRESS', "shift": True}, None),
    ],
   },
  ),
 ]
