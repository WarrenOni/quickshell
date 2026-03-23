import QtQuick
//import QtQuick.Layouts

Item{
    id:main_circ_root
    property var wifiData: ({})
    property var connectProc: ({})
    property bool wifi_panel: true
    visible: main_circ_root.wifi_panel
    width: 190
    height: 190
    Rectangle {
        id: circ_cent
        width: 190
        height: 190
        radius: 100
        color: theme.secondary
        anchors.centerIn: parent

        MouseArea{
            anchors.fill: parent
            onClicked: {
                main_circ_root.connectProc.command = [
                "sh", "-c", "~/.config/quickshell/modules/Widget/wifi_on.sh"
                ]
                main_circ_root.connectProc.running = true
                pop.running = true
                
            }
        }
        SequentialAnimation on scale{
            id: pop
            NumberAnimation{
                from: 1
                to: 0.95
                duration: 100
                easing.type: Easing.InCubic
            }
            NumberAnimation{
                to: 1
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
        Column {
            anchors.centerIn: parent
            spacing: 3

            Text {
                font.family: "Symbols Nerd Font"
                text: wifiData.connected ? wifiData.connected.icon : "󰤮"
                font.pixelSize: 60
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: wifi_text1
                text: wifiData.connected ? wifiData.connected.ssid : "Not Connected"
                font.pixelSize: 16
                font.family: whispering
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                
                text: wifiData.connected ? "Connected" : "Disconnected"
                font.pixelSize: 12
                font.family: wifi_text1.font.family
                anchors.horizontalCenter: parent.horizontalCenter                
            }
        }  
    }
    Rectangle{
        width: 190
        height: 90
        radius: 40
        opacity: 0.8
        color: theme.on_secondary
        border.width: 0.5
        border.color: theme.scrim
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


}