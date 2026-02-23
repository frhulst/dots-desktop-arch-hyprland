pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property bool capsLockOn: false
  property bool numLockOn: false

  signal capsLockChanged(bool active)
  signal numLockChanged(bool active)

  // Flag to track if this is the initial check to avoid OSD triggers
  property bool initialCheckDone: false

  Process {
    id: stateCheckProcess

    property string checkCommand: " \
caps=0; cat /sys/class/leds/input*::capslock/brightness 2>/dev/null | grep -q 1 && caps=1; echo \"caps:${caps}\"; \
num=0; cat /sys/class/leds/input*::numlock/brightness 2>/dev/null | grep -q 1 && num=1; echo \"num:${num}\"; \
scroll=0; cat /sys/class/leds/input*::scrolllock/brightness 2>/dev/null | grep -q 1 && scroll=1; echo \"scroll:${scroll}\"; \
"
    command: ["sh", "-c", stateCheckProcess.checkCommand]

    stdout: StdioCollector {
      onStreamFinished: {
        var lines = this.text.trim().split('\n');
        for (var i = 0; i < lines.length; i++) {
          var parts = lines[i].split(':');
          if (parts.length === 2) {
            var key = parts[0];
            var newState = (parts[1] === '1');

            if (key === "caps") {
              if (root.capsLockOn !== newState) {
                root.capsLockOn = newState;
                if (root.initialCheckDone) {
                  root.capsLockChanged(newState);
                }
                console.log("LockKeysService", "Caps Lock:", capsLockOn);
              }
            } else if (key === "num") {
              if (root.numLockOn !== newState) {
                root.numLockOn = newState;
                if (root.initialCheckDone) {
                  root.numLockChanged(newState);
                }
                console.log("LockKeysService", "Num Lock:", numLockOn);
              }
            }
          }
        }
        // Set initialCheckDone to true after the first check is complete
        if (!root.initialCheckDone) {
          root.initialCheckDone = true;
        }
      }
    }
    stderr: StdioCollector {
      onStreamFinished: {
        if (this.text.trim().length > 0)
        console.log("LockKeysService", "Error running state check:", this.text.trim());
      }
    }
  }

  Timer {
    id: pollTimer
    interval: 200
    running: true
    repeat: true
    onTriggered: {
      if (!stateCheckProcess.running) {
        stateCheckProcess.running = true;
      }
    }
  }

  Component.onCompleted: {
    stateCheckProcess.running = true;
  }
}
