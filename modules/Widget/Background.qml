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
        width: 300; height: 300
        color: theme.on_surface
        opacity: 0.6
        rotation: 45
        radius: 50
        clip: true
        
        // Starting position
        x: -10; y: 100

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
            NumberAnimation { to: 120; duration: 4500; easing.type: Easing.InOutQuad }
            NumberAnimation { to: -20; duration: 4500; easing.type: Easing.InOutQuad }
        }

        SequentialAnimation on y {
            running: true
            loops: Animation.Infinite
            NumberAnimation { to: 40; duration: 3500; easing.type: Easing.InOutQuad }
            NumberAnimation { to: morphShape.y; duration: 3500; easing.type: Easing.InOutQuad }
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
        width: 300; height: 300
        color: theme.source_color
        opacity: 0.6
        rotation: 45
        radius: 50
        clip: true
        
        // Starting position

        x: 400; y: 100

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
            NumberAnimation { to: morphShape1.y; duration: 3500; easing.type: Easing.InOutQuad }
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
