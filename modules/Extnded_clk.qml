
import Quickshell
import QtQuick
import Quickshell.Io
//import QtQuick.Shapes
import "./Widget"

PopupWindow {
    id: menu
    property var wifiData: ({})
    property var bluetoothData: ({})
    property var bar
    property bool open : false
    property bool scan_vis : false
    property bool blth_scan_vis: false
    property bool blth_panel: false
    property bool wifi_panel: true

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
                    console.log("wifi error")
                }
            }
            //onRead: (wifiData) => { try { wifiData = JSON.parse(data) } catch(e){console.log("wifi parse error", e)} }
        }
        
    }
    Process{
        id: get_bt_connenction_name
        running: true
        command: ["sh", "-c","~/.config/quickshell/modules/Widget/Bluetooth_backend.sh"]

        stdout: StdioCollector{
            onTextChanged: {
                try {
                    bluetoothData = JSON.parse(text.trim())
                } catch(e) {
                    console.log("bluetooth passed")
                }
            }
            onRead: (bluetoothData) => { try { bluetoothData = JSON.parse(data) } catch(e){console.log("bluetooth parse error", e)} }
        }        
    }
    Timer {
        id: wifiRefresh
        interval: 3000
        running: menu.open && menu.wifi_panel
        repeat: true
        onTriggered: { 
            get_connection_name.running = false
            get_connection_name.running = true

            }
    }
    Timer {
        id: bluetoothRefresh
        interval: 3000
        running: menu.open && menu.blth_panel
        repeat: true
        onTriggered: { 
            get_bt_connenction_name.running = false
            get_bt_connenction_name.running = true
            }
    }
    
    onOpenChanged:{
        if(open) { 
        get_connection_name.running = false
        get_connection_name.running = true
        get_bt_connenction_name.running = false
        get_bt_connenction_name.running = true
        }
    }


    visible: open || panel.height > 0
    color: "transparent"

    implicitWidth: 720
    implicitHeight: 500

    // position under bar
    anchor.window: bar
    anchor.rect.x: bar.width / 2 - implicitWidth / 2
    anchor.rect.y: bar.height - 3

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
            visible: menu.wifi_panel
            anchors.centerIn: parent
            running: menu.open && menu.wifiData.connected

        }
        Ripple{
            visible: menu.blth_panel
            running: menu.open && menu.bluetoothData.connected
            anchors.centerIn: parent
        }
        Wifi_circle_comp {
            wifi_panel: menu.wifi_panel
            anchors.centerIn: parent
            wifiData: menu.wifiData
            connectProc: connectProc
        }
        
        Wifi_scan_panel {
            scan_vis : menu.scan_vis
            wifiData: menu.wifiData
            connectProc: connectProc
            visible: menu.wifi_panel
        }
        Background{
            id: bg
            open: menu.open
            clip: true
        }


        PillBut{
            id: wifi_pill
            label: "Wi-Fi"
            icon: ""
            pillscale: 1.1
            voff: 200
            hoff: -45
            fcus: true
            MouseArea{
                anchors.fill: parent
                onClicked:{
                    blth_pill.fcus = false
                    wifi_pill.fcus = true
                    menu.wifi_panel = true
                    menu.blth_panel = false
                    menu.blth_scan_vis = false
                }
            }
         }
        PillBut{
            id: blth_pill
            label: "Bluetooth"
            icon: ""
            pillscale: 1.1
            pillwidth: 1.5
            voff: 200
            fcus: false
            hoff: 45
            MouseArea{
                anchors.fill: parent
                onClicked:{
                    blth_pill.fcus = true
                    wifi_pill.fcus = false
                    menu.blth_panel = true
                    menu.wifi_panel = false
                    menu.blth_scan_vis = true
                }
            }
        }
        Bluetooth_circle_comp{
            bluetooth_panel: menu.blth_panel
            anchors.centerIn: parent
            bluetoothData: menu.bluetoothData
            connectProc: connectProc
        }
        Bluetooth_Panel{
            id: blth
            scan_vis: menu.blth_scan_vis
            bluetoothData: menu.bluetoothData
            connectProc: connectProc
        }


    }
}