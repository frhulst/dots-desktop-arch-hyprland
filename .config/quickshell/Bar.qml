import Quickshell
import QtQuick
import QtQuick.Layouts

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      property string position: "bottom"

      screen: modelData
      
      anchors {
        bottom: position === "bottom"
        top: position === "top"
        left: true
        right: true
      }

      margins {
        left: 8
        right: 8
        bottom: position === "bottom" ? 5 : 0
        top: position === "top" ? 5 : 0
      }

      implicitHeight: 35

      color: Design.transparent

      Rectangle {
        id: barRectangle
        anchors.fill: parent
        color: Design.transparent
        border.width: 0

        RowLayout {
          anchors {
            leftMargin: 12
            rightMargin: 12
            verticalCenter: parent.verticalCenter
          }
          spacing: 10

          AppWorksapcesButton {}

          Workspaces {}
        }

        RowLayout {
          anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            leftMargin: 12
            rightMargin: 12
          }
          spacing: 10

          ClockWidget {}
        }
      }
    }
  }
}
