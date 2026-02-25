import Quickshell
import QtQuick
// import "Screenspace.qml"

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

  property var test: false

  AppsWorkspaces {
    id: appsWorkspaces
    anchor.window: barWindow
    anchor.rect.y: 30
  }

  // Bingus2 {
  //   id: bingus2
  // }

  MouseArea {
    anchors.fill: parent
    onClicked: {
      appsWorkspaces.toggle()
      // bingus2.toggle()
      // console.log("Bingus.visible = " + bingus2.visible)
      console.log("Popup.visible = " + appsWorkspaces.visible)
      test = !test
      console.log("test = " + test)
    }
  }
}
