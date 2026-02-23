#!/bin/bash

if qs list --all | grep virtual-keyboard; then
  qs -c ~/.config/quickshell/virtual-keyboard/ kill
else
  qs -c ~/.config/quickshell/virtual-keyboard/
fi
