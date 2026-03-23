import QtQuick
//import Quickshell
//import QtQuick.Layouts

Item{
        id: root
        property var bluetoothData: ({})
        property var connectProc: ({})
        property bool scan_vis: false
        property bool search : false

        height: parent.height
        width: parent.width
        
        Rectangle{
            id: scan_pan
            visible: root.search
            height: root.scan_vis ? bluetoothList.implicitHeight + 40 : 0
            width: root.scan_vis ? 250 : 0
            opacity: root.scan_vis ? 1: 0
            radius: 20
            clip: true
            color: theme.on_secondary
            anchors.centerIn: parent
            z: 3
            Behavior on height {
            NumberAnimation{
                duration: 400
                easing.type: Easing.InOutQuad
            }}
            Behavior on opacity {
            NumberAnimation{
                duration: 600
                easing.type: Easing.InOutQuad
            }}

            Column{
            id: bluetoothList
            
            spacing: 8
            anchors{
                right: parent.right
                rightMargin: 20
                verticalCenter: parent.verticalCenter

            }

            Repeater{
                model: root.bluetoothData.devices ? root.bluetoothData.devices: []
                Rectangle{
                    width: 200
                    height: 40
                    radius: 10
                    color: theme.secondary
                    MouseArea{
                            anchors.fill: parent
                            onClicked:{
                                root.connectProc.command = [
                                    "sh", "-c", "bluetoothctl connect " + modelData.mac
                                ]
                                root.connectProc.running = true
                            }
                        }

                    Row{
                        anchors.centerIn:parent
                        spacing: 4
                        Text{text: "󰂰"}
                        Text{text: modelData.name}
                    }
                }
            }
        }
    }
    

    Rectangle{
        width: 190
        height: 90
        radius: 40
        opacity: 0.8
        color: theme.on_primary
        border.width: 0.5
        border.color: theme.scrim
        visible: root.scan_vis
        anchors{
            centerIn: parent
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: 220
            
        }
        MouseArea{
            anchors.fill: parent
            onClicked: root.search = !root.search
            }
        Column{
            anchors.centerIn: parent
        Text{
            text: "Scan Devices"
            color: "white"
            font.pixelSize:17
            font.family: "ESPACION"
            font.italic: true
        }
        Text{
            text: "-/-/-/-/-/-/-/-/-/-/-"
            font.family: "Pixelon"
            color: "white"
            }
        }
        }
}