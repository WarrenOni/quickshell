import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import "~/.config/quickshell"
ShellRoot {
    id: root

    Colors {id:theme}

    PanelWindow {
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
                    color: modelData.active ? theme.primary : theme.on_primary_fixed

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch(
                            "workspace " + modelData.id
                        )
                    }
                }
            }

            Item { Layout.fillWidth: true }

            Rectangle{
                Layout.alignment:Qt.AlignVCenter
                topLeftRadius: 20
                bottomLeftRadius: 20
                bottomRightRadius:11
                color: UPower.displayDevice.percentage < 0.20 ? "#f00" : theme.on_primary_fixed
                implicitHeight: 28
                implicitWidth: UPower.displayDevice.percentage * 100
                anchors.verticalCenterOffset: -1
            
            Text {
                color: "white"
                anchors.centerIn: parent
                font.pixelSize: 15
                font.italic: true
                font.bold: true
                text: Math.round(UPower.displayDevice.percentage * 100) + "%"
                visible: UPower.displayDevice.present
                Layout.rightMargin: 5
                
            }}

        }

         // 🔹 Clock
        Rectangle{
            width: 80
            height: 29
            radius: 10
            color: theme.on_primary_fixed
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -1
        Text {
            id: clock
            color: "white"
            anchors.centerIn:parent
            font.pixelSize: 18
            font.italic: true
            font.bold: true
            text: Qt.formatDateTime(new Date(), "hh:mm")
        }}
    }
    }
}
