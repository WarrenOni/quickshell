import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
PanelWindow{
    id: root 
    visible: true
    color:"transparent"
    anchors{
        top:true
        right: true
        left: true
    }
    implicitHeight: 40
}

//-----------panel out

/*
Item{
            id:intersect
            anchors.fill: parent
        Item {
                id: bezel
                anchors.fill: parent
                layer.enabled: true
                // Drop Shadow
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: "#B0000000"
                    shadowVerticalOffset: 10
                    shadowHorizontalOffset: 10

                    blurMax: 2
                    shadowBlur: 0
                    }

                Rectangle {
                    anchors.fill: parent
                    layer.enabled: true
                  //  visible: true
                    // Rectangle Cutout
                    layer.effect: MultiEffect {
                        maskSource: maskShapeSource
                        maskEnabled: true
                        maskInverted: true
                        maskThresholdMin: 0.5
                        maskSpreadAtMin: 1
                    }
                }
                
                // Mask Cutout Sape
                Item {
                    id: maskShapeSource
                    anchors.fill: parent
                    layer.enabled: true
                    visible: false
                    Shape{
                        MouseArea{anchors.fill: parent}
                        ShapePath{
                            id:shpth
                            fillColor:"red"
                            
                            property bool open: menu2.open
                            startX:800;startY:open?110:35
                            PathLine{x:1050;y:shpth.open?110:35}
                            PathLine{x:1050;y:35}
                            PathLine{x:1570;y:35}
                            PathArc{
                                relativeX: 20
                                relativeY: 15
                                radiusX: 20
                                radiusY: 15
                            }
                            PathLine{x:1590;y:870}
                            PathArc{
                                relativeX: -20
                                relativeY: 15
                                radiusX:20
                                radiusY:15
                                //direction:PathArc.Counterclockwise
                            }
                            PathLine{x:30;y:885}
                            PathArc{
                                relativeX: -20
                                relativeY: -15
                                radiusX:20
                                radiusY:-15
                            }
                            PathLine{x:10;y:50}
                            PathArc{
                                relativeX: 20
                                relativeY: -15
                                radiusX:20
                                radiusY:-15
                            }
                            PathLine{x:550;y:35}
                            PathLine{x:550;y:shpth.open?110:35}
                            PathLine{x:800;y:shpth.open?110:35}
                        }
                    }
                }
            }
        }
        
*/