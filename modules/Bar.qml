
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts 



PanelWindow {

        //-------vol
        property int volume: 0
        property bool volumeMuted: false
        property var defaultAudioSink
        //----------

        id: bar
        height: 33
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
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 10
                radius: 20
                border.color: theme.on_primary
                color: theme.background
                border.width: 1
                implicitHeight: 25
                implicitWidth: 80
                anchors.verticalCenterOffset: -0.5
            
            Rectangle{
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                radius: 20
                color: UPower.displayDevice.percentage < 0.20 ? "#f00" : theme.on_primary
                implicitHeight: 25
                implicitWidth: UPower.displayDevice.percentage * 100
                anchors.verticalCenterOffset: -0.5
            
            Text {
                color: "white"
                anchors.centerIn: parent
                font.pixelSize: 15
                font.italic: true
                font.family: "Pixelon"
                font.bold: UPower.displayDevice.percentage < 0.20 ? true : false
                text: Math.round(UPower.displayDevice.percentage * 100) + " %"
                visible: UPower.displayDevice.present
                //Layout.rightMargin: 2
                anchors.verticalCenterOffset: 1.5
                
            }}

        }}

         // 🔹 Clock
        Rectangle{
            width: 120
            height: 25
            radius: 15
            color: theme.on_primary
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -0.5
        Text {
            id: clock
            color: "white"
            anchors.centerIn:parent
            font.pixelSize: 18
            font.italic: true
            font.bold: true
            font.family: "Orbitron"
            text: Qt.formatDateTime(new Date(), "hh:mm")
        }}

        // Volume
        Rectangle{
            anchors{
                right: parent.right
                rightMargin: 100
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: -0.5
            }
            color: theme.on_primary
            radius: 20
            implicitWidth: 80
            implicitHeight: 25
        Text{
             color: "white"
            anchors.centerIn: parent
            font.pixelSize: 15
            font.italic: true
            font.family: "Pixelon"
            //visible: UPower.displayDevice.present
            Layout.rightMargin: 2
            anchors.verticalCenterOffset: 1.5
            text: volumeMuted ? "Muted" : volume + "%"
        }
/*
        Volume {
            id: volumeWidget
            anchors{
                right: parent.right
                rightMargin: 5
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: -0.5 
            }
            shell: bar
            volume: bar.volume
            volumeMuted: bar.volumeMuted
        }*/
        }
    }
    }
