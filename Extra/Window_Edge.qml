import Quickshell
import QtQuick
import "../modules/Reusable/."
PanelWindow{
    exclusiveZone:0
    id:window_edge
    height:10
    anchors{
        top: true
        left: true
        right: true
    }
    Corner{anchors.left:parent.left;anchors.top:parent.top}
    Corner{anchors.left:parent.right;anchors.top:parent.top;deg:90}

    color: "transparent"
}