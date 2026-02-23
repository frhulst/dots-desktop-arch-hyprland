import QtQuick
import Quickshell


Rectangle {
  implicitWidth: clockText.width + 10
  implicitHeight: Design.fontSize * 2
  radius: 8

  color: Design.colBg
  Text {
    id: clockText
    
    anchors {
      horizontalCenter: parent.horizontalCenter
      verticalCenter: parent.verticalCenter
    }
    text: Time.time
    color: "white"
    font {
      family: Design.fontFamily
      pixelSize: Design.fontSize * 1.5
    }
  }
}
