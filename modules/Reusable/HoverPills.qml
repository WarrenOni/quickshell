import QtQuick
import QtQuick.Effects
Item{
    id: root
    property string icon
    property int iconsize
    property var text
    property int textsize
    property int radius: 20
    property string font
    property int padding: 5
    property bool hovered: false
   // RectangularShadow{anchors.fill:parent;spread:0}
    Rectangle {
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onHoveredChanged:{root.hovered=!root.hovered}
            }
            width: root.width
            radius: root.radius
            height: parent.height
            color: theme.primary
            
            Row{
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                leftPadding: root.padding
                spacing:5
                Text{
                    color: "black"
                    text: root.icon
                    font.pixelSize: root.iconsize
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    width: 100
                    elide: Text.ElideRight
                    visible: opacity != 0
                    opacity: root.hovered ? 1 : 0
                    Behavior on opacity{NumberAnimation{duration:150;easing.type:Easing.Bezier}}
                    color: "black"
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: root.textsize// 12
                    font.italic: true
                    font.family: root.font//"Pixelon"
                    text: root.text //volumeMuted ? "Muted" : volume + "%"
                }
            }
        }
}