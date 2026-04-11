import QtQuick
import QtQuick.Shapes
//import QtQuick.Layouts

Item{
    id:main_circ_root
    property var bluetoothData: ({})
    property var connectProc: ({})
    property bool bluetooth_panel: true
    visible: main_circ_root.bluetooth_panel
    width: 190
    height: 190
    Rectangle {
        id: circ_cent
        width: 190
        height: 190
        radius: 100
        opacity: 1
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
                "sh", "-c", "~/.config/quickshell/modules/Widget/bluetooth_on.sh"
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
            spacing: 3

            Text {
                font.family: "Symbols Nerd Font"
                text:{
                    if (bluetoothData.power == "on") {
                        if (bluetoothData.connected) {
                           return "󰂱"
                        }
                        else{ return "󰂯"}
                    }
                    else{ return "󰂲" }
                }
                font.pixelSize: 60
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: wifi_text1
                text: bluetoothData.power === "on" ? ( bluetoothData.connected ? bluetoothData.connected.name : "Not Connected" ): ""
                font.pixelSize: 16
                font.family: whispering
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                text: bluetoothData.connected ? bluetoothData.connected.type : ""
                font.pixelSize: 12
                font.family: wifi_text1.font.family
                anchors.horizontalCenter: parent.horizontalCenter                
            }

            Text {
                
                text: bluetoothData.connected ? "" : "Disconnected"
                font.pixelSize: wifi_text1.text != "" ? 12 : 16
                font.family: wifi_text1.font.family
                anchors.horizontalCenter: parent.horizontalCenter                
            }
        }  
    }
    Rectangle{
        width: 190
        height: 90
        visible: bluetoothData.connected ? true: false
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
                color: "grey"
                text: bluetoothData.connected ? bluetoothData.connected.mac : "---"
                font.pixelSize: 20
                font.family: "Pixelon"
                font.italic: true
            }
            Text{
                text: "Mac Address."
                font.pixelSize:17
                font.family: "ESPACION"
                font.italic: true
            }
        }

    }


}