import QtQuick
import Quickshell.Services.Mpris
Item{
    id: root
    property bool clock_panel
    property var date1: new Date()
    property var date: new Date()
    property var milli_s: date.getMilliseconds()
    property var day: root.date1.toLocaleDateString(Qt.locale(),"dddd")
    
    visible: root.clock_panel
    anchors.centerIn: parent
    

    Timer{
            interval: 16
            running: true
            repeat: true
            onTriggered:{
                root.date = new Date()
            }
    }
    Rectangle{
        id: date_rect
        height: 55
        width: {
            switch(root.day){
                case "Monday" : return 450;
                case "Friday" : return 550;
                case "Tuesday": return 460;
                case "Wednesday": return 290;
                case "Thursday": return 350;
                case "Saturday": return 340;
                case "Sunday": return 500;
                default: return 500;
            }
        }
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -200
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: {if(width!==290){return -210}else{-260}}
        color: theme.primary
        transform: Shear{
            xFactor: {
                switch(date_rect.width){
                    case 340: case 500: case 290: return 0.06;
                    default: return -0.2;
                }
            }
            yFactor: 0
        }
    }
    Text{
        text: root.date1.toLocaleDateString(Qt.locale(),"d")
        anchors.verticalCenter: date_rect.verticalCenter
        anchors.verticalCenterOffset: -12
        anchors.right: date_rect.right
        anchors.rightMargin: 15
        color: theme.background
        font.pixelSize: 30
        font.family: "Noto Sans Black"
        font.italic: true
        font.capitalization: Font.AllUppercase
    }
    Text{
        text: root.date1.toLocaleDateString(Qt.locale(),"MMMM")
        anchors.verticalCenter: date_rect.verticalCenter
        anchors.verticalCenterOffset: 12
        anchors.right: date_rect.right
        anchors.rightMargin: 15 
        color: theme.background
        font.pixelSize: 30
        font.family: "Noto Sans Black"
        font.italic: true
        font.capitalization: Font.AllUppercase
    }
    Text{
        text: root.day
        anchors.verticalCenter: date_rect.verticalCenter
        anchors.verticalCenterOffset: -2.8
        anchors.left: date_rect.right
        anchors.leftMargin: {
            switch(date_rect.width){
                case 450: case 550: return -15.5;
                case 350: case 460: return -20.5;
                case 340: case 500: return -19.8;
                case 290: return -6;
                default: return -15.5;
            }
        }
        color: theme.primary
        font.pixelSize:{ if(anchors.leftMargin===-19.8)
        {return 75.5;}
        else{return 77}
        }
        font.family: "Noto Sans Black"
        font.italic: true
        font.capitalization: Font.AllUppercase
    }
    ///////////------clock-------
    Rectangle{
        id: clock 
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenterOffset: 10
        anchors.horizontalCenterOffset: -180
        height: 250
        color: theme.surface_container_highest
        width: height
        radius: 90
        rotation: 45
        SequentialAnimation on rotation{
            running: false
            loops: Animation.Infinite
            NumberAnimation{from: 0; to: 180; duration: 8000}
        }
    }
    //text for time
    Text{
        text:"12"
        anchors{
            horizontalCenter: clock.horizontalCenter
            verticalCenter: clock.verticalCenter
            verticalCenterOffset: -95
        }
        font.pixelSize: 45
        color: theme.error_container
        font.family: "PIXELON"
        font.bold: true
    }

    Text{
        text:"6"
        anchors{
            horizontalCenter: clock.horizontalCenter
            verticalCenter: clock.verticalCenter
            verticalCenterOffset: 95
        }
        font.pixelSize: 45
        color: theme.on_tertiary_fixed
        font.family: "PIXELON"
        font.bold: true
    }
    Text{
        text:"3"
        anchors{
            horizontalCenter: clock.horizontalCenter
            verticalCenter: clock.verticalCenter
            horizontalCenterOffset: 105
        }
        font.pixelSize: 38
        color: theme.secondary
        font.family: "PIXELON"
        font.bold: true
    }
    Text{
        text:"9"
        anchors{
            horizontalCenter: clock.horizontalCenter
            verticalCenter: clock.verticalCenter
            horizontalCenterOffset: -105
        }
        font.pixelSize: 38
        color: theme.secondary
        font.family: "PIXELON"
        font.bold: true
    }

    //hider
        Rectangle{
            id: hider
            height: width
            width: 17
            radius: 8
            color: theme.primary
            z:4
            anchors.centerIn: clock
        }
    //seconds_hand
        Rectangle{
            id: seconds
            height: 120
            width: 10
            radius: 5
            z:3
            //origin-transform
            transformOrigin: Item.Bottom
            rotation: (root.date.getSeconds()+root.milli_s/1000)*6
            anchors.verticalCenter: clock.verticalCenter
            anchors.horizontalCenter: clock.horizontalCenter
            anchors.verticalCenterOffset: -60
            color: theme.primary 
        }
    //minute_hand
        Rectangle{
            id: minutes
            height: 90
            width: 10
            radius: 10
            z:2
            //origin-transform
            transformOrigin: Item.Bottom
            rotation: (root.date.getMinutes()+root.date.getSeconds()/60)*6
            anchors.verticalCenter: clock.verticalCenter
            anchors.horizontalCenter: clock.horizontalCenter
            anchors.verticalCenterOffset: -45
            border.color: theme.primary_container 
            color: "transparent"
            border.width: 3
        }
    //hour_hand
        Rectangle{
            id: hours
            height: 65
            width: 10
            radius: 10
            z:1
            //origin-transform
            rotation: (root.date.getHours()%12+root.date.getMinutes()/60)*30
            transformOrigin: Item.Bottom
            anchors.verticalCenter: clock.verticalCenter
            anchors.horizontalCenter: clock.horizontalCenter
            anchors.verticalCenterOffset:-32.5
            color: theme.on_primary_fixed 
        }
    ////////////////////---------------------------------------//////
    //---seprator-------
    Rectangle{
        anchors.centerIn: parent
        height: 250
        opacity: 0.1
        width: 5
        radius: 20
        anchors.verticalCenter: parent.verticalCenter
    }
    ///////---mpris----
    Rectangle{
        id: player_rect
        width: 300
        height: 80
        radius: 20
        color: theme.primary
        opacity: 0.5
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenterOffset: -80
        anchors.horizontalCenterOffset: 180
        }
        Row{
            anchors.fill: player_rect
            spacing: 10
            anchors.margins: 10
            Rectangle{
                id: rec1
                radius: 10
                height: 60
                width: 60
                color: theme.secondary
            }
            
            Text{
                
            }
        }


}