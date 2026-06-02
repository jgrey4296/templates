## ui_bindings.py -*- mode: python -*-
"""


"""
# ruff.ignore.in.file


ui_bindings = [("User Interface",
  {"space_type": 'EMPTY', "region_type": 'WINDOW'},
  {"items":
   [("ui.eyedropper_colorramp", {"type": 'E', "value": 'PRESS'}, None),
    ("ui.eyedropper_colorramp_point", {"type": 'E', "value": 'PRESS', "alt": True}, None),
    ("ui.eyedropper_id", {"type": 'E', "value": 'PRESS'}, None),
    ("ui.eyedropper_depth", {"type": 'E', "value": 'PRESS'}, None),
    ("ui.eyedropper_bone", {"type": 'E', "value": 'PRESS'}, None),
    ("ui.copy_data_path_button", {"type": 'C', "value": 'PRESS', "shift": True, "ctrl": True}, None),
    ("ui.copy_data_path_button",
     {"type": 'C', "value": 'PRESS', "shift": True, "ctrl": True, "alt": True},
     {"properties":
      [("full_path", True),
       ],
      },
     ),
    ("anim.keyframe_insert_button",
     {"type": 'I', "value": 'PRESS'},
     {"properties":
      [("all", True),
       ],
      },
     ),
    ("anim.keyframe_delete_button",
     {"type": 'I', "value": 'PRESS', "alt": True},
     {"properties":
      [("all", True),
       ],
      },
     ),
    ("anim.keyframe_clear_button",
     {"type": 'I', "value": 'PRESS', "shift": True, "alt": True},
     {"properties":
      [("all", True),
       ],
      },
     ),
    ("anim.driver_button_add", {"type": 'D', "value": 'PRESS', "ctrl": True}, None),
    ("anim.driver_button_remove", {"type": 'D', "value": 'PRESS', "ctrl": True, "alt": True}, None),
    ("anim.keyingset_button_add", {"type": 'K', "value": 'PRESS'}, None),
    ("anim.keyingset_button_remove", {"type": 'K', "value": 'PRESS', "alt": True}, None),
    ("ui.reset_default_button",
     {"type": 'BACK_SPACE', "value": 'PRESS'},
     {"properties":
      [("all", True),
       ],
      },
     ),
    ("ui.list_start_filter", {"type": 'F', "value": 'PRESS', "ctrl": True}, None),
    ("ui.view_start_filter", {"type": 'F', "value": 'PRESS', "ctrl": True}, None),
    ("ui.view_scroll", {"type": 'WHEELUPMOUSE', "value": 'ANY'}, None),
    ("ui.view_scroll", {"type": 'WHEELDOWNMOUSE', "value": 'ANY'}, None),
    ("ui.view_scroll", {"type": 'TRACKPADPAN', "value": 'ANY'}, None),
    ("ui.view_item_select", {"type": 'LEFTMOUSE', "value": 'PRESS'}, None),
    ("ui.view_item_select",
     {"type": 'LEFTMOUSE', "value": 'PRESS', "ctrl": True},
     {"properties":
      [("extend", True),
       ],
      },
     ),
    ("ui.view_item_select",
     {"type": 'LEFTMOUSE', "value": 'PRESS', "shift": True},
     {"properties":
      [("range_select", True),
       ],
      },
     ),
    ("ui.view_item_rename", {"type": 'F2', "value": 'PRESS'}, None),
    ("ui.view_item_delete", {"type": 'X', "value": 'PRESS'}, None),
    ("ui.view_item_delete", {"type": 'DEL', "value": 'PRESS'}, None),
    ],
   },
  ),
  ]
