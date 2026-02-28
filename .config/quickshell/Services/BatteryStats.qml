pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property var batteryPercentage: 0
  property var batteryCharging: false
  property var color: "red"
  property var batteryIcon: ""
  property var batteryIcons: ["","","","",""]
  property var counter: 0

  Process {
    id: batteryPercentageUpdate

    // command: ["cat", "/sys/class/power_supply/BAT0/capacity"]
    command: ["cat", "/home/maskop/.config/quickshell/bingus"]

    stdout: StdioCollector {
      onStreamFinished: {
        root.batteryPercentage = parseInt(String(this.text))
        if (root.batteryPercentage <= 20) {
          root.color = "red"
          root.batteryIcon = ""
        } else if (root.batteryPercentage <= 50) {
          root.color = "orange"
          root.batteryIcon = ""
        } else if (root.batteryPercentage <= 75) {
          root.color = "green"
          root.batteryIcon = ""
        } else {
          root.color = "green"
          root.batteryIcon = ""
        }
      }
    }
  }

  Process {
    id: batteryStatusUpdate

    // command: ["cat", "/sys/class/power_supply/BAT0/capacity"]
    command: ["cat", "/home/maskop/.config/quickshell/bingus2"]

    stdout: StdioCollector {
      onStreamFinished: {
        root.batteryCharging = String(this.text).includes("Charging")
        if (root.batteryCharging) {
          chargeAnimTimer.running = true
          root.color = "green"
        } else {
          chargeAnimTimer.running = false
        }
      }
    }
  }

  Timer {
    id: chargeAnimTimer
    interval: 500
    running: false
    repeat: true

    onTriggered: {
      if (root.batteryPercentage <= 20 && root.counter > 4) {
        root.counter = 0
      } else if (root.batteryPercentage <= 50 && root.counter > 4) {
        root.counter = 1
      } else if (root.batteryPercentage <= 75 && root.counter > 4) {
        root.counter = 2
      } else if (root.batteryPercentage <= 99 && root.counter > 4) {
        root.counter = 3
      } else if (root.batteryPercentage > 99){
        root.counter = 4
      }
      console.log(root.batteryIcons[root.counter])
      console.log(root.counter)
      root.batteryIcon = root.batteryIcons[root.counter]
      root.counter++
    }
  }


  Timer {
    id: updateTimer
    interval: 5000
    running: true
    repeat: true

    onTriggered: {
      batteryPercentageUpdate.running = true
      batteryStatusUpdate.running = true
    }
  }
}
