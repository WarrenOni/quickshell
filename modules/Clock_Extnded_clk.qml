import QtQuick
import Quickshell.Services.Mpris
import "./Widget"
Item{
    id: root
    property bool clock_panel
    property var date1: new Date()
    property var date: new Date()
    property var milli_s: date.getMilliseconds()
    property var day: root.date1.toLocaleDateString(Qt.locale(),"dddd")
    property var clock_font: "Electroharmonix"
    property var players: Mpris.players.values
    property MprisPlayer player: players[0]
    property bool open: false
    property bool seeker_active: false

    width: parent.width
    height: parent.height
    clip: true
    visible: root.clock_panel
    anchors.centerIn: parent
    Component.onCompleted:{
        //console.log(players)
        console.log(players.length)
        //date_rect.width = date_rect.cal_width()
    }
    Timer{
            interval: 100
            running: root.open
            repeat: true
            onTriggered:{
                root.date = new Date()
            }
    }
    Item{
        width:parent.width
        height:parent.height
        NumberAnimation on x{
            id: top_anim
            running: root.open
            from: -(root.width)
            to: 0
            duration: 2000
            easing.type: Easing.OutExpo
        }
        NumberAnimation on opacity{
            from: 0
            to: 1
            running: top_anim.running
            duration: 800
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
    }
    ///////////------clock-------
    Item{
        height: clock.height
        width: clock.width
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenterOffset: 10
        anchors.horizontalCenterOffset: -180
        NumberAnimation on scale{
            running: root.open
            from: 0
            to: 1
            duration: 700
            easing.type: Easing.OutQuint
        }
    Rectangle{
        id: clock 
        height: 250
        color: theme.on_secondary_fixed_variant
        width: height
        radius: 100
        rotation: 0
        SequentialAnimation on rotation{
            running: root.open
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
        font.family: root.clock_font
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
        font.family: root.clock_font
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
        font.family: root.clock_font
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
        font.family: root.clock_font
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
            border.color: theme.on_tertiary
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
    }
    ////////////////////---------------------------------------//////
    //---seprator-------
    Rectangle{
        anchors.centerIn: parent
        height: 250
        opacity: 0.05
        width: 4.4
        radius: 20
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 15
    }
    ///////---mpris----
    Item{
        id: mpris_root
        width:player_rect.width
        height:player_rect.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 180

        MouseArea{
            anchors.fill: parent
            property int n
            onWheel: (wheel) => {
                let maxIndex = root.players.length-1;
                if (wheel.angleDelta.y<0) {n=Math.min(n+1,maxIndex)}
                else if (wheel.angleDelta.y>0) {n=Math.max(n-1,0)}
                root.player=root.players[n]
            }
        }

        ParallelAnimation{
            id: player_rect_numb_anim
            running: root.open
        NumberAnimation {
            target: mpris_root
            property:"anchors.verticalCenterOffset"
            from: 50
            to: -80
            duration: 2000
            easing.type: Easing.OutExpo
        }
        NumberAnimation{
            id: player_rect_numb_anim1
            target: mpris_root
            from:0
            to:1
            property:"opacity"
            duration:400
            easing.type: Easing.InQuad
        }}
    Rectangle{
        id: player_rect
        width: 300
        height: 120
        radius: 20
        color: theme.primary
        visible: root.player ? true:false
        opacity: 0.5
        border.color: theme.on_primary_container
        border.width: 2

        MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onHoveredChanged: root.seeker_active = !root.seeker_active
        }
        Column{
            visible: root.players.length > 1
            anchors.left: player_rect.right
            leftPadding:6
            anchors.verticalCenter: player_rect.verticalCenter
            //anchors.verticalCenterOffset: -5
            spacing: 6
        Repeater{
            model: root.players
            delegate:Rectangle{
                width: height
                height: 10
                radius: width/2
                color: modelData === root.player ? theme.primary : theme.on_primary
                MouseArea{
                    id: mpris_repeater
                    anchors.fill: parent
                    onClicked: root.player = modelData
                }
            }
        }
        }}

        Row{
            id: mpris_
            visible: player_rect.visible
            anchors.fill: player_rect
            spacing: 10
            anchors.margins: 10
            clip: false
            property bool cover_visible: trackart.source != "" ? true: false;
            Rectangle{
                visible: mpris_.cover_visible
                height: 100
                width: 100
                radius: 10
                border.color: theme.secondary
                color: "transparent"
                border.width: 4
            Image{
                id: trackart
                anchors.centerIn: parent
                source: root.player.trackArtUrl
                sourceSize.width: width*1.5
                sourceSize.height: height*1.5
                height: 90
                width: 90
                cache: true
                fillMode: Image.PreserveAspectCrop
                MouseArea{
                    anchors.fill: parent
                    onClicked: root.player.raise()
                }

            }
            }
            Column{
            Item{
                id: title_limiter
                width: mpris_.cover_visible ? 170 : 276
                height: 25
                clip: true
            Text{
              id: title
              text: root.player.trackTitle
              font.bold: true
              font.pixelSize: 17
              font.family: "Noto Sans"
              property int anim_time1: 3000
              SequentialAnimation on x{
                id: title_anim
                running: title.contentWidth > title_limiter.width && root.open === true ? true : false
                loops: Animation.Infinite
                onRunningChanged:{
                    title.x=0
                    console.log("running changed")
                }
                PropertyAction{target: title; property:"x"; value:0}
                PauseAnimation{duration:title.anim_time1 }
                NumberAnimation{
                from: 0
                to: -title.contentWidth+title_limiter.width
                duration: title.text.length * 100
                }
                PauseAnimation{duration: 2000 }
              }
            }}
            Text{
                id: artist
                width: 160
                visible: artist.text!=="" ? true: false
                elide: Text.ElideRight
                text: root.player.trackArtist
                font.pixelSize: 12
                font.family: "Noto Sans"
            }
            //dummy
            Item{height: artist.visible? 8: 13;width: 1}
            Seeker{
                id: seekr

                Timer{
                    id:seekr_timer
                    running: root.player && root.player.isPlaying !== "" 
                    interval: 1000
                    repeat: true
                    onTriggered: root.player.positionChanged() 
                }
                r_height: 6
                r_width: mpris_.cover_visible ? 170: 276
                r_color: theme.secondary
                r1_color: theme.on_secondary
                r1_width: (root.player.position)/(root.player.length)*r_width
                seeker: 12
                r_radius: 10
                seeker_active: root.seeker_active
                MouseArea{
                    property int offset: 5
                    anchors.fill: parent
                    onClicked: player.seek(offset)
                }
            }
            Row{
                spacing: mpris_.cover_visible ? 20 : 55
                readonly property real toggleheight: 0.6
                readonly property real togglewidth: 0.4
                readonly property int rad: 8
            PillBut{
                pillwidth: parent.togglewidth
                pillscale: parent.toggleheight
                label: "\udb81\udcae"
                pixelsize: 18
                font_family: "MONOSPACE"
                radius: parent.rad
                opacity: root.player.canGoPrevious ? 1.0: 0.2
                MouseArea{
                    anchors.fill: parent
                    onClicked: root.player.previous()
                }
            }
            PillBut{
                pillwidth: parent.togglewidth
                pillscale: parent.toggleheight
                label: root.player.isPlaying?"\uf04c":"\uf04b"
                pixelsize: 16
                radius: parent.rad
                MouseArea{
                    anchors.fill: parent
                    onClicked: root.player.togglePlaying()
                }
            }
            PillBut{
                pillwidth: parent.togglewidth
                pillscale: parent.toggleheight
                label: "\udb81\udcad"
                opacity: root.player.canGoNext ? 1.0 : 0.2
                pixelsize: 18
                font_family: "MONOSPACE"
                radius: parent.rad
                MouseArea{
                    anchors.fill: parent
                    onClicked: root.player.next()
                }
            } 
            PillBut{
                pillwidth: parent.togglewidth
                pillscale: parent.toggleheight
                label: "\uf074"
                opacity: (root.player.loopSupported || root.player.shuffleSupported) ? 1.0 : 0.2
                pixelsize: 18
                font_family: "MONOSPACE"
                radius: parent.rad
                
                MouseArea{
                    anchors.fill: parent
                    onClicked: root.player.loopState
                }
            } 
            }           
            }
        }
    }
    ///////////////////////
}