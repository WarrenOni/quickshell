
import Quickshell
import QtQuick
import Quickshell.Io
import "../"
import "./Widget"
import QtQuick.Controls

Item {
    id: menu
    //property var wifiData: P_data.wifiData
    //property var bluetoothData: P_data.bluetoothData
    property int bar_height
    property int bar_width
    property var bar_window
    property bool open : false
    property bool scan_vis : false
    property real progress: open ? 1:0
    property var pills: ["Dash","Wi-fi","Bluetooth"]
    property bool blth_scan_vis: blth_panel
    property bool blth_panel: view.currentIndex===2
    property bool wifi_panel: view.currentIndex===1
    property bool clock_panel: view.currentIndex===0
    signal toggle()
   // onProgressChanged:console.debug(layout.height)
    Behavior on progress{NumberAnimation{duration:400;easing.type:Easing.OutBack;easing.overshoot: 0.5}}
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
                    P_data.wifiData = JSON.parse(text.trim())
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
                    P_data.bluetoothData = JSON.parse(text.trim())
                } catch(e) {
                    console.log("bluetooth passed")
                }
            }
            onRead: (bluetoothData) => { try { bluetoothData = JSON.parse(data) } catch(e){console.log("bluetooth parse error", e)} }
        }        
    }
    Timer {
        id: wifiRefresh
        interval: 1500
        running: menu.open && menu.wifi_panel
        repeat: true
        onTriggered: { 
            get_connection_name.running = false
            get_connection_name.running = true
            console.log("triggered_wifi_timer")
            }
    }
    Timer {
        id: bluetoothRefresh
        interval: 1500
        running: menu.open && menu.blth_panel
        repeat: true
        onTriggered: { 
            get_bt_connenction_name.running = false
            get_bt_connenction_name.running = true
            }
    }
    
    visible: open || panel.y > -menu.height
    //color: "transparent"

    implicitWidth: 750
    implicitHeight: 530

    // position under bar
   // anchor.rect.x: bar_width / 2 - implicitWidth / 2
    //anchor.rect.y: bar_height
    //anchor.window: bar_window
    //Corner{anchors.left: layout.right;}
    //Corner{anchors.right: layout.left;deg:90}
    //Rectangle{
    //        id: layout
    //        color: theme.background
    //        bottomLeftRadius:20
    //        bottomRightRadius: bottomLeftRadius
    //        width: parent.width-30
    //        height: 20+((parent.height-20)*menu.progress)
            anchors.horizontalCenter: parent.horizontalCenter
            //border.color: theme.on_primary
            //border.width: 0.5
    //}

    Item {
        id: panel
        width: layout.width
        height: parent.height
        clip: true
        anchors.horizontalCenter: parent.horizontalCenter
        y: !menu.open ? -menu.height : 0
        
        Behavior on y{
            NumberAnimation{
                duration: 400
                easing.type: Easing.OutBack
                easing.overshoot: 0.5
                onRunningChanged:{
                    if (!menu.visible) {
                    console.log("got sig_kill for dash_menu"); menu.toggle()
                    }}
                }
            }
    //Background{
     //       id: bg
      //     clip: true
    //}
    SwipeView{
        id: view
        anchors.fill: parent
        

        Dash{
            open: menu.open     
        }

        Item{

        Ripple {
            visible: menu.wifi_panel
            anchors.centerIn: parent
            running: menu.open && P_data.wifiData.connected 
        }
        Wifi_circle_comp {
            anchors.centerIn: parent
            wifiData: P_data.wifiData
            connectProc: connectProc
        }
        
        Wifi_scan_panel {
            scan_vis : menu.scan_vis
            wifiData: P_data.wifiData
            connectProc: connectProc
        }
        }
        
        Item{
            id: blth_item
        Ripple{
            visible: menu.blth_panel
            running:{ menu.open ? 
            (P_data.bluetoothData.power === "on" ? 
            (P_data.bluetoothData.connected ? true : false)
            :false) : false}
            anchors.centerIn: parent
        }
        Bluetooth_circle_comp{
            anchors.centerIn: parent
            bluetoothData: P_data.bluetoothData
            connectProc: connectProc
        }
        Bluetooth_Panel{
            id: blth
            scan_vis: menu.blth_scan_vis
            bluetoothData: P_data.bluetoothData
            connectProc: connectProc
        }
        }

    }

        Row{
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenterOffset: 210
            anchors.horizontalCenterOffset: 15
            spacing: 15
        Repeater{
            id: model1
            model: menu.pills
            delegate:PillBut{
            id: pill_del
            label: modelData
            pillscale: 1.1
            fcus: view.currentIndex===index
            MouseArea{
                anchors.fill: parent
                onClicked:{view.currentIndex=index}
            }
            }
            }
        }


    }
}