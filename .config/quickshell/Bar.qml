import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.Widgets
import qs.Services

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

      implicitHeight: Design.barHeight

      color: Design.transparent

      Rectangle {
        id: barRectangle
        anchors.fill: parent
        color: "grey"
        radius: Design.widgetRadius

        RowLayout {
          anchors {
            left: parent.left
            rightMargin: Design.barMargins
            leftMargin: Design.barMargins
            verticalCenter: parent.verticalCenter
          }
          spacing: 10

          AppWorksapcesButton {
            Layout.preferredHeight: Design.widgetHeight
            parentWindow: barWindow
          }

          Workspaces {
            Layout.preferredHeight: Design.widgetHeight
          }
        }

        RowLayout {
          anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            leftMargin: 12
            rightMargin: 12
          }
          spacing: 10

          ClockWidget {
            Layout.preferredHeight: Design.widgetHeight
          }
        }

        RowLayout {
          anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: Design.barMargins
            leftMargin: Design.barMargins
          }
          spacing: 10
          layoutDirection: Qt.RightToLeft

          StatusWidget {
            Layout.preferredHeight: Design.widgetHeight
          }
        }
      }
    }
  }
}
