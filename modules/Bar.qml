
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts 



PanelWindow {
        Extnded_clk{
            id: menu
            anchors.top: bar.bottom
        }
        //-------vol
        property int volume: 0
        property bool volumeMuted: false
        property var defaultAudioSink
        //----------

        id: bar
        height: 33 + menu.height
        color:"transparent"

        anchors{
            top: true
            left: true
            right: true
        }


        Rectangle{
        anchors.fill: parent 
        color: theme.background
        bottomLeftRadius:20
        bottomRightRadius: 20

        RowLayout {
            anchors.fill: parent     
            anchors.leftMargin: 10       
            spacing: 5
            // 🔹 Workspaces
            Repeater {
                
                model: Hyprland.workspaces

                    Rectangle {
                    implicitHeight: 20
                    implicitWidth: 20
                    radius: 10
                    color: modelData.active ? theme.primary : theme.on_primary

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch(
                            "workspace " + modelData.id
                        )
                    }
                }
            }

            Item { Layout.fillWidth: true }
            
            // 🔹 Battery
            Rectangle{
                id: containerRect
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 10
                radius: 20
                border.color: UPower.displayDevice.charging ? "#0f0" : (UPower.displayDevice.percentage < 0.20 ? "#f00" : theme.on_primary)
                color: theme.background
                border.width: 1
                implicitHeight: 25
                implicitWidth: 80
                anchors.verticalCenterOffset: -0.5
            
            Rectangle{
                id: innerFill
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                radius: 20
                border.width:0.5
                color: UPower.displayDevice.charging ? "#0f0" : (UPower.displayDevice.percentage < 0.20 ? "#f00" : theme.on_primary)
                implicitHeight: 25
                implicitWidth: UPower.displayDevice.percentage * 100
                anchors.verticalCenterOffset: 0
            }
            Text {
                id: innerText
                color: "white"
                anchors.centerIn: parent
                font.pixelSize: 15
                font.italic: true
                font.family: "Pixelon"
                font.bold: UPower.displayDevice.percentage < 0.20 ? true : false
                text: Math.round(UPower.displayDevice.percentage * 100) + "%"
                visible: UPower.displayDevice.present
            }

        }}

         // 🔹 Clock
        Rectangle{
            width: 120
            height: 25
            radius: 15
            color: theme.on_primary
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -0.5
            MouseArea{
                anchors.fill: parent
                onClicked: menu.open = !menu.open
            }

        SystemClock{
            id: clock
            precision: SystemClock.Minutes

        }

        Text {
            color: "white"
            anchors.centerIn:parent
            font.pixelSize: 18
            font.italic: true
            font.bold: true
            font.family: "Orbitron"
            text: Qt.formatDateTime(clock.date, "hh:mm")
             MouseArea{
                anchors.fill: parent
                onClicked: menu.open = !menu.open
            }

        }}

        // Volume
        Rectangle{
            id: volumeContainer
            anchors{
                right: parent.right
                rightMargin: 100
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: -0.5
            }
            color: theme.background
            radius: 20
            border.width: 1
            border.color: theme.on_primary
            implicitWidth: 80
            implicitHeight: 25
                
        Rectangle{
            anchors{
                right: parent.right
                rightMargin: 0
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: -0.5
            }
            color: theme.on_primary
            radius: 20
            implicitWidth: volume * 0.8
            implicitHeight: 25
            }
        Text{
             color: "white"
            anchors.centerIn: volumeContainer
            font.pixelSize: 15
            font.italic: true
            font.family: "Pixelon"
            //visible: UPower.displayDevice.present
            Layout.rightMargin: 2
            anchors.verticalCenterOffset: 1.5
            text: volumeMuted ? "Muted" : volume + "%"
        }
                }

    }
}

