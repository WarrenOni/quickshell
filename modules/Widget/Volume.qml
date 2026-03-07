import QtQuick
import QuickShell 

Item{
    id: volumeDisplay
    property var shell
    property int volume: 0
    property bool volumeMuted: false

    readonly property int iconSize: 22
    readonly property int pillHeight: 22
    readonly property int pillPaddingHorizontal: 14
    readonly property int pillOverlap: iconSize /2 

    property int maxPillWidth: 0
    property bool showPercentage: false


    width: Math.max(iconSize, showPercentage ? iconSize + maxPillWidth - pillOverlap : iconSize)
    height: pillHeight

    onVolumeChanged:{

        if (!showPercentage){

            showPercentage = true
            showHideAnimation.start()
            }
        else{ showHideAnimation.restart() }

    Component.onComplete:{
        maxPillWidth = percentageText.implicitHeight+implicitWidth + pillPaddingHorizontal *2 + pillOverlap
        percentageCondaner.width = 0
    }
    }
}