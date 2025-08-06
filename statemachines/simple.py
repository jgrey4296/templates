#!/usr/bin/env python3
"""

"""
# ruff: noqa:

# Imports:
from __future__ import annotations

import pathlib as pl

from statemachine import StateMachine, State
from writer import write_fsm

# The FSM:

class Basic(StateMachine):
    start  = State(initial=True)
    end    = State(final=True)

    go = start.to(end)


class Another(StateMachine):
    start  = State(initial=True)
    mid1   = State()
    mid2   = State()
    end    = State(final=True)

    go     = start.to(mid1) | start.to(mid2) | end.from_(mid1, mid2)



# Write it out

def main():
    write_fsm(Basic)
    write_fsm(Another)

##-- ifmain
if __name__ == "__main__":
    main()
##-- end ifmain
