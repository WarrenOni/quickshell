
import Quickshell
//import Quickshell.Services.Pipewire
import Quickshell.Hyprland
//import Quickshell.Io
import Quickshell.Services.UPower
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts 



PanelWindow {
    
        //-------vol
        property string whispering: ""
        property int volume: 0
        property bool volumeMuted: false
        property var defaultAudioSink
        //----------

        id: bar
        implicitHeight: 36 + mainbar.anchors.topMargin*2 //+ menu.height
        color: "transparent"
        anchors{
            top: true
            left: true
            right: true
        }

        //MENU
                    
        Extnded_clk{
            id: menu2
            bar: bar
            //anchors.bottom: parent.bottom
        }

        Rectangle{
            id: mainbar
            anchors.rightMargin:4
            anchors.topMargin:4
            anchors.bottomMargin: mainbar.anchors.topMargin
            anchors.leftMargin: mainbar.anchors.rightMargin
            color: theme.background
            anchors.fill: parent
            //bottomLeftRadius: 30
            //bottomRightRadius: 30
            radius: 12
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
            
            // Battery
            Rectangle{
                id: containerRect
                //Layout.alignment:Qt.AlignRight
                Layout.rightMargin: 10
                radius: 20
                border.color: UPower.displayDevice.state === 1 ? theme.tertiary : (UPower.displayDevice.percentage < 0.25 ? "#f00" : theme.on_primary)
                color: "transparent"
                border.width: 1
                implicitHeight: 25
                implicitWidth: 80
                Layout.alignment: Qt.AlignVCenter
                Layout.bottomMargin:3
                
            
            Rectangle{
                id: innerFill
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                radius: 20
                border.width:0.5
                color: containerRect.border.color
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
                font.bold: containerRect.border.color != theme.on_primary ? true : false
                text: Math.round(UPower.displayDevice.percentage * 100) + "%"
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
                onClicked: menu2.open = !menu2.open
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
            //anchors.verticalCenterOffset: 1.5
            text: volumeMuted ? "Muted" : volume + "%"
        }
        }

        //systemtray
        Rectangle{
            anchors{
                right: parent.right
                rightMargin: 195
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: -0.5
            }
            color: theme.on_primary
            radius: 20
            implicitWidth: 28.5 * tray.count
            implicitHeight: 25
            Behavior on implicitWidth{
                NumberAnimation{
                    duration: 900
                    easing.type: Easing.InBounce
                }
            }
            Row{
                spacing:5
                anchors.right:parent.right
                anchors.rightMargin: 3
                Layout.alignment: Qt.AlignRight


                Repeater{
                    id: tray
                    model: SystemTray.items
                    delegate:
                        Rectangle{
                            width: height
                            height: 23
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset:1
                            color: theme.on_tertiary_fixed
                            radius: 15
                        Rectangle{
                        anchors.centerIn: parent
                        width:height
                        height: 12
                        radius:20
                        color: "transparent"
                        Image{
                            anchors.fill:parent
                            source: modelData.icon
                            fillMode: Image.PreserveAspectFit
                        }
                        MouseArea{
                            function killit(service){
                                Quickshell.execDetached(["killall",service])
                                console.log("killed",service)
                            }
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked:function(mouse) {
                                if (mouse.button === Qt.RightButton) {
                                    killit(modelData.title)
                                } else {
                                    modelData.activate()
                                }
                            }
                        }
                        }
                    }
                }
            }
        }
    }
}

