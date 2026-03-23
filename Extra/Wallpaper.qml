import QtQuick
//import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quickshell

FloatingWindow {
    id: wall
    implicitWidth: 1750
    height: 600
    color: "transparent"
    
    // Store the currently selected path
    property string currentWallPath: ""

    function select_wall(path) {
        currentWallPath = path
        wall.visible = false
        Quickshell.execDetached(["sh","-c","matugen image '" + path + "' --source-color-index 0"])
        console.log("Wallpaper And theme applied: " + path)
    }
    
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: 0
        
        ListView {
            id: wall_list
            anchors.fill: parent
            orientation: ListView.Horizontal
            spacing: 60
            clip: true
            model: FolderListModel {
                id: wallpapermodel
                folder: "file:///home/akai/Pictures/Wallpapers"
                nameFilters: ["*.png", "*.jpg", "*.webp", "*.jpeg"]
                sortField: FolderListModel.Name
                sortReversed: false
            }

            delegate: Rectangle {
                id: wall_Item
                width: 200
                height: 350
                color: "transparent"
                radius: 0
                clip: true
                anchors.verticalCenter: parent.verticalCenter
                property real hoverscale: 1

                transform: Shear {
                    xFactor: -0.304
                    yFactor: 0
                }

                scale: hoverscale

                Behavior on hoverscale {
                    NumberAnimation {
                        duration: 400
                        easing.type: Easing.InCurve
                    }
                }

                Image {
                    anchors.fill: parent
                    anchors.margins: wall_Item.border.width
                    source: "file://" + filePath
                    fillMode: Image.PreserveAspectCrop
                    sourceSize.height: 250
                    mipmap: true
                    cache: false
                    asynchronous: true
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: select_wall(filePath)

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