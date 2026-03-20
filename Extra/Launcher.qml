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
    visible:true
    property var application:[]
    property var filtered:[]
    
    //function for calling the app
    function launchApp(exec){
        Quickshell.execDetached(["sh","-c",exec])
        menu_list.visible=false
        console.log("request sent for launch")
    }
    //Process for reading the file and stdout
    Process{
        id: proc
        running: true
        command:["sh","-c","~/.config/quickshell/Extra/laucher.sh"]
        stdout: StdioCollector{
            onTextChanged: {
                try {
                    menu_list.application = JSON.parse(text.trim())
                    //console.log(menu_list.application)
                } catch(e) {
                    console.log("!!application passing error!!",e)
                }
            }
        }
    }   
    ColumnLayout{
        anchors.fill:parent
        spacing:5
        TextField{
            id: search
            background: Rectangle{
                implicitWidth: menu_list.width
                radius: 10
                border.width: 10
                
                border.color: "transparent"
                color: theme.on_primary_fixed
            }            
            font.pixelSize: 20
            color:"white"
            font.family: "ESPACION"
            placeholderText: "Lauch.."
            onTextChanged:{
                menu_list.filtered = menu_list.application.filter(a=>a.name.toLowerCase().includes(search.text.toLowerCase()))
            }
        }
        Rectangle{
        width: parent.width
        height: parent.height-search.height
        border.width:10
        border.color: theme.background
        color: "transparent"
        radius: 20
        ListView{
            spacing: 4
            width: parent.width
            height: parent.height-20
            anchors.fill: parent
            clip: true
            model: search.text ? menu_list.filtered : menu_list.application
            delegate: Rectangle{
                id: del
                radius: 10
                width: parent.width - 5
                anchors.horizontalCenter: parent.horizontalCenter
                height: 30
                property bool hovered: false
                color: hovered ? theme.primary : "transparent"
                MouseArea{
                    hoverEnabled: true
                    anchors.fill: parent
                    onHoveredChanged: del.hovered = !del.hovered
                    onClicked: menu_list.launchApp(modelData.exec)
                }
                Text{
                    font.family: "ESPACION"
                    font.pixelSize: 18
                    anchors.verticalCenter:parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 5 
                    text: modelData.name
                    color: "White"
                }
            }
        }
    }
    }
}