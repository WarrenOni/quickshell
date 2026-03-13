    import QtQuick
    import Quickshell
    import QtQuick.Layouts
    import QtQuick.Effects

    Item{
        id: root
        property var wifiData: ({})
        property var connectProc: ({})
        property bool scan_vis: false
        height: parent.height
        width: parent.width
        

        Rectangle{
            id: scan_pan
            visible: root.scan_vis 
            height: root.scan_vis ? networkList.implicitHeight + 40 : 0
            width: root.scan_vis ? 250 : 0
            opacity: root.scan_vis ? 1: 0
            radius: 20
            clip: true
            color: theme.on_secondary
            anchors.centerIn: parent

            MultiEffect{
                source: parent
                anchors.fill: parent
                shadowBlur: 1.0
                shadowEnabled: true
                shadowColor: "black"
                shadowVerticalOffset: 20
                shadowHorizontalOffset: 20
            }

            z: 4
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
            id: networkList
            
            spacing: 8
            anchors{
                right: parent.right
                rightMargin: 20
                verticalCenter: parent.verticalCenter

            }

            Repeater{
                model: root.wifiData.networks ? root.wifiData.networks: []
                Rectangle{
                    width: 200
                    height: 40
                    radius: 10
                    color: theme.secondary
                    MouseArea{
                            anchors.fill: parent
                            onClicked:{
                                root.connectProc.command = [
                                    "sh", "-c", "nmcli device wifi connect '" + modelData.ssid + "'"
                                ]
                                root.connectProc.running = true
                            }
                        }

                    Row{
                        anchors.centerIn:parent
                        spacing: 4
                        Text{text: modelData.icon}
                        Text{text: modelData.ssid}
                        Text{text: modelData.signal + "%"}
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
        
        anchors{
            centerIn: parent
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: 220
            
        }
        MouseArea{
            anchors.fill: parent
            onClicked: root.scan_vis = !root.scan_vis
        }
        Column{
            anchors.centerIn: parent
        Text{
            text: "Scan Networks"
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