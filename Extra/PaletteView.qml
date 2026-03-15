import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Controls
import Quickshell.Io

Item{
    id: root
    property var colorList: []
    
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: 0
        Flickable {
            anchors.fill: parent
            contentWidth : 2000
            contentHeight: parent.height
            clip: true
            RowLayout {
                id: color_layout
                spacing:  60
                anchors.verticalCenter: parent.verticalCenter
                Repeater {
                    model: root.colorList
                    Rectangle {
                        id: color_item
                        width: 200
                        height: 350
                        color: modelData
                        radius: 0
                        clip: true

                        property real hoverscale: 1
                        transform: Shear{
                            xFactor: 0.304
                            yFactor: 0
                        }
                        scale: hoverscale
                        Behavior on hoverscale{
                            NumberAnimation{
                                duration: 400
                                easing.type: Easing.InCurve
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: console.log("select color", modelData)
                            // Visual feedback
                            onEntered:{
                                 parent.border.width = 2
                                 parent.border.color = modelData
                                 color_item.hoverscale = 1.5
                                }
                            onExited: {
                                parent.border.width = 0
                                parent.border,color = null
                                color_item.hoverscale = 1    
                                }
                        }
                    }
                }
            }
        }
    }
}