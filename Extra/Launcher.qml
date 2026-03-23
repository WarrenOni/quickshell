import QtQuick
import Quickshell.Io
import Quickshell
import Qt.labs.platform
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.UPower
import Quickshell.Services.SystemTray

FloatingWindow{
    id: menu_list
    implicitWidth: 600
    implicitHeight: 300
    color: "transparent"
    visible:true

    property var application:[]
    property var filtered:[]
    
    //function for calling the app
    function launchApp(exec){
        Quickshell.execDetached(["sh","-c",exec])
        menu_list.visible=false
        console.log("request sent for launch",UPower.displayDevice.state)
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
                    //console.log()
                } catch(e) {
                    console.log("!!application passing error!!",e)
                }
            }
        }
    }   

    Rectangle{
        width: parent.width 
        height: parent.height 
        color: theme.background
        radius: 20
    ColumnLayout{
        id: layout
        anchors.fill:parent
        spacing:5
        anchors.margins: 10
        TextField{
            id: search
            focus: true
            background: Rectangle{
                id: search_box
                implicitWidth: menu_list.width - layout.anchors.margins*2
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
            Keys.onReturnPressed:{
                let dat = search.text? menu_list.filtered: menu_list.application;
                if(dat.length > 0){
                    menu_list.launchApp(dat[0].exec)
                }
            }
        }
        Rectangle{
        Layout.fillHeight: true
        Layout.fillWidth: true
        color: "transparent"
        radius: 20
        ListView{
            id: items
            spacing: 4
            width: parent.width
            height: parent.height
            clip: true
            focus: true
            model: search.text ? menu_list.filtered : menu_list.application
            delegate: Rectangle{
                id: del
                radius: 10
                width: parent.width
                anchors.horizontalCenter: menu_list.horizontalCenter
                height: 35
                property bool hovered: false
                color: hovered ? theme.primary : "transparent"
            
                MouseArea{
                    hoverEnabled: true
                    anchors.fill: parent
                    onHoveredChanged: {
                        del.hovered = !del.hovered
                        
                    }
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
}