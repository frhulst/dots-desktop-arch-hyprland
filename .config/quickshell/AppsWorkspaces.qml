import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

PopupWindow {
  id: activeApps
  color: Design.transparent

  property var bingus: false
  visible: bingus

  function toggle() {
    bingus = !bingus
    visible = bingus
  }

  property var maxWidth: 600
  property var minWidth: 100

  implicitWidth: maxWidth
  implicitHeight: activeAppsList.contentHeight + 10

  property var getMaxWidth: (thisMax, prevMax) => maxWidth = Math.max(thisMax, prevMax)

  property var clients: []

  Process {
    id: getClients
    running: true
    command: [ "hyprctl", "clients", "-j" ]
    stdout: StdioCollector {
      onStreamFinished: {
        activeApps.clients = JSON.parse(this.text)
        // console.log(clients)
      }
    }
  }

  Connections {
    target: Hyprland
    function onRawEvent(ev) {
      if (ev.name === "openwindow" || ev.name === "closewindow") {
        // console.log("A new window has been opened || Closed!")
        getClients.running = true
      }
    }
  }

  Rectangle {
    id: activeAppsContainer
    anchors.fill: parent
    color: Design.colBg
    radius: 8
    visible: true

    implicitWidth: activeAppsList.width
    implicitHeight: activeAppsList.height

    ListView {
      id: activeAppsList
      anchors {
        bottom: parent.bottom
        left: parent.left
        right: parent.right
      }
      model: activeApps.clients
      implicitWidth: this.contentWidth
      implicitHeight: this.contentHeight
      orientation: Qt.Vertical
      verticalLayoutDirection: ListView.BottomToTop
      interactive: false

      Component {
        id: appDelegate
        RowLayout {
          anchors {
            horizontalCenter: parent.horizontalCenter
          }
          implicitWidth: parent.width 
          implicitHeight: Design.fontSize + 10

          Rectangle {
            color: Design.colFg
            implicitWidth: parent.width 
            implicitHeight: parent.height
            radius: 5
            border {
              width: 1
              color: "black"
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
        }
      }


      delegate: appDelegate

      Component.onCompleted: {
        console.log("nigga 2 " + activeApps.clients.length)
        for (let i = 0; i < activeApps.clients.length; i++) {
          activeApps.maxWidth = Math.max(activeAppsList.itemAtIndex(i), activeApps.maxWidth)
          console.log(activeApps.maxWidth)
        }
      }
    }
  }
}
