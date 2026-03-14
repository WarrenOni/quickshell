import QtQuick

Rectangle{
    id: pill
    property string label:""
    property string icon: ""
    property color pillcolor: theme.secondary
    property real pillscale: 1.0
    property real pillwidth: 1
    property int voff: 0
    property int hoff: 0
    property bool fcus: false
    
    width: 69 * pillwidth
    height: 40 * pillscale
    radius: height / 2
    color: fcus ? pillcolor : theme.on_primary
    anchors{
        horizontalCenter: parent.horizontalCenter
        verticalCenter: parent.verticalCenter
        verticalCenterOffset: voff 
        horizontalCenterOffset: hoff
       // centerIn: parent
    }
    Row{
        anchors.centerIn: parent
        spacing: 3
        Text{
            text: pill.icon
            font.pixelSize: 16 * pill.pillscale
        }
        Text{
            text: pill.label
            font.pixelSize: 14 * pill.pillscale
            color: "black"
            font.family: "ESPACION"
        }
    }
    MouseArea{
        anchors.fill: parent
        onClicked: console.log("clicked")
    }
}