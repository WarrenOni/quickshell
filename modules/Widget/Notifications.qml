import QtQuick
import QtQuick.Controls
//import Quickshell.Services.Notifications
import "../../."

Item {
    id: root
    property int rad: 20
    property int rectHt: 50
    property int rectWdth: 300
    //onNotifChanged:console.log(notif.id)

    ListView {
        anchors.topMargin:1
        anchors.bottomMargin:1
        anchors.fill: parent
        clip: true
        model: P_data.historyModel
        spacing: 5
        delegate: Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            color: hovered ? theme.primary : theme.on_secondary_fixed_variant
            height: root.rectHt
            width: hovered ? root.rectWdth : 290
            radius: root.rad
            Behavior on width{
                NumberAnimation{
                    duration: 100
                }
            }
            Row{
                spacing: 3
                Image{
                    source: model.appIcon || ""
                    width: 20
                    height: 20
                }
                Column{
                    Text{
                        text: model.summary
                    }
                    Text{
                        text: model.id
                    }
                }
            }
            property bool hovered: false
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onHoveredChanged: hovered=!hovered
            }
        }
    }
}
