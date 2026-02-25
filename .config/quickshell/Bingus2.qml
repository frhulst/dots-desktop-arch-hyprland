import QtQuick
import Quickshell

PanelWindow {
  id: toplevel

  function toggle() {
    popup.visible = !popup.visible
  }



  anchors {
    bottom: true
    left: true
    right: true
  }

  Rectangle {
    anchors.fill: parent
    PopupWindow {
      id: popup
      anchor.window: toplevel
      anchor.rect.x: parentWindow.width / 2 - width / 2
      anchor.rect.y: parentWindow.height
      width: 500
      height: 500
      visible: true
      color: Design.colBg
    }
  }
}
