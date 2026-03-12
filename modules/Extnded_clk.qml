
import Quickshell
import QtQuick
import Quickshell.Io
//import QtQuick.Shapes

PopupWindow {
    id: menu

    property string activename: ""
    property var wifiData: ({})
    property int radii: 0

    Process{id:connectProc}
    Process{
        id: get_connection_name
        running: true

        command: ["sh", "-c","~/.config/quickshell/modules/Widget/Wifi_backend.sh"]

        stdout: StdioCollector{
            onTextChanged: {
                try {
                    wifiData = JSON.parse(text.trim())
                } catch(e) {
                    console.log("wifi passed", data)
                }
            }
            onRead: (wifiData) => { try { wifiData = JSON.parse(data) } catch(e){console.log("wifi parse error", e)} }
        }
        
    }
    Timer {
        id: wifiRefresh
        interval: 5000
        running: menu.open
        repeat: true
        onTriggered: { 
            get_connection_name.running = false
            get_connection_name.running = true

            }
    }
    
    onOpenChanged:{
        if(open) { 
        get_connection_name.running = false
        get_connection_name.running = true
        }
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
    Item{
        anchors.centerIn:parent
        width: circ_cent.width + 300
        height: width
    Rectangle{
        id: raddii

        width: circ_cent.height
        height: width
        radius: width/2
        color: theme.on_tertiary
        opacity: 1
        anchors.centerIn:parent

        ParallelAnimation{
            running: menu.open
            loops: Animation.Infinite

            NumberAnimation{
                target: raddii
                property: "width"
                to: circ_cent.height + 300
                duration: 1200
            }
            NumberAnimation{
                target: raddii
                property: "opacity"
                to: 0
                duration: 1200
            }
            }
    }
            
    Rectangle {
        id: circ_cent
        width: 190
        height: 190
        radius: 100
        color: theme.secondary
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

        color: theme.on_secondary
        anchors{
            bottom: parent.verticalCenter
            left: parent.horizontalCenter
            leftMargin: -320
        }
        Column{
            anchors.centerIn: parent
            Text{
                color: wifiData.connected && wifiData.connected.signal < 30 ? "red"  : "black"
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
            height: scan_vis ? networkList.implicitHeight + 40 : 0
            width: scan_vis ? 250 : 0
            opacity: scan_vis ? 1: 0
            radius: 20
            clip: true
            color: theme.on_secondary
            anchors.centerIn: parent
            z: 4

            Behavior on width {
            NumberAnimation{
                duration: 200
                easing.type: Easing.InCubic
            }}
            Behavior on height {
            NumberAnimation{
                duration: 400
                easing.type: Easing.InCubic
            }}
            Behavior on opacity {
            NumberAnimation{
                duration: 200
                easing.type: Easing.InCubic
            }}

            Column{
            id: networkList
            
            spacing: 8
            anchors{
                right: parent.right
                rightMargin: parent.width/9.5
                verticalCenter: parent.verticalCenter

            }

            Repeater{
                model: wifiData.networks ? wifiData.networks: []
                visible: scan_vis 
                Rectangle{
                    width: 200
                    height: 40
                    radius: 10
                    color: theme.secondary
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
            text:"--"
            color: "white"
        }
        }

    }


    
    }
    }
    }
    }