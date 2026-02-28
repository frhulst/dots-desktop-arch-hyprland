import QtQuick
import QtQuick.Layouts
import qs.Services

Rectangle {
  id: statusWidget

  color: Design.colBg
  radius: Design.widgetRadius

  
  implicitWidth: 200

  RowLayout {
    anchors.fill: parent
    spacing: 5

    Rectangle {
      color: Design.colFg
      implicitWidth: 30
      implicitHeight: parent.height
      Layout.alignment: Qt.AlignLeft
      Layout.leftMargin: Design.fontSize / 3
    }

    Rectangle {
      color: Design.colFg
      implicitWidth: 5
      implicitHeight: parent.height
      Layout.alignment: Qt.AlignCenter

    }

    Rectangle {
      // color: Design.transparent
      color: Design.colFg
      implicitWidth: percentageIcon.width
      implicitHeight: parent.height
      Layout.alignment: Qt.AlignRight
      Layout.rightMargin: Design.fontSize / 3
      Text {
        id: percentageIcon
        anchors {
          verticalCenter: parent.verticalCenter
          horizontalCenter: parent.horizontalCenter
        }
        visible: true
        text: BatteryStats.batteryIcon
        color: BatteryStats.color
        verticalAlignment: Text.AlignVCenter
        font {
          family: Design.fontFamily
          pixelSize: Design.fontSize * 2.5
          bold: true
        }
        Text {
          id: percentageText
          anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: Design.fontSize * 0.5
          }
          visible: true
          text: BatteryStats.batteryPercentage
          color: "white"
          horizontalAlignment: Text.AlignHCenter
          font {
            family: Design.fontFamily
            pixelSize: Design.fontSize * 0.8
          }
        }
      }
    }
    
  }
}
