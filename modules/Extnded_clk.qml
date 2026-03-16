
import Quickshell
import QtQuick
import Quickshell.Io
//import QtQuick.Shapes
import "./Widget"

PopupWindow {
    id: menu
    property var wifiData: ({})
    property var bar
    property bool open : false
    property bool scan_vis : false

    Process{
        id:connectProc
        onStarted : console.log("connect started")
        onExited: console.log("connect finished")
    }
    Process{
        id: get_connection_name
        running: true

        command: ["sh", "-c","~/.config/quickshell/modules/Widget/Wifi_backend.sh"]

        stdout: StdioCollector{
            onTextChanged: {
                try {
                    wifiData = JSON.parse(text.trim())
                } catch(e) {
                    console.log("wifi passed")
                }
            }
            onRead: (wifiData) => { try { wifiData = JSON.parse(data) } catch(e){console.log("wifi parse error", e)} }
        }
        
    }
    Timer {
        id: wifiRefresh
        interval: 3000
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


    visible: open || panel.height > 0
    color: "transparent"

    implicitWidth: 720
    implicitHeight: 500

    // position under bar
    anchor.window: bar
    anchor.rect.x: bar.width / 2 - implicitWidth / 2
    anchor.rect.y: bar.height - 0.51

    Rectangle {
        id: panel
        width: parent.width
        height: menu.open ? parent.height : 0
        clip: true
        color:  theme.background
        radius: 20

        Behavior on height {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutCirc
            }}

        Ripple {
            anchors.centerIn: parent
            running: menu.open && menu.wifiData.connected

        }

        Wifi_circle_comp {
            anchors.centerIn: parent
            wifiData: menu.wifiData
            connectProc: connectProc
        }
        
        Wifi_scan_panel {
            scan_vis : menu.scan_vis
            wifiData: menu.wifiData
            connectProc: connectProc
        }
        Background{
            id: bg
            open: menu.open
            clip: true
        }


        PillBut{
            label: "Wi-Fi"
            icon: ""
            pillscale: 1.1
            voff: 200
            hoff: -45
            fcus: true
         }
        PillBut{
            label: "Bluetooth"
            icon: ""
            pillscale: 1.1
            pillwidth: 1.5
            voff: 200
            fcus: false
            hoff: 45
        }


    }
}