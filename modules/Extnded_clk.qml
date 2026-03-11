
import Quickshell
import QtQuick
import Quickshell.Io
//import QtQuick.Shapes

PopupWindow {
    id: menu

    // ✅ ADDED: property so QML can bind the value
    property string activename: ""
    property var wifiData: ({})

    Process{id:connectProc}
    Process{
        id: get_connection_name
        running: true

        command: ["bash","-c","~/.config/quickshell/modules/Widget/Wifi_backend.sh"]

        stdout: StdioCollector{
            // ✅ CHANGED: safer way to read output
            onTextChanged: {
                try {
                    wifiData = JSON.parse(text)
                } catch(e) {
                    console.log("wifi parse error", e)
                }
            }
        }
    }
    Timer {
    interval: 5000
    running: menu.open
    repeat: true
    onTriggered: get_connection_name.start()
    }

    property var bar
    property bool open : false
    property bool scan_vis : false

    visible: open || panel.height > 0
    color: "transparent"

    implicitWidth: 720
    implicitHeight: 500

    // position under bar
    anchor.window: bar
    anchor.rect.x: bar.width / 2 - implicitWidth / 2
    anchor.rect.y: bar.height

    Rectangle {
        id: panel
        width: parent.width
        height: open ? parent.height : 0
        clip: true
        color:  theme.background
        radius: 20

        Behavior on height {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutCirc
            }
        }

    Rectangle {
        width: 190
        height: 190
        radius: 100
        color: "#6faed1"

        anchors.centerIn: parent

        Column {
            anchors.centerIn: parent
            spacing: 3

            Text {
                font.family: "Symbols Nerd Font"
                text: wifiData.connected ? wifiData.connected.icon : "󰤮"
                font.pixelSize: 50
            }

            Text {
                text: wifiData.connected ? wifiData.connected.ssid : "Not Connected"
                font.pixelSize: 16
            }

            Text {
                
                text: wifiData.connected ? "Connected" : "Disconnected"
                font.pixelSize: 12
            }
        }   

    
    Rectangle{
        width: 190
        height: 90
        radius: 40

        color: theme.on_primary
        anchors{
            bottom: parent.verticalCenter
            left: parent.horizontalCenter
            leftMargin: -320
        }
        Column{
            anchors.centerIn: parent
            Text{
                color: wifi.connected && wifiData.connected.signal < 30 ? "red"  : "black"
                text: wifiData.connected ? wifiData.connected.signal + " % " : "---"
                font.pixelSize: 20
                font.family: "Pixelon"
                font.italic: true
            }
            Text{
                text: "Signal Strength"
                font.pixelSize:17
                font.family: "ESPACION"
                font.italic: true
            }
        }

    }

    Rectangle{
            anchors.right: parent.right
            id: scan_pan
            visible: scan_vis 
            height: 30
            width: 20
            radius: 20
            color: theme.background
        Column{
            id: networkList
            
            spacing: 8
            anchors{
                right: parent.right
                rightMargin: 40
                verticalCenter: parent.verticalCenter

            }

            Repeater{
                model: wifiData.networks ? wifiData.networks: []
                visible: scan_vis 
                Rectangle{
                    width: 200
                    height: 40
                    radius: 10
                    color: "lightgreen"
                    MouseArea{
                            anchors.fill: parent
                            onClicked:{
                                connectProc.command = [
                                    "bash", "-c", "nmcli device wifi connect '" + modelData.ssid + "'"
                                ]
                                connectProc.start()
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

        color: theme.on_primary
        anchors{
            bottom: parent.bottom
            right: parent.right
            rightMargin: -220
        }
        MouseArea{
            anchors.fill: parent
            onClicked: menu.scan_vis = !menu.scan_vis
        }
        Text{
            text: "Scan Networks" 
            color: "white"
        }

    }


    
    }
    }
}