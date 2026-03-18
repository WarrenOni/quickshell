import QtQuick
import Quickshell.Io
import Quickshell
import Qt.labs.folderlistmodel
import QtQuick.Layouts
import QtQuick.Controls

FloatingWindow{
    id: menu_list
    width: 600
    height: 300
    color: theme.background
    onVisibleChanged: {
    if (menu_list.visible) {search.forceActiveFocus()}
    }
    property var application:[]
    
    property var filtered:[]

    function launchApp(exec){
        Quickshell.execDetached(["sh","-c",exec])
        menu_list.visible=false
        console.log("request sent for launch")
    }

    ColumnLayout{
        anchors.fill: parent
        TextField{
            id: search
            placeholderText: "Launch : "
            onTextChanged:{
                filtered = application.filter(a=>a.name.toLowerCase().includes(text.toLowerCase()))
            }
        }
        ListView{
            model: filtered
            delegate: Rectangle{
                width: parent.width
                height: 9
                color: hovered ? theme.primary : "transparent"
                property bool hovered: false

                Text{
                    text:modelData.name
                    color: theme.scrim
                }
                MouseArea{
                    onEntered: parent.hovered = true
                    onExited: parent.hovered = false
                    onClicked:{
                        Qt.callLater(() => {menu_list.visible = false})
                        launchApp(modelData.exec)
                    }
                }
            }
        }
    }
}