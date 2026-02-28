import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.Services


Rectangle {
  id: wsPanel
  
  property var numOfWorkspaces: 10

  Layout.preferredWidth: this.height * numOfWorkspaces + numOfWorkspaces * 1.5
  color: Design.transparent

  
  ListView {
    model: numOfWorkspaces
    orientation: Qt.Horizontal
    verticalLayoutDirection: ListView.LeftToRight
    anchors.fill: parent
    spacing: 4
    interactive: false
    
    Component {
      id: workspaceRectangle
      Rectangle {
        id: workspaceContainer
        implicitWidth: Design.widgetHeight
        implicitHeight: Design.widgetHeight
        radius: Design.widgetRadius

        border {
          width: Design.widgetHeight / 16
          color: Design.transparent
        }

        property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
        property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

        color: isActive ? Design.colCyan : Design.colBg

        Text {
          anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
          }
          text: index + 1 === 10 ? "0" : index + 1
          color: isActive ? "black" : (ws ? Design.colBlue : Design.colMuted)
          font {family: Design.fontFamily; pixelSize: Design.fontSize; bold: true }
        }

        MouseArea {
          anchors.fill: parent
          onClicked: Hyprland.dispatch("workspace " + (index + 1))
        }

        HoverHandler {
          id: mouse
          acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
          cursorShape: Qt.PointingHandCursor

          onHoveredChanged: {
            if (hovered) {
              workspaceContainer.border.color = Design.colBlue
            } else {
              workspaceContainer.border.color = Design.transparent
            }
          }
        }
      }
    }

    delegate: workspaceRectangle
  }
  Item { Layout.fillWidth: true }
}
