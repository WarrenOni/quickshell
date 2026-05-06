import Quickshell
import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import Quickshell.Wayland
import "../"
PanelWindow{
    exclusionMode: ExclusionMode.Ignore
    //WlrLayershell.layer: WlrLayer.Bottom
    anchors{top:true;bottom:true;left:true;right:true}
    color: "transparent"//theme.background
    mask: Region{
        item: effector
        intersection: Intersection.Subtract
    }
    Rectangle{
        id: back
        //z:0
        anchors.fill: parent
        color:theme.background
        visible: false
    }
    MultiEffect{
        id: effector
        anchors.fill: back
        source: back
        maskEnabled: true
        maskInverted: true
        maskSource: mashshape
        opacity: 1.0
    }

    Item{
        id: region
        anchors.fill: back
        //layer.enabled: true
         Shape{
                    //MouseArea{anchors.fill: parent}
                    id: mashshape
                    anchors.fill: parent
                    layer.enabled: true
                    visible: false
                    clip:true
                   // opacity: 0.2
                    ShapePath{
                        id:shpth
                        fillColor:"red"
                        property bool open: P_data.dash_open
                        property int dashwidth: 750
                        property real dasheight: 530
                        property int coordinatewidth: dashwidth/2
                        property real coordinateheight: open ? dasheight+35: 35
                        property real cornerradius: open ? 9.2 : 0
                        Behavior on coordinateheight{NumberAnimation{duration:500;easing.type:Easing.OutQuint}}
                        Behavior on cornerradius{NumberAnimation{duration:400;easing.type:Easing.Linear}}

                        startX:800;startY:coordinateheight
                        PathLine{x:shpth.startX+shpth.coordinatewidth-shpth.cornerradius;y:shpth.coordinateheight}
                        PathArc{relativeX:shpth.cornerradius;relativeY:-shpth.cornerradius;radiusX:shpth.cornerradius;radiusY:shpth.cornerradius;direction:PathArc.Counterclockwise}
                        PathLine{x:shpth.startX+shpth.coordinatewidth;y:35+shpth.cornerradius}
                        PathArc{relativeX:shpth.cornerradius;relativeY:-shpth.cornerradius;radiusX:shpth.cornerradius;radiusY:shpth.cornerradius;direction:PathArc.Clockwise}
                        PathLine{x:1575;y:35}
                        PathArc{
                            relativeX: 20
                            relativeY: 15
                            radiusX: 20
                            radiusY: 15
                        }
                        PathLine{x:1595;y:880}
                        PathArc{
                            relativeX: -20
                            relativeY: 15
                            radiusX:20
                            radiusY:15
                            //direction:PathArc.Counterclockwise
                        }
                        PathLine{x:25;y:895}
                        PathArc{
                            relativeX: -20
                            relativeY: -15
                            radiusX:20
                            radiusY:-15
                        }
                        PathLine{x:5;y:50}
                        PathArc{
                            relativeX: 20
                            relativeY: -15
                            radiusX:20
                            radiusY:-15
                        }
                        PathLine{x:shpth.startX-shpth.coordinatewidth-shpth.cornerradius;y:35}
                        PathArc{relativeX:shpth.cornerradius;relativeY:shpth.cornerradius;radiusX:shpth.cornerradius;radiusY:shpth.cornerradius;direction:PathArc.Clockwise}
                        PathLine{x:shpth.startX-shpth.coordinatewidth;y:shpth.coordinateheight-shpth.cornerradius}
                        PathArc{relativeX:shpth.cornerradius;relativeY:shpth.cornerradius;radiusX:shpth.cornerradius;radiusY:shpth.cornerradius;direction:PathArc.Counterclockwise}
                        PathLine{x:800;y:shpth.coordinateheight}
                    }
                }
        
    }
}