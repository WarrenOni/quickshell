import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import "../."

PopupWindow{
    id: root
    property var notif
    property int bar_height
    property int bar_width
    property var bar_window
    implicitWidth: 350
    color: "transparent"
    implicitHeight: 100
    anchor.rect.x: bar_width
    anchor.rect.y: bar_height
    anchor.window: bar_window
    Connections{
        target: P_data
        function onNew_notif(data){
            root.notif=data
            root.visible=true
            console.log("ewwwww")
            }
    }
    property bool hovered: false
    onHoveredChanged:console.debug("hovered_on_notification")
    Rectangle{
        anchors.fill: parent
        color: theme.background
        radius:10
        MouseArea{
            anchors.fill: parent
            hoverEnabled:true
            onHoveredChanged: root.hovered=!root.hovered
        }
        Row{
            anchors.left: parent.left
            anchors.leftMargin:10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10
            Image{           
                anchors.verticalCenter: parent.verticalCenter
                source: root.notif.image
                visible: root.notif.image != ""
                width: 60
                height: 60
                mipmap: true
            }
            Column{
                Text{
                    text: root.notif ? root.notif.summary : ""; color: "white"; font.bold: true;font.pixelSize:15
                }
                Text{
                    text: root.notif ? root.notif.body:"";
                    color:"white"
                    width: root.notif.image ? root.width-80 : root.width-25
                    maximumLineCount:3
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                } 
            }
        }
    }
    Timer{
        id: notif_timer
        running: root.visible&&!root.hovered
        repeat: false
        interval: 3000
        onTriggered: root.visible=false
    }
}