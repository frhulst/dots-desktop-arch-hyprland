import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.Services
import qs.Popups

Rectangle {
  id: popupButton
  color: Design.colBg
  Layout.preferredWidth: this.height
  radius: Design.widgetRadius

  property var parentWindow: ""

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

  AppsWorkspaces {
    id: appsWorkspaces
    anchor.window: popupButton.parentWindow
    anchor.rect.y: Design.barHeight + Design.barMargins
  }

  MouseArea {
    anchors.fill: parent
    onClicked: {
      appsWorkspaces.toggle()
      appsWorkspaces.setWidth()
    }
  }
}
