pragma Singleton

import Quickshell
import QtQuick 


Singleton {
  // color pallete
  property color colBg: "#1a1b26"
  property color colFg: "#a9b1d6"
  property color colMuted: "#444b6a"
  property color colCyan: "#0db9d7"
  property color colBlue: "#7aa2f7"
  property color colYellow: "#e0af68"
  property color transparent: "#00000000"

  // time format
  property string timeFormat: "hh:mm:ss"
  property bool seconds: true

  // font settings
  property string fontFamily: "JetBrainsMono Nerd Font"
  property int fontSize: 14

  // bar settings
  property int barAdd: 4
  property int widgetsSub: 4
  property int barHeight: fontSize * 2 + barAdd
  property int widgetHeight: barHeight - widgetsSub
  property int barMargins: (barHeight - widgetHeight) / 2
  property int widgetRadius: fontSize * (2/3)
}
