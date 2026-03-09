import Quickshell
import QtQuick

PopupWindow {
    property bool open: false
    property var bar   // reference to the bar window
    color: "transparent"
    visible: open
    implicitWidth: 720
    implicitHeight: 450
    
    anchor.window: bar
    anchor.rect.x: bar.width / 2 - implicitWidth / 2
    anchor.rect.y: bar.height

    Rectangle {
        anchors.fill: parent
        bottomLeftRadius: 15
        bottomRightRadius: 15
        color: theme.background
    }
}