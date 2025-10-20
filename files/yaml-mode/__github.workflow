## `(f-filename (buffer-file-name))` -*- mode: yaml-ts -*-
# https://docs.github.com/en/actions/tutorials
# https://docs.github.com/en/actions/reference/workflows-and-actions

name: A Workflow

env:
  JG_VAR: "My Variable"  

default:
  run:
    shell: bash

on:
    workflow_dispatch:

permissions:
    contents: read

jobs:
  basic:
    runs-on: ubuntu-latest
    steps:
      - name: basic
        run: |
          echo "Example"

          
