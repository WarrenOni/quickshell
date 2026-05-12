import QtQuick
//import Quickshell
import Quickshell.Io
//import Quickshell.Services.UPower
import QtQuick.Effects
import "../../"

Rectangle {
    id: root
    z: 0
    property int rwidth
    property int rheight
    property int spacing
    property string currentElement
    property var content: ["Power Saver", "Balanced", "Performance"]
    property int currentindex
    signal recalc
    width: rwidth
    color: theme.primary
    height: rheight
    Process {
        id: commandset
    }
    function set(item) {
        if (item === 0) {
            console.log("power-saver set");
            commandset.command = ["powerprofilesctl", "set", "power-saver"];
        }
        if (item === 1) {
            console.log("balanced set");
            commandset.command = ["powerprofilesctl", "set", "balanced"];
        }
        if (item === 2) {
            console.log("performance set");
            commandset.command = ["powerprofilesctl", "set", "performance"];
        }
    }
    Rectangle {
        id: hoverer
        z: 1
        anchors.verticalCenter: root.verticalCenter
        width: root.currentElement.length * 8 + 20
        color: P_data.power_color
        radius: root.radius
        height: root.rheight - 6
        x: {
            if (root.currentElement === "balanced")
                return 120;
            if (root.currentElement === "power-saver")
                return 3;
            if (root.currentElement === "performance")
                return 217;
        }
        Behavior on x {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutQuad
            }
        }
        Behavior on width {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutQuad
            }
        }
        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }
        /*  DragHandler{
            target: parent
            xAxis.enabled: true
            yAxis.enabled: false
            margin: 10
            xAxis.maximum: root.width-parent.width
            xAxis.minimum: 3
        }*/
    }
    RectangularShadow {
        anchors.fill: hoverer
        radius: hoverer.radius
        spread: 1
        visible: true
        color: hoverer.color
        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }
    }
    Row {
        anchors.centerIn: parent
        spacing: 29
        z: 2
        Repeater {
            id: repeater
            model: root.content
            delegate: Text {
                id: deltxt
                text: modelData
                font.bold: true
                font.family: "Espacion"
                font.pixelSize: 14
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.debug(root.currentElement);
                        set(index);
                        commandset.running = true;
                        root.recalc();
                    }
                }
            }
        }
    }
}
