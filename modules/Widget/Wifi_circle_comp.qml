import QtQuick
//import QtQuick.Layouts
import QtQuick.Shapes
import "../../."
Item{
    id:main_circ_root
    property var wifiData: ({})
    property var connectProc: ({})
    width: 190
    Component.onCompleted:{
        console.log("")
    }
    height: 190
    Rectangle {
        id: circ_cent
        width: 190
        opacity: 1
        height: width
        radius: 100
        gradient: RadialGradient{
            centerX: 90; centerY: 90; centerRadius: 100;
            focalX: centerX; focalY: centerY;
            GradientStop{position:0.2;color:theme.secondary}
            GradientStop{position:0.9;color:theme.primary}
        }
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
                duration: 150
                easing.type: Easing.OutCubic
            }
            NumberAnimation{
                to: 1
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
        Column {
            anchors.centerIn: parent
            spacing: 4

            Text {
                font.family: "Symbols Nerd Font"
                text: wifiData.power==="on" ?  (wifiData.connected ? wifiData.connected.icon :  "\udb82\udd2f") : "\udb82\udd2e"
                font.pixelSize: 60
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: wifi_text1
                text: wifiData.connected ? wifiData.connected.ssid : ""
                font.pixelSize: wifiData.connected ? (wifiData.connected.ssid.length > 20 ? ((2-wifiData.connected.ssid.length/22)*16) : 16  ) : 15 
                font.bold: true
                font.family: "PIXELON"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                
                text: wifiData.connected ? "Connected" : "Disconnected"
                font.pixelSize: 14
                font.family: whispering
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
    Rectangle{
        width: 190
        height: 90
        radius: 40
        opacity: 0.9
        color: theme.on_secondary
        border.width: 0.5
        border.color: theme.scrim
        anchors{
            top: main_circ_root.top
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: 60
            topMargin: -130
        }
        MouseArea{
            anchors.fill: parent
            onDoubleClicked: P_data.tor_win=!P_data.tor_win
        }
        Column{
            anchors.centerIn: parent
            Text{
                color: "green"
                text: wifiData.connected ? wifiData.connected.ip : "----"
                font.pixelSize: 20
                font.family: "Pixelon"
                font.italic: true
            }
            Text{
                text: "Current IP Add"
                font.pixelSize:17
                font.family: "ESPACION"
                font.italic: true
            }
        }

    }


}