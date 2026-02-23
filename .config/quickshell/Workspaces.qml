import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts


Rectangle {
  id: wsPanel
  
  property var numOfWorkspaces: 10

  Layout.preferredHeight: barRectangle.height
  Layout.preferredWidth: barRectangle.height * numOfWorkspaces + numOfWorkspaces * 1.5
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
        implicitWidth: wsPanel.height - 2
        implicitHeight: wsPanel.height - 2
        radius: 4

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
      }
    }

    delegate: workspaceRectangle
  }
  Item { Layout.fillWidth: true }
}
