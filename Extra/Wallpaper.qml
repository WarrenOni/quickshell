import QtQuick
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quickshell
import "."

FloatingWindow {
    id: wall
    implicitWidth: 1750
    color: "transparent"
    height: 850
    // Store the currently selected path to use when picking a color
    property string currentWallPath: ""

    function select_wall(path) {
        currentWallPath = path
        paletteview.visible = true

        // Example: Tell matugen to set the wallpaper and generate colors
        Quickshell.execDetached(["sh","-c","~/.config/quickshell/Extra/matugen.sh '" + path + "'"])
        console.log("Wallpaper Selected: " + path)
    }
    

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: 0
        Flickable {
            anchors.fill: parent
            contentWidth : 15000
            contentHeight: parent.height
            clip: true
            RowLayout {
                id: wall_layout
                spacing:  60
                anchors.verticalCenter: parent.verticalCenter
                Repeater {
                    model: FolderListModel {
                        id: wallpapermodel
                        folder: "file:///home/akai/Pictures/Wallpapers"
                        nameFilters: ["*.png", "*.jpg"]
                    }
                    delegate: Rectangle {
                        id: wall_Item
                        width: 200
                        height: 350
                        color: "transparent"
                        radius: 0
                        clip: true

                        property real hoverscale: 1
                        transform: Shear{
                            xFactor: 0.304
                            yFactor: 0
                        }
                        scale: hoverscale
                        Behavior on hoverscale{
                            NumberAnimation{
                                duration: 400
                                easing.type: Easing.InCurve
                            }
                        }
                        Image {
                            anchors.fill: parent
                            anchors.margins: wall_Item.border.width
                            source: "file://" + filePath // FolderListModel uses fileFilePath
                            fillMode: Image.PreserveAspectCrop
                            sourceSize.height: 150
                            sourceSize.width: 50
                            cache: false
                            asynchronous: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: select_wall(filePath)
                            
                            // Visual feedback
                            onEntered:{
                                 parent.border.width = 2
                                 parent.border.color = theme.primary
                                 wall_Item.hoverscale = 1.5
                                }
                            onExited: {
                                parent.border.width = 0
                                parent.border,color = null
                                wall_Item.hoverscale = 1    
                                }
                        }
                    }
                }
            }
        }
    }

    PaletteView{
        id: paletteview
    }    
    
}