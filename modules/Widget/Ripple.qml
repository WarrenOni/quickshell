import QtQuick

Item{
    id: root
    property int size: 100
    property bool running: false

    
    anchors.centerIn:parent

    width: running ? parent.height : 0
    height: running ? parent.width : 0

    onRunningChanged: {
        if (!running) {
            raddii.scale = 1
            raddii.opacity = 1
        }
    }

    Rectangle{
        id: raddii
        width: 190
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
                property: "scale"
                to: 4
                duration: 3000
            }
            NumberAnimation{
                target: raddii
                property: "opacity"
                to: 0
                duration: 3000
                easing.type: Easing.OutCirc
            }
            }

}
}