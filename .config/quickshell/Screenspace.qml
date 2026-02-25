import Quickshell
import QtQuick

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData

      screen: modelData

      anchors {
        left: true
        right: true
        top: true
        bottom: true
      }

      color: Design.transparent
      
      AppsWorkspaces {
        id: appsWorkspaces
        visible: true
        anchor.edges: Edges.Bottom | Edges.Left
      }
    }
  }
}
 
