import QtQuick 
Item{
    id:root
    width: parent.width 
    height: parent.height 
    clip: true
    opacity: 0.1
    // --- Minimal Morphing Shape ---
Rectangle {
        id: morphShape
        width: 400; height: 400
        color: theme.on_surface
        opacity: 0.6
        rotation: 45
        radius: 50
        clip: true
        
        // Starting position
        x: 0; y: 0

        // 1. SHAPE MORPH (Oval to Rounded Rect)
        SequentialAnimation on rotation {
            running: true
            loops: Animation.Infinite
            NumberAnimation { from: -8; to: 50; duration: 2000; easing.type: Easing.InOutSine }
            NumberAnimation { from: 50; to: -8; duration: 1200; easing.type: Easing.InOutSine }
        }
        SequentialAnimation on radius {
            running: true
            loops: Animation.Infinite
            NumberAnimation { from: 100; to: 200; duration: 3000; easing.type: Easing.InOutSine } // Oval-ish
            NumberAnimation { to: 100;  duration: 3000; easing.type: Easing.InOutSine } // Rect-ish
        }

        // 2. SLIGHT DRIFT (Movement)
        SequentialAnimation on x {  
            running: true
            loops: Animation.Infinite
            NumberAnimation { to: -50; duration: 4500; easing.type: Easing.InOutQuad }
            NumberAnimation { to: -90; duration: 4500; easing.type: Easing.InOutQuad }
        }

        SequentialAnimation on y {
            running: true
            loops: Animation.Infinite
            NumberAnimation { to: -90; duration: 3500; easing.type: Easing.InOutQuad }
            NumberAnimation { to: -50; duration: 3500; easing.type: Easing.InOutQuad }
        }

        // 3. SUBTLE PULSE
        SequentialAnimation on scale {
            running: true
            loops: Animation.Infinite
            NumberAnimation { to: 1.1; duration: 2500; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.9; duration: 2500; easing.type: Easing.InOutSine }
        }
    }
Rectangle {
        id: morphShape1
        width: 400; height: 400
        color: theme.source_color
        opacity: 0.6
        rotation: 45
        radius: 50
        clip: true
        
        // Starting position

        x: 400; y: 300

        // 1. SHAPE MORPH (Oval to Rounded Rect)
        
        SequentialAnimation on rotation {
            running: true
            loops: Animation.Infinite
            NumberAnimation { from: -8; to: 50; duration: 2000; easing.type: Easing.InOutSine }
            NumberAnimation { from: 50; to: -8; duration: 1200; easing.type: Easing.InOutSine }
        }
        SequentialAnimation on radius {
            running: true
            loops: Animation.Infinite
            NumberAnimation { from: 100; to: 200; duration: 3000; easing.type: Easing.InOutSine } // Oval-ish
            NumberAnimation { to: 100;  duration: 3000; easing.type: Easing.InOutSine } // Rect-ish
        }

        // 2. SLIGHT DRIFT (Movement)

        SequentialAnimation on x {
            running: true
            loops: Animation.Infinite
            NumberAnimation { to: 300; duration: 4500; easing.type: Easing.InOutQuad }
            NumberAnimation { to: 400; duration: 4500; easing.type: Easing.InOutQuad }
        }

        SequentialAnimation on y {
            running: true
            loops: Animation.Infinite
            NumberAnimation { to: 350; duration: 3500; easing.type: Easing.InOutQuad }
            NumberAnimation { to: 300; duration: 3500; easing.type: Easing.InOutQuad }
        }

        // 3. SUBTLE PULSE
        SequentialAnimation on scale {
            running: true
            loops: Animation.Infinite
            NumberAnimation { to: 1.1; duration: 2500; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.9; duration: 2500; easing.type: Easing.InOutSine }
        }
    }
}
