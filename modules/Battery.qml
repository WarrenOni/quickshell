import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import qs.modules.Reusable
//import Quickshell.Services.UPower
import "../"
import "./Reusable/"

PanelWindow {
    id: root
    implicitHeight: 410
    implicitWidth: 390
    // property int bar_width
    // property int bar_height
    property var bar_window
    property real sweepangle: P_data.power.displayDevice.percentage * 100
    property color textcolor: "white"
    visible: true
    signal toggle
    color: "transparent"
    anchors.top: true
    anchors.right: true
    function restart() {
        proc.running = false;
        proc.running = true;
        semicirc.anim_running = false;
        semicirc.anim_running = true;
    }
    Process {
        id: proc
        command: ["./.config/quickshell/Extra/batinfo.sh"]
        stdout: StdioCollector {
            onDataChanged: data => P_data.batinfo = JSON.parse(text.trim())
        }
        onRunningChanged: {
            if (P_data.batinfo.Current_Profile === "balanced")
                P_data.power_color = "#0055ff";
            if (P_data.batinfo.Current_Profile === "power-saver")
                P_data.power_color = "#00ff33";
            if (P_data.batinfo.Current_Profile === "performance")
                P_data.power_color = "#ff0000";
        }
    }
    // Loader{anchors.right:mainmenu.left;sourceComponent:Corners{rotation:90} active:!P_data.wrapperlayout}
    // Loader{anchors.top:mainmenu.bottom;anchors.right:mainmenu.right;sourceComponent:Corners{visible:true;rotation:90}active:!P_data.wrapperlayout}
    Timer {
        id: proc_timer
        running: P_data.bat_open
        onTriggered: {
            proc.running = false;
            proc.running = true;
        }
        repeat: true
        interval: 3000
    }
    Component.onCompleted: {
        proc.running = true;
        semicirc.anim_running = true;
        P_data.dash_open = false;
    }
    Item {
        id: mainmenu
        ///color: P_data.wrapperlayout ? "transparent" : theme.background
        //bottomLeftRadius: 20
        width: parent.width
        height: parent.height
        x: P_data.bat_open ? 0 : 405
        Behavior on x {
            NumberAnimation {
                duration: 600
                easing.type: Easing.OutExpo
                onRunningChanged: if (!P_data.bat_open && mainmenu.x === 405) {
                    toggle();
                }
            }
        }

        Column {
            anchors.fill: parent
            spacing: 10
            Item {
                width: parent.width
                height: 220
                MorphShape1 {
                    id: semicirc
                    sweepangle: root.sweepangle * 1.8
                    anim_running: P_data.bat_open
                    anchors.fill: parent
                    clr: P_data.power_color
                    // animation: true
                }
                Text {
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -10
                    anchors.horizontalCenterOffset: -5
                    font.pixelSize: 35
                    color: root.textcolor
                    text: {
                        if (root.sweepangle <= 25)
                            return "\uf244";
                        else if (root.sweepangle <= 50)
                            return "\uf243";
                        else if (root.sweepangle < 70)
                            return "\uf242";
                        else if (root.sweepangle < 80)
                            return "\uf241";
                        else if (root.sweepangle >= 80)
                            return "\uf240";
                    }
                }
                Text {
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 40
                    font.pixelSize: 25
                    font.bold: true
                    property int sweepangle: root.sweepangle
                    color: root.textcolor
                    font.family: "Espacion"
                    text: sweepangle + "%" + "\nBAT"
                }
            }
            Row {
                leftPadding: 30
                spacing: 80
                topPadding: -20
                PillRect {
                    first_text: P_data.batinfo.Cap
                    second_text: "Capacity"
                    width: 120
                    height: 60
                    radius: 20
                }
                PillRect {
                    first_text: P_data.batinfo.Time
                    second_text: "Time Left"
                    width: 120
                    height: 60
                    radius: 20
                }
            }
            PowerProfileSelect {
                anchors.horizontalCenter: parent.horizontalCenter
                rwidth: root.width - 50
                rheight: 45
                currentElement: P_data.batinfo ? P_data.batinfo.Current_Profile : "Balanced"
                radius: 10
                onRecalc: root.restart()
            }
        }
    }
}
