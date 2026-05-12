import Quickshell
import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import Quickshell.Wayland
import "../"

PanelWindow {
    id: root
    exclusionMode: ExclusionMode.Ignore

    // exclusiveZone: 0
    // Component.onCompleted: bar_loader.active = true
    property int radii: 20

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    color: "transparent"//theme.background
    mask: Region {
        item: effector
        intersection: Intersection.Subtract
    }
    Rectangle {
        id: back
        //z:0
        anchors.fill: parent
        color: theme.background
        visible: false
    }
    MultiEffect {
        id: effector
        anchors.fill: back
        source: back
        maskEnabled: true
        maskInverted: true
        maskSource: mashshape
    }
    MultiEffect {
        anchors.fill: region//parent
        shadowEnabled: true
        source: effector
        shadowScale: 1
        shadowBlur: 1
    }
    Item {
        id: region
        anchors.fill: back
        //layer.enabled: true
        Shape {
            //MouseArea{anchors.fill: parent}
            id: mashshape
            anchors.fill: parent
            layer.enabled: true
            visible: false
            antialiasing: true
            /*ShapePath {
                PathSvg {
                    path: root.generatedPath
               }
             }
            */
            layer.samples: 100
            clip: true
            opacity: 0.2
            ShapePath {
                id: shpth
                fillColor: "red"
                property bool open: P_data.dash_open
                property int dashwidth: 750
                property real dasheight: 530
                property real coordinatewidth: dashwidth / 2
                property real coordinateheight: open ? dasheight + 35 : 35
                property real cornerradius: open ? 20 : 0
                property real cornerradius2: open2 ? 20 : 0
                property bool open2: P_data.bat_open
                property int bat_pan_width: 300
                property int bat_pan_height: 400
                property real bat_coord_width: open2 ? coordinatewidth : 0
                Behavior on bat_coord_width {
                    NumberAnimation {
                        duration: 400
                        easing.type: Easing.OutQuad
                    }
                }
                Behavior on coordinateheight {
                    NumberAnimation {
                        duration: 400
                        easing.type: Easing.OutQuad
                    }
                }
                Behavior on cornerradius {
                    NumberAnimation {
                        duration: 400
                        easing.type: Easing.Linear
                    }
                }
                Behavior on cornerradius2 {
                    NumberAnimation {
                        duration: 400
                        easing.type: Easing.Linear
                    }
                }
                startX: 800
                startY: coordinateheight
                PathLine {
                    x: shpth.startX + shpth.coordinatewidth - shpth.cornerradius
                    y: shpth.coordinateheight
                }
                PathArc {
                    relativeX: shpth.cornerradius
                    relativeY: -shpth.cornerradius
                    radiusX: shpth.cornerradius
                    radiusY: shpth.cornerradius
                    direction: PathArc.Counterclockwise
                }
                PathLine {
                    x: shpth.startX + shpth.coordinatewidth
                    y: 35 + shpth.cornerradius
                }
                PathArc {
                    relativeX: shpth.cornerradius
                    relativeY: -shpth.cornerradius
                    radiusX: shpth.cornerradius
                    radiusY: shpth.cornerradius
                    direction: PathArc.Clockwise
                }
                PathLine {
                    x: 1575 - shpth.bat_coord_width
                    y: 35
                }
                PathArc {
                    relativeX: 20
                    relativeY: 15
                    radiusX: 20
                    radiusY: 15
                }
                PathLine {
                    x: 1595 - shpth.bat_coord_width
                    y: 35 + shpth.bat_pan_height - shpth.cornerradius2
                }
                PathArc {
                    relativeX: shpth.cornerradius2
                    relativeY: shpth.cornerradius2
                    radiusX: shpth.cornerradius2
                    radiusY: shpth.cornerradius2
                    direction: PathArc.Counterclockwise
                }
                PathLine {
                    x: 1595 - shpth.cornerradius2
                    y: 35 + shpth.bat_pan_height
                }
                PathArc {
                    relativeX: shpth.cornerradius2
                    relativeY: shpth.cornerradius2
                    radiusX: shpth.cornerradius2
                    radiusY: shpth.cornerradius2
                    direction: PathArc.Clockwise
                }
                PathLine {
                    x: 1595
                    y: 880
                }
                PathArc {
                    relativeX: -20
                    relativeY: 15
                    radiusX: 20
                    radiusY: 15
                    //direction:PathArc.Counterclockwise
                }
                PathLine {
                    x: 25
                    y: 895
                }
                PathArc {
                    relativeX: -20
                    relativeY: -15
                    radiusX: 20
                    radiusY: -15
                }
                PathLine {
                    x: 5
                    y: 50
                }
                PathArc {
                    relativeX: 20
                    relativeY: -15
                    radiusX: 20
                    radiusY: -15
                }
                PathLine {
                    x: shpth.startX - shpth.coordinatewidth - shpth.cornerradius
                    y: 35
                }
                PathArc {
                    relativeX: shpth.cornerradius
                    relativeY: shpth.cornerradius
                    radiusX: shpth.cornerradius
                    radiusY: shpth.cornerradius
                    direction: PathArc.Clockwise
                }
                PathLine {
                    x: shpth.startX - shpth.coordinatewidth
                    y: shpth.coordinateheight - shpth.cornerradius
                }
                PathArc {
                    relativeX: shpth.cornerradius
                    relativeY: shpth.cornerradius
                    radiusX: shpth.cornerradius
                    radiusY: shpth.cornerradius
                    direction: PathArc.Counterclockwise
                }
                PathLine {
                    x: 800
                    y: shpth.coordinateheight
                }
            }
        }
    }
}
