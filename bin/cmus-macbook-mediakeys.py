#!/usr/bin/python

import subprocess

# PyObjC-related imports
from AppKit import NSApplication, NSSystemDefined, NSApplicationActivationPolicyProhibited
from PyObjCTools import AppHelper


KEY_UP = 11


class KeySocketApp(NSApplication):


    def sendEvent_(self, event):
        if event.type() is NSSystemDefined and event.subtype() is 8:
            data = event.data1()
            keyCode = (data & 0xFFFF0000) >> 16
            keyFlags = (data & 0x0000FFFF)
            keyState = (keyFlags & 0xFF00) >> 8

            if keyState is KEY_UP:
                if keyCode == 20:
                    subprocess.call(['cmus-remote', '-r'])
                elif keyCode == 16:
                    subprocess.call(['cmus-remote', '-u'])
                elif keyCode == 19:
                    subprocess.call(['cmus-remote', '-n'])


if __name__ == '__main__':
    app = KeySocketApp.sharedApplication()
    app.setActivationPolicy_(NSApplicationActivationPolicyProhibited)
    AppHelper.runEventLoop()