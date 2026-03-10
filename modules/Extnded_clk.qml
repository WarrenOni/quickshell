
import Quickshell
import QtQuick
import Quickshell.Io
//import QtQuick.Shapes

PopupWindow {
    id: menu

    // ✅ ADDED: property so QML can bind the value
    property string activename: ""

    Process{
        id: get_connection_name
        running: true

        command: ["bash","-c","nmcli -g NAME connection show --active | head -n 1"]

        stdout: StdioCollector{
            // ✅ CHANGED: safer way to read output
            onTextChanged: {
                activename = text.trim()
                console.log("found:", activename)
            }
        }
    }

    property var bar
    property bool open : false

    visible: open || panel.height > 0
    color: "transparent"

    implicitWidth: 720
    implicitHeight: 500

    // position under bar
    anchor.window: bar
    anchor.rect.x: bar.width / 2 - implicitWidth / 2
    anchor.rect.y: bar.height

    Rectangle {
        id: panel
        width: parent.width
        height: open ? parent.height : 0
        clip: true
        color:  theme.background
        radius: 20

        Behavior on height {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutCirc
            }
        }

        Rectangle{
            id: network
            width: 150
            height: 50
            radius: 50
            color: theme.primary

            anchors{
                left: parent.left
                top: parent.top
                leftMargin: 20
                topMargin: 20
            }

            Text{
                id: connection_text
                color: "black"

                text:"󰖩 " + "  |" + "  "+ activename

                font.family: "Pixelon"
                font.pixelSize: 18
                anchors.centerIn: parent

                MouseArea{
                    onClicked: get_connection_name.running = true
                }
            }
        }
    }
}