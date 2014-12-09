#!/bin/bash

# Left click and right click simultaneously to produce a middle-click
xinput set-prop "Primax Kensington Eagle Trackball" "Evdev Middle Button Emulation" 1

# Reduce sensitivity a bit. The default is ridiculous
xinput set-prop "Primax Kensington Eagle Trackball" "Device Accel Constant Deceleration" 1.75 # Higher numbers == slower
xset m 1 7

# Set handedness of buttons depending on user-inputted parameters
# If input starts with l or L, makes ball left-handed (left button is right click, right button is left click)
# Otherwise, makes ball right-handed (left button is left-click, right button is right-click)
if [[ $1 == [lL]* ]]; then
    echo "Setting trackball to left-handed mode"
    xinput set-button-map "Primax Kensington Eagle Trackball" 3 2 1
else
    if [[ $1 == [rR]* ]]; then
        echo "Setting trackball to right-handed mode"
    else
        echo "WARNING: You did not specify a handedness as your parameter (valid inputs: [l,L,r,R,left,Left,right,Right]; Defaulting to right-handed"
    fi
    xinput set-button-map "Primax Kensington Eagle Trackball" 1 2 3
fi
