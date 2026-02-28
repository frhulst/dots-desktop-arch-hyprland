//AppsWorkspace.qml
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.Services

PopupWindow {
  id: activeApps
  color: Design.transparent

  visible: false
  property var maxWidth: 200
  property var componentHeight: 40

  // Function to toggle popup on/off
  function toggle() {
    visible = !visible
  }

  // Function to adopt width to the text
  function setWidth() {
    for (let i = 0; i < activeApps.clients.length; i++) {
      activeApps.maxWidth = Math.max(activeAppsList.itemAtIndex(i).textWidth, activeApps.maxWidth)
    }
    componentHeight = activeAppsList.itemAtIndex(0).height
  }

  implicitWidth: maxWidth + componentHeight + 2*5 + 1
  implicitHeight: activeAppsList.contentHeight + 10

  property var clients: []

  // Call to shell to get hypr clients in JSON
  Process {
    id: getClients
    running: true
    command: [ "hyprctl", "clients", "-j" ]
    stdout: StdioCollector {
      onStreamFinished: {
        activeApps.clients = JSON.parse(this.text)
      }
    }
  }
  
  // Call to shell to kill a specified window
  Process {
    id: killWindow
    running: false

    property var pid: 0

    command: [ "kill", pid ]
  }


  Connections {
    target: Hyprland
    function onRawEvent(ev) {
      if (ev.name === "openwindow" || ev.name === "closewindow") {
        getClients.running = true
        activeApps.setWidth()
      }
    }
  }

  Rectangle {
    id: activeAppsContainer
    anchors {
      fill: parent
    }
    color: Design.colBg
    radius: 8
    visible: true

    implicitWidth: parent.width
    implicitHeight: activeAppsList.height

    ListView {
      id: activeAppsList
      anchors {
        left: parent.left
        verticalCenter: parent.verticalCenter
        horizontalCenter: parent.horizontalCenter
      }
      model: activeApps.clients
      implicitWidth: activeApps.maxWidth
      implicitHeight: this.contentHeight
      orientation: Qt.Vertical
      verticalLayoutDirection: ListView.BottomToTop
      interactive: false

      Component {
        id: appDelegate
        RowLayout {
          anchors {
            left: parent.left
            right: parent.right
            margins: 5
          }
          spacing: 1
          implicitWidth: parent.width
          implicitHeight: Design.fontSize + 10

          Rectangle {
            color: Design.colFg
            implicitWidth: activeApps.maxWidth
            implicitHeight: parent.height
            radius: 5
            border {
              width: 1
              color: Design.colBg
            }

            Text {
              id: text
              text: modelData.workspace.id + ": " + modelData.class + " - " + modelData.title
              leftPadding: 5
              rightPadding: 5

              anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left  
              }

              font {
                family: Design.fontFamily
                pixelSize: Design.fontSize
              }              
            }


            MouseArea {
              anchors.fill: parent
              onClicked: {
                Hyprland.dispatch("workspace " + modelData.workspace.id)
                console.log("Change to workspace " + modelData.workspace.id)
              }
            }
          }

          Rectangle {
            color: "red"
            implicitWidth: parent.height
            implicitHeight: parent.height
            border {
              width: 1
              color: Design.colBg
            }

            radius: 5

            Text {
              text: "󰖭"
              color: Design.colBg

              anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
              }

              font {
                family: Design.fontFamily
                pixelSize: parent.height
                bold: true
              }
            }

            TapHandler {
              onTapped: {
                killWindow.pid = modelData.pid
                killWindow.running = true
              }
            }
          }

          readonly property var textWidth: text.width
        }
      }


      delegate: appDelegate

    }
  }
}
