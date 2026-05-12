import QtQuick
Item{
    id: root
    property string icon
    property int iconsize
    property var text
    property int textsize
    property string font
    property bool hovered: false
    Rectangle {
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onHoveredChanged:{root.hovered=!root.hovered}
            }
            width: root.width
            radius: 20
            height: parent.height
            color: theme.primary
            Row{
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                leftPadding: 5
                spacing:5
                Text{
                    color: "black"
                    text: root.icon
                    font.pixelSize: root.iconsize
                }
                Text {
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