import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

Item {
    id: root
    property real radii: 120
    property real sweepangle
    property bool animation: false
    property int anim_duration: 2000
    property color clr
    property bool anim_running
    Behavior on clr {
        ColorAnimation {
            duration: 2000
            easing.type: Easing.OutQuint
        }
    }
    Canvas {
        anchors.fill: parent
        antialiasing: true
        onPaint: {
            // get context to draw with
            var ctx = getContext("2d");
            // setup the stroke
            ctx.reset();
            var centerX = width / 2;
            var centerY = height - root.radii / 2;
            var radius = root.radii;

            // Shared styling
            ctx.lineWidth = 30;
            ctx.lineCap = "round"; // This creates the rounded corners

            // 1. Background Arc (Static)
            ctx.beginPath();
            ctx.strokeStyle = theme.primary;
            // -180 degrees in radians: -Math.PI
            ctx.arc(centerX, centerY, radius, 0, -Math.PI, true);
            ctx.stroke();
        }
    }
    Item {
        id: glow
        anchors.fill: parent
        Shape {
            asynchronous: true
            anchors.fill: parent
            layer.enabled: true
            layer.samples: 7
            layer.effect: MultiEffect {
                blurEnabled: true
                blur: 0.6
                brightness: 1.5
                colorization: enabled
                colorizationColor: root.clr
            }
            ShapePath {
                strokeWidth: 30
                strokeColor: root.clr
                fillColor: "transparent"
                //startX:0;startY:0
                capStyle: ShapePath.RoundCap
                PathAngleArc {
                    centerX: Math.round(root.width / 2)
                    centerY: Math.round(root.height - root.radii / 2)
                    radiusX: root.radii
                    radiusY: root.radii
                    startAngle: -180
                    NumberAnimation on sweepAngle {
                        from: 0
                        to: root.sweepangle
                        duration: 2000
                        running: root.anim_running
                        easing.type: Easing.OutQuad
                    }
                }
            }
        }
    }
}

////////////////////

/*
Canvas {
    id: root
    // canvas size
    anchors.fill: parent
   // antialiasing:true
    // handler to override for drawing
    property int sweepAngle
    property real sweepangle
    property bool anim_running
    NumberAnimation on sweepangle{
        from:0
        to: root.sweepAngle
        duration: 2000
        running: root.anim_running
        easing.type:Easing.OutQuad
    }
    onSweepangleChanged:root.requestPaint()
    onPaint: {
        // get context to draw with
        var ctx = getContext("2d")
        // setup the stroke
        ctx.reset();
        var centerX = width / 2;
        var centerY = height / 2;
        var radius = 120;

        // Shared styling
        ctx.lineWidth = 30;
        ctx.lineCap = "round"; // This creates the rounded corners

        // 1. Background Arc (Static)
        ctx.beginPath();
        ctx.strokeStyle = theme.primary;
        // -180 degrees in radians: -Math.PI
        ctx.arc(centerX, centerY, radius, 0, -Math.PI, true);
        ctx.stroke();

        // 2. Foreground Arc (Animated)
        ctx.strokeStyle = "green";
        ctx.shadowColor = "green"; // The color of the glow
        ctx.shadowBlur = 5;        // The "size" of the glow
       // ctx.shadowOffsetX = 0;     // Keep it centered on the line
       // ctx.shadowOffsetY = 0;

        ctx.beginPath();
        ctx.strokeStyle = "green";
        var startRad = Math.PI; // 180 degrees
        var sweepRad = (root.sweepangle * Math.PI) / 180;
        ctx.arc(centerX, centerY, radius, startRad, startRad + sweepRad, false);
        ctx.stroke();
   }
}*/
