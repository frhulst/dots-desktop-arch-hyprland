import Quickshell
import QtQuick

Rectangle {
  id: popupButton
  implicitWidth: parent.height - 4
  implicitHeight: parent.height - 4
  color: Design.colBg
  radius: 4

  Text {
    text: ""
    color: Design.colFg
    anchors {
      horizontalCenter: parent.horizontalCenter
      verticalCenter: parent.verticalCenter
    }

    font {
      family: Design.fontFamily
      pixelSize: Design.fontSize
    }
  }

  MouseArea {
    onClicked: {
      
    }
  }
}
