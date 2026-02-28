import QtQuick
import qs.Services

Rectangle {
  id: clockWidget
  implicitWidth: clockText.width + 10
  radius: Design.widgetRadius

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
      pixelSize: Design.fontSize * 1.2
    }
  }

  Text {
    id: dateText
    visible: false

    anchors {
      horizontalCenter: parent.horizontalCenter
      verticalCenter: parent.verticalCenter
    }
    text: Time.date
    color: "white"
    font {
      family: Design.fontFamily
      pixelSize: Design.fontSize * 0.8
    }

  }

  MouseArea {
    anchors.fill: parent
    onClicked: {
      clockText.visible = !clockText.visible
      dateText.visible = !clockText.visible
      if (clockText.visible) {
        clockWidget.implicitWidth = clockText.width + 10
      } else {
        clockWidget.implicitWidth = dateText.width + 10
      }
    }
  }
}
