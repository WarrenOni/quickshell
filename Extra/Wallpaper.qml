import QtQuick
//import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quickshell

FloatingWindow {
    id: wall
    implicitWidth: 1750
    implicitHeight: 600
    color: "transparent"
    
    // Store the currently selected path
    //property string currentWallPath: ""
    signal toggle()
    function select_wall(path) {
        //currentWallPath = path
        wall.visible=false
        Quickshell.execDetached(["sh","-c","matugen image '" + path + "' --source-color-index 0"])
        console.log("Wallpaper And theme applied: " + path)
        toggle()
    }
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: 0
        ListView {
            id: wall_list
            anchors.fill: parent
            //width: parent.width
            //height: parent.height
            orientation: ListView.Horizontal
            spacing: 10
            clip: true
            leftMargin: 150
            rightMargin: 100
            model: FolderListModel {
                id: wallpapermodel
                folder: "file:///home/akai/Pictures/Wallpapers"
                nameFilters: ["*.png", "*.jpg", "*.webp", "*.jpeg","*.gif"]
                sortField: FolderListModel.Size
                sortReversed: true
            }
            /*
            MouseArea{
                anchors.fill: parent
                onWheel: (wheel) =>{
                    if((wheel.angleDelta.y||wheel.angleDelta.x)<0){wall_list.contentX+=30}
                    if((wheel.angleDelta.y||wheel.angleDelta.x)>0) {wall_list.contentX-=30}
                }
            }*/

            delegate: Rectangle {
                id: wall_Item
                width: hoverscale===1? 200: 600
                height: 450
                color: "transparent"
                radius: 0
                clip: true
                anchors.verticalCenter: parent.verticalCenter
                property real hoverscale: 1
                transform: Shear {
                    xFactor: -0.304
                    yFactor: 0
                }
                Behavior on width{
                    NumberAnimation{
                        duration: 400
                        easing.type: Easing.Bezier
                    }
                }

                Image {
                    anchors.fill: parent
                    anchors.margins: wall_Item.border.width
                    source: "file://" + filePath
                    fillMode: Image.PreserveAspectCrop
                    sourceSize.height: 450
                    sourceSize.width: 400
                    mipmap: true
                    cache: true
                    asynchronous: true
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: wall.select_wall(filePath)

                    onEntered: {
                        wall_Item.border.width = 2
                        wall_Item.border.color = theme.primary
                        wall_Item.hoverscale = 1.5
                    }

                    onExited: {
                        wall_Item.border.width = 0
                        wall_Item.border.color = "transparent"
                        wall_Item.hoverscale = 1
                    }
                }
            }
        }
    }
}