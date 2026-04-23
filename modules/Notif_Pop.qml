import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import "../."

Popup{
    id: root
    property var notif
  //  parent: root
    x: parent.width - width - 20
    y: 0    
    opacity: 1


    implicitWidth: 200
    implicitHeight: 200
    Connections{
        target: P_data
        function onNew_notif(data){
            root.notif=data
            root.open()
            console.log("ewwwww")
            }
    }
    Rectangle{
        anchors.fill: parent
        color: theme.background
        Row{
            spacing: 10
            Image{
                source: root.notif ? root.notif.appIcon : ""
                width: 20
                height: 20
            }
            Column{
                Text{
                    text: root.notif ? root.notif.summary : ""
                }
                Text{
                    text: root.notif ? root.notif.body:""
                } 
            }
        }
    }
    Timer{
        id: notif_timer
        running: root.visible
        repeat: false
        interval: 2400
        onTriggered: root.close()
    }
}