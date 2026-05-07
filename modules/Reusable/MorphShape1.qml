import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
Item{
    id:root
    property real radii: 60
    property real sweepangle
    Shape{
        id:shape
        anchors.fill: parent
        ShapePath{
            strokeColor: theme.primary
            fillColor: "transparent"
            strokeWidth: 30
            PathAngleArc{
                centerX: 0
                centerY:0
                radiusX: 100
                radiusY:100
                startAngle:180
                sweepAngle:180
            }
        }
        ShapePath{
            id:fill
            strokeWidth: 30.5
            strokeColor: "green"
            fillColor:"transparent"
            PathAngleArc{
                centerX: 0
                centerY:0
                radiusX: 100
                radiusY:100
                startAngle:180
                sweepAngle:root.sweepangle
            }
        }
    }
}