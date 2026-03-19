import QtQuick
import Quickshell.Io
import Quickshell
import Qt.labs.platform
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
    property var application:({})
    property var filtered:({})
    
    //function for calling the app
    function launchApp(exec){
        Quickshell.execDetached(["sh","-c",exec])
        menu_list.visible=false
        console.log("request sent for launch")
    }
    //Process for reading the file and stdout
    Process{
        running: true
        command:["sh","-c","~/.config/quickshell/Extra/laucher.sh"]
        stdout: StdioCollector{
            onTextChanged: {
                try {
                    menu_list.application = JSON.parse(text.trim())
                    console.log(menu_list.application)
                } catch(e) {
                    console.log("!!application passing error!!",e)
                }
            }
        }
    }

    ColumnLayout{
        anchors.fill: parent
        ListView{
            id: lst
            anchors.fill: parent
            clip: true
            model: menu_list.application.name ? menu_list.application.name: []
            delegate: Rectangle{
                height: 10
                color: hovered ? theme.primary : "transparent"
                property bool hovered: false
                Text{
                    text:modelData.name
                    color: "white"
                }
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.hovered = true
                    onExited: parent.hovered = false
                    onClicked:{
                        menu_list.visible = false
                        launchApp(modelData.exec)
                    }
                }
            }
        }
    }
}