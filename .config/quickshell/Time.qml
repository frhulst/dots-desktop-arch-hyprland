pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root
  readonly property string time: {
    Qt.formatDateTime(clock.date, Design.timeFormat)
  }
  readonly property string date: {
    Qt.formatDateTime(clock.date, "ddd d. MMMM")
  }

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
}
