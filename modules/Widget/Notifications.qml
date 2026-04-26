import QtQuick
//import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
//import Qt5Compat.GraphicalEffects
//import Quickshell.Services.Notifications
import "../../."

Item {
    id: root
    property int rad: 20
    property int rectHt: 70
    property int rectWdth: 293
    //onNotifChanged:console.log(notif.id)
    ListView {
        id: notif_list
        anchors.topMargin:2
        anchors.bottomMargin:2
        anchors.fill: parent
        clip: true
        model: P_data.historyModel
        spacing: 5
        delegate: Rectangle {
            id: del_rect
            clip: true
            anchors.horizontalCenter: parent.horizontalCenter
            color: hovered ? theme.primary : theme.on_secondary_fixed_variant
            height: clicked && model.body.length>40 ? body_text.contentHeight+summary_text.contentHeight+30  : root.rectHt
            width: hovered ? root.rectWdth : 290
            border.color: model.imp==="Critical" ? "red" : theme.on_primary_fixed_varient
            border.width: 1
            radius: root.rad
            Behavior on width{
                NumberAnimation{
                    duration: 100
                }
            }
           
            Behavior on height{NumberAnimation{duration:200}}
            RowLayout{
                anchors.leftMargin: 10
                anchors.fill: parent
                spacing:10
                Image {
                    id: sourceImage
                    source: model.image || ""
                    visible: false
                    anchors.verticalCenter:  parent.verticalCenter
                    width: 50
                    height: 50
                    mipmap: true
                }
                MultiEffect{
                    source: sourceImage
                    anchors.fill: sourceImage
                    maskEnabled: true
                    visible: model.image != ""
                    maskSource: mask
                }
                Rectangle {
                    id: mask
                    anchors.centerIn: sourceImage
                    layer.enabled: true
                    visible: false
                    width: sourceImage.width
                    height: sourceImage.height
                    radius: 20
                    color: "black"
                }
                Column{
                    Row{
                    Text{text:model.app;font.pixelSize:11}
                    }
                     Text{
                        id: summary_text
                        text: model.summary
                        width: 200
                        elide: Text.ElideRight
                        font.pixelSize: 14
                        font.bold: true
                    }
                    Text{
                        id: body_text
                        width: model.image != "" ? del_rect.width-75: del_rect.width-20
                        maximumLineCount: !del_rect.clicked?1:20
                        wrapMode: Text.Wrap
                        elide: Text.ElideRight
                        text: model.body
                    }
                }
            }
            property bool hovered: false
            property bool clicked: false
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onHoveredChanged: del_rect.hovered=!del_rect.hovered
                onClicked: del_rect.clicked=!del_rect.clicked
            }
        }
    }
}
