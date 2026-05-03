import QtQuick
import Quickshell.Io
import Quickshell
import Quickshell.Widgets
//import Qt.labs.platform
import QtQuick.Layouts
import QtQuick.Controls
FloatingWindow{
    id: menu_list
    implicitWidth: 600
    implicitHeight: 340 //menu_list_layout.implicitHeight//300
    color: "transparent"

    property var application:[]
    property var filtered:[]
    //property int dyn_ht: 55+ menu_list.filtered.length*40

    signal toggle()
    
    //onFilteredChanged:{console.log(filtered.length)}

    //Process for reading the file and stdout
    Process{
        id: proc
        running: true
        command:["sh","-c","~/.config/quickshell/Extra/laucher.sh"]
        stdout: StdioCollector{
            onTextChanged: {
                    menu_list.application = JSON.parse(text.trim())
                    console.log("dry run")
            }
        }
    }  
    
    //function for calling the app
    function launchApp(exec){
        Quickshell.execDetached(["sh","-c",exec])
        console.log("request sent for launch")
        toggle()
    }


    Rectangle{
        id:menu_list_layout
        width: parent.width 
        height: 55 + Math.min(280,menu_list.filtered.length*45)
        color: theme.background
        radius: 20
        Behavior on height{
            NumberAnimation{duration:200;easing.type:Easing.Bezier}
        }

    ColumnLayout{
        id: layout
        anchors.fill:menu_list_layout
        spacing:10
        anchors.margins: 10
        TextField{
            id: search
            focus: true
            background: Rectangle{
                id: search_box
                implicitWidth: menu_list.width - layout.anchors.margins*2
                radius: 10
                border.width: 10
                height: 35
                border.color: "transparent"
                color: theme.on_primary_fixed
            }            
            font.pixelSize: 20
            color:theme.on_surface
            font.italic: true
            font.bold: true
            font.family: "ESPACION"
            placeholderText: "Search.."
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
                    onEntered: del.hovered = true
                    onExited: del.hovered = false
                    onClicked: menu_list.launchApp(modelData.exec)
                }
                Row{
                    anchors.verticalCenter:parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 5 
                    spacing: 5
                /*IconImage{
                    visible: true
                    asynchronous: true
                    mipmap: true
                    source: "file:///usr/share/icons/hicolor/48x48/apps/"+modelData.icon+".png"
                    implicitSize:20
                    anchors.verticalCenter: parent.verticalCenter
                }*/
                Text{
                    font.family: "ESPACION"
                    font.pixelSize: 18
                    text: modelData.name
                    color: "White"
                }}
            }
        }
    }
    }
    }
}