import QtQuick
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quickshell

FloatingWindow {
    id: wall
    width: 1200
    height: 400
    visible: true

    // Store the currently selected path to use when picking a color
    property string currentWallPath: ""

    function select_wall(path) {
        currentWallPath = path;
        // Example: Tell matugen to set the wallpaper and generate colors
        Quickshell.execDetached(["matugen", "image", path]);
        console.log("Wallpaper applied: " + path);
    }

    function apply_color(mode) {
        // Example: Manually forcing a light/dark mode switch after selection
        Quickshell.execDetached(["matugen", "image", currentWallPath, "-m", mode]);
    }

    Rectangle {
        anchors.fill: parent
        color: "#111111"

        Flickable {
            anchors.fill: parent
            contentWidth: 200 // Tells Flickable how wide the content is
            contentHeight: 400
            clip: true

            Row {
                spacing: 5
                anchors.verticalCenter: parent.verticalCenter

                Repeater {
                    model: FolderListModel {
                        folder: "file:///home/akai/Pictures/Wallpapers"
                        nameFilters: ["*.png", "*.jpg"]
                    }

                    delegate: Rectangle {
                        width: 200
                        height: 400
                        color: "transparent"
                        radius: 0
                        clip: true

                        Image {
                            anchors.fill: parent
                            source: "file://" + filePath // FolderListModel uses fileFilePath
                            fillMode: Image.PreserveAspectCrop
                            sourceSize.height: 200
                            sourceSize.width: 300
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: select_wall(filePath)
                            
                            // Visual feedback
                            onEntered: parent.border.width = 2
                            onExited: parent.border.width = 0
                        }
                    }
                }
            }
        }
    }
}