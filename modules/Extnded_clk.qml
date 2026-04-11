
import Quickshell
import QtQuick
import Quickshell.Io
//import QtQuick.Shapes
import "./Widget"

PopupWindow {
    id: menu
    property var wifiData: ({})
    property var bluetoothData: ({})
    property int bar_height
    property int bar_width
    property var bar_window
    property bool open : false
    property bool scan_vis : false
    property bool blth_scan_vis: false
    property bool blth_panel: false
    property bool wifi_panel: false
    property bool clock_panel: true
    signal toggle()
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
        interval: 2000
        running: menu.open && menu.wifi_panel
        repeat: true
        onTriggered: { 
            get_connection_name.running = false
            get_connection_name.running = true

            }
    }
    Timer {
        id: bluetoothRefresh
        interval: 2000
        running: menu.open && menu.blth_panel
        repeat: true
        onTriggered: { 
            get_bt_connenction_name.running = false
            get_bt_connenction_name.running = true
            }
    }
    
    onOpenChanged:{
        if(menu.open) { 
        //get_connection_name.running = false
        get_connection_name.restart //= true
        //get_bt_connenction_name.running = false
        get_bt_connenction_name.restart //= true
        }
    }
    visible: open || panel.y > -menu.height
    color: "transparent"

    implicitWidth: 720
    implicitHeight: 500

    // position under bar
    anchor.rect.x: bar_width / 2 - implicitWidth / 2
    anchor.rect.y: bar_height - 3
    anchor.window: bar_window

    Rectangle {
        id: panel
        width: parent.width
        height: menu.height
        clip: true
        color:  theme.background
        radius: 20
        border.color: theme.on_primary
        border.width: 0.5
        y: !menu.open ? -menu.height : 0
        /*NumberAnimation {
                id: panel_anim
                duration: 600
                target: panel
                property: "y"
                from: menu.open ? -menu.height : 0 
                to: menu.open ? 0: -panel.height
                easing.type: Easing.OutQuart
                running: menu.open || !menu.open
                onFinished: if(!menu.open)menu.toggle()
        }*/
        Behavior on y{
            NumberAnimation{
                duration: 600
                easing.type: Easing.OutQuart
                onRunningChanged:{
                    if (!menu.visible) {
                    console.log("got sig_kill for dash_menu"); menu.toggle()
                    }}
            }
        }

        Item{
            anchors.centerIn: parent

        Ripple {
            visible: menu.wifi_panel
            anchors.centerIn: parent
            running: menu.open && menu.wifiData.connected

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
        }
        
        Background{
            id: bg
            clip: true
        }

        PillBut{
            id: clock_pill
            label: "Dash"
            pillscale: 1.1
            voff: 200
            hoff: -80
            fcus: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            MouseArea{
                anchors.fill: parent
                onClicked:{
                    blth_pill.fcus = false
                    wifi_pill.fcus = false
                    clock_pill.fcus = true
                    menu.clock_panel = true
                    menu.wifi_panel = false
                    menu.blth_panel = false
                    menu.blth_scan_vis = false
                }
            }
         }

        Clock_Extnded_clk{
            clock_panel: menu.clock_panel
            open: menu.open
        }


        PillBut{
            id: wifi_pill
            label: "Wi-Fi"
            pillscale: 1.1
            voff: 200
            hoff: 0
            fcus: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            MouseArea{
                anchors.fill: parent
                onClicked:{
                    blth_pill.fcus = false
                    wifi_pill.fcus = true
                    clock_pill.fcus = false
                    menu.wifi_panel = true
                    menu.blth_panel = false
                    menu.blth_scan_vis = false
                    menu.clock_panel = false
                }
            }
         }
        PillBut{
            id: blth_pill
            label: "Bluetooth"
            pillscale: 1.1
            pillwidth: 1.5
            voff: 200
            fcus: false
            hoff: 95
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            MouseArea{
                anchors.fill: parent
                onClicked:{
                    blth_pill.fcus = true
                    wifi_pill.fcus = false
                    clock_pill.fcus = false
                    menu.blth_panel = true
                    menu.wifi_panel = false
                    menu.blth_scan_vis = true
                    menu.clock_panel = false
                }
            }
        }
        Item{
            height: parent.height
            width: parent.width
        Ripple{
            visible: menu.blth_panel
            running:{ menu.open ? 
            (menu.bluetoothData.power === "on" ? 
            ( menu.bluetoothData.connected ? true : false)
            :false) : false}
            anchors.centerIn: parent
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
}