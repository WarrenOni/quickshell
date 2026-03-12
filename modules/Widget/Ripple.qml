import QtQuick

Item{
    id: root
    property int size: 100
    property bool running: false
    property int circleSize: 190


    anchors.centerIn:parent

    width: running ? parent.height : 0
    height: running ? parent.width : 0

    onRunningChanged: {
        if (!running) {
            raddii.width = circleSize
            raddii.opacity = 1
        }
    }

    Rectangle{
        id: raddii
        width: root.circleSize
        height: width
        radius: width/2
        color: theme.on_tertiary
        opacity: 1
        anchors.centerIn:parent
        
        ParallelAnimation{
            running: root.running
            loops: Animation.Infinite
            

            NumberAnimation{
                target: raddii
                property: "width"
                to: 490
                duration: 1200
            }
            NumberAnimation{
                target: raddii
                property: "opacity"
                to: 0
                duration: 1200
            }
            }
}
}