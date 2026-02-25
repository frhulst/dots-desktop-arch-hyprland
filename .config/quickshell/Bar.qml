import Quickshell
import QtQuick
import QtQuick.Layouts

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: barWindow
      required property var modelData
      property string position: "top"

      screen: modelData
      
      anchors {
        bottom: position === "bottom"
        top: position === "top"
        left: true
        right: true
      }

      margins {
        left: Design.fontSize / 3
        right: Design.fontSize / 3
        bottom: position === "bottom" ? Design.fontSize / 3 : 0
        top: position === "top" ? Design.fontSize / 3 : 0
      }

      implicitHeight: Design.fontSize * 2

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
