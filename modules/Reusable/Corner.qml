import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
Rectangle{
    id: root
    property int radiusx: 20
    property int radiusy:20
    property int deg: 0
    property color paint:theme.background
    rotation: deg
    Shape{
        anchors.fill: parent
        ShapePath{
            strokeColor: "white"
            strokeWidth:0
            fillColor: root.paint
            PathLine{x:0;y:root.radiusy}
            PathQuad{x:root.radiusx;y:0;controlX:-1;controlY:-2}
            PathLine{x:0;y:0}
        }
    }
    
}