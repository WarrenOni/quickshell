import QtQuick

Rectangle{
    id: pill
    property string label:""
    property color pillcolor: theme.secondary
    property real pillscale: 1.0
    property int pillwidth: 1
    property int voff: 0
    property int pillrad: height/2
    property string font_family: "ESPACION"
    property int pixelsize:  14 * pill.pillscale
    property int hoff: 0
    property bool fcus: false
    width: {
        switch(label){
            case "Bluetooth" : return 100;
            case "Wi-fi": case "Dash": return 70;
            default: return 27;
        }
    }
    height: 40 * pillscale
    radius: pillrad
    color: fcus ? pillcolor : theme.on_primary
    anchors{
        //horizontalCenter: parent.horizontalCenter
        //verticalCenter: parent.verticalCenter
        verticalCenterOffset: voff 
        horizontalCenterOffset: hoff
       // centerIn: parent
    }
    Text{   
            anchors.centerIn: parent
            text: pill.label
            font.pixelSize: pill.pixelsize
            color: "black"
            font.family: pill.font_family
        }

}