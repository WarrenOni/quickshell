
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts 
import QtQuick.Effects
import "../"
import "./Reusable/"

PanelWindow {
        //-------vol
        property string whispering: ""
        property int volume: 0
        property bool volumeMuted: false
        property var defaultAudioSink
        //bar property
        property int topmar: 0
        property int btmmar: 0
        property int rtmar: 0
        property int toparc: 0
        property int btmarc: 0
        ///////////
        property var uPower: P_data.power
        property var systemTray: P_data.systray
       // property var audio_state
        property bool audio_on: P_data.audio_on

        function volume_up(){
            console.log("vol_up")
            Quickshell.execDetached(["wpctl","set-volume","-l","1","@DEFAULT_AUDIO_SINK@","2%+"])
        }
        function volume_down(){
            console.log("vol_down")
            Quickshell.execDetached(["wpctl","set-volume","-l","1","@DEFAULT_AUDIO_SINK@","2%-"])
        }
        //----------
       // Corner{anchors.left: mainbar.left;anchors.top:mainbar.bottom}
      //  Corner{anchors.right: mainbar.right;anchors.top:mainbar.bottom;deg:90}

        ///////////
        id: bar
    /////////////////
        Notif_Pop{
            id:notification_pop
            bar_window: bar
            bar_height: bar.height
            bar_width: bar.width
        }
        //MENU
                    
        Loader{
            id:menu2
            property bool open: false
            //asynchronous: true
            active: false
            visible: open
            function dash_starter(){menu2.open=!menu2.open;}
            sourceComponent: Extnded_clk{
                open: menu2.visible
                bar_window: bar
                bar_height: bar.implicitHeight
                bar_width: bar.width
            }
            Connections{
                target: menu2.item
                function onToggle(){console.log("got_close_value");
                //menu2.active=false
                }
            }
            IpcHandler{
                target: "menu2"
                function open(): void {
                if (menu2.open===false) menu2.dash_starter()
                else{menu2.open=false}
                console.log("application launcher started")
            }
            }
        }


        
        property real targetheight: menu2.open ? 70:35
        Behavior on targetheight { NumberAnimation { duration: 400; easing.type: Easing.OutExpo } }
        anchors{top:true;left:true;right:true;bottom:true} 
        visible: true
        exclusionMode: ExclusionMode.Ignore
        color: "transparent"
        mask: Region{
           // x:0;y:35;width:1600;height:900
            //item: substract_shape
            //intersection: Intersection.Subtract
            item: maskShapeSource
            intersection: Intersection.Xor
            }
        Rectangle{
            id: bg
            color: theme.background
            layer.enabled: true
            visible: false
            width: 1600
            height: 45
        }
        MultiEffect{
            width: 1600
            height: 855
            anchors.bottom: parent.bottom
            source: bg
            maskInverted: true
            maskEnabled: true
            maskSource: maskShapeSource
        }

//////////////////

    Item{
            width:1600
            height: 855
            anchors.centerIn: parent
            anchors.bottom: parent.bottom
                    id: maskShapeSource
                    layer.enabled: true
                    visible: false
                    opacity: 0
                    Shape{
                        id: substract_shape
                        MouseArea{anchors.fill: parent}
                        ShapePath{
                            id:shpth
                            fillColor:"red"
                            
                            property bool open: menu2.open
                            property real shheight: open ? 110:0
                            Behavior on shheight{NumberAnimation{duration:500}}
                            startX:800;startY:open?110:0
                            PathLine{x:1050;y:shpth.open?110:0}
                            PathLine{x:1050;y:0}
                            PathLine{x:1575;y:0}
                            PathArc{
                                relativeX: 20
                                relativeY: 15
                                radiusX: 20
                                radiusY: 15
                            }
                            PathLine{x:1595;y:840}
                            PathArc{
                                relativeX: -20
                                relativeY: 15
                                radiusX:20
                                radiusY:15
                                //direction:PathArc.Counterclockwise
                            }
                            PathLine{x:25;y:855}
                            PathArc{
                                relativeX: -20
                                relativeY: -15
                                radiusX:20
                                radiusY:-15
                            }
                            PathLine{x:5;y:10}
                            PathArc{
                                relativeX: 20
                                relativeY: -15
                                radiusX:20
                                radiusY:-15
                            }
                            PathLine{x:550;y:0}
                            PathLine{x:550;y:shpth.open?110:0}
                            PathLine{x:800;y:shpth.open?110:0}
                        }
                    }
            }
                    
        
////////////////

        
    Item{
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left
            height:40
        RowLayout {
            anchors.fill: parent   
            anchors.verticalCenter: parent.verticalCenter  
            anchors.leftMargin: 15       
            spacing: 5
            
            // Workspaces
            Repeater {
                id: workspaces
                model: Hyprland.workspaces

                    Rectangle {
                    implicitHeight: 20
                    implicitWidth: 20
                    radius: 10
                    color: modelData.active ? theme.primary : theme.on_primary

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch(
                            "workspace " + modelData.id
                        )
                    }
                }
            }

            Item { Layout.fillWidth: true }
            
            // Battery
            Rectangle{
                id: containerRect
                Layout.alignment:Qt.AlignRight
                //anchors.right: parent.right
                //anchors.rightMargin: 10
                //anchors.verticalCenter: parent.verticalCenter
                Layout.rightMargin:15
                Layout.bottomMargin:3
                radius: 20
                border.color: uPower.displayDevice.state === 1 ? theme.tertiary : (uPower.displayDevice.percentage < 0.25 ? "#f00" : theme.primary)
                color: "transparent"
                border.width: 1
                implicitHeight: 25
                implicitWidth: 80
                visible: uPower.displayDevice
                
                Rectangle{
                    id: innerFill
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    radius: 20
                    color: containerRect.border.color
                    implicitHeight: 25
                    implicitWidth: uPower.displayDevice.percentage * 100
                //  anchors.verticalCenterOffset: 0
        
                }
                Text {
                    id: innerText
                    color: "black"
                    anchors.centerIn: parent
                    font.pixelSize: 15
                    font.italic: true
                    font.family: "Pixelon"
                    font.bold: containerRect.border.color != theme.primary ? true : false
                    text: Math.round(uPower.displayDevice.percentage * 100) + "%"
                }

            }
            }

         // 🔹 Clock
            Rectangle{
                id: clock_rect
                width: clock_text.width+40
                height: 25
                radius: 15
                color: theme.primary
                anchors.centerIn: parent
            // anchors.verticalCenterOffset: -0.5
                MouseArea{
                    anchors.fill: parent
                    onClicked: {menu2.dash_starter()}
                }
                

            Text {
                id: clock_text
                color: "black"
                anchors.centerIn:parent
                font.pixelSize: 20
                font.italic: true
                font.bold: true
                font.letterSpacing: 3
                font.family: "Orbitron"
                text: P_data.current_time
            }
            }


            // Volume
            Item{
                anchors.fill: parent
                state: audio_on ? "expanded" :"hidden"
                 
                states:[
                    State{
                        name:"hidden"
                        PropertyChanges{target:drop;opacity:0;x:bar.width-185;width:80}
                        PropertyChanges{target:vol_hoverer;opacity:0}
                        PropertyChanges{target:volumeContainer;opacity:1}
                    },
                    State{
                        name:"expanded"
                        PropertyChanges{target:volumeContainer;opacity:0}
                        PropertyChanges{target:drop;opacity:1;width:vol_hoverer_icon.width;x:(bar.width+clock_rect.width+10)/2}
                        PropertyChanges{target:vol_hoverer;opacity:1}
                    }
                ]
                transitions:[
                    Transition{
                        id: h_e
                        from:"hidden";to:"expanded"
                        SequentialAnimation{
                            ParallelAnimation {
                                SequentialAnimation{
                                    NumberAnimation {
                                        target: drop
                                        property: "width"
                                        to: 200
                                        duration: 500
                                        easing.type:Easing.InExpo
                                    }
                                    NumberAnimation {
                                        target: drop
                                        property: "width"
                                        to: vol_hoverer_icon.width
                                        duration: 500
                                        easing.type: Easing.OutQuad
                                    }
                                }
                                SequentialAnimation{
                                    NumberAnimation {
                                        target: drop
                                        property: "height"
                                        to: 10
                                        duration: 500
                                    }
                                    NumberAnimation {
                                        target: drop
                                        property: "height"
                                        to: vol_hoverer_icon.height
                                        duration: 500
                                    }
                                }
                                NumberAnimation {
                                    target: drop
                                    property: "x"
                                    to: (bar.width+clock_rect.width+10)/2
                                    duration: 1000
                                    easing.type: Easing.InOutQuart
                                }
                                NumberAnimation {
                                    target: drop
                                    property: "opacity"
                                    to: 1
                                    duration: 100
                                }
                                NumberAnimation{
                                    target: vol_hoverer
                                    property: "opacity" 
                                    to:0
                                    duration: 100
                                }
                            }
                        }
                    },
                    Transition{
                        id:e_h
                        from:"expanded"; to:"hidden"
                        SequentialAnimation{
                            ParallelAnimation{
                                SequentialAnimation{
                                    NumberAnimation {
                                        target: drop
                                        properties: "width"
                                        to:  200
                                        duration: 500
                                    }
                                    NumberAnimation {
                                        target: drop
                                        properties: "width"
                                        to: volumeContainer.width
                                        duration: 500
                                        easing.type: Easing.OutExpo
                                    }
                                }
                                SequentialAnimation{
                                    NumberAnimation {
                                        target: drop
                                        properties: "height"
                                        to:  10
                                        duration: 500
                                    }
                                    NumberAnimation {
                                        target: drop
                                        properties: "height"
                                        to: volumeContainer.height
                                        duration: 500
                                    }
                                }
                                NumberAnimation {
                                    target: drop
                                    property: "opacity"
                                    to:1
                                    duration: 100
                                    easing.type: Easing.InOutQuad
                                }
                                NumberAnimation {
                                    target: drop
                                    property: "x"
                                    to:bar.width-185
                                    duration: 1000
                                    easing.type: Easing.InOutQuart
                                }
                                NumberAnimation{
                                    target: volumeContainer
                                    property: "opacity" 
                                    to:0
                                    duration: 100
                                }
                            }
                        }
                    }
                ]
                Rectangle{
                    id: drop
                    visible: true
                    color: theme.primary
                    width: volumeContainer.width 
                    height: volumeContainer.height 
                    radius: volumeContainer.visible ? volumeContainer.radius: vol_hoverer_icon.radius
                    x: bar.width-188
                    anchors.verticalCenter: parent.verticalCenter
                    Behavior on opacity{
                        NumberAnimation{duration:200}
                    }
                }
            }
                Rectangle{
                    id: volumeContainer
                    anchors{
                        right: parent.right
                        rightMargin: 105
                        verticalCenter: parent.verticalCenter
                        verticalCenterOffset: -0.5
                    }
                    color: "transparent"
                    radius: 20
                    opacity: 1
                    border.width: 1
                    border.color: theme.primary
                    implicitWidth: 80
                    implicitHeight: 25
                    Behavior on opacity{
                        NumberAnimation{duration:300}
                    }
                
                Rectangle{
                    id: volumeContainer_in_bar
                    anchors{
                        right: parent.right
                        rightMargin: 0
                        verticalCenter: parent.verticalCenter
                        verticalCenterOffset: -0.5
                    }
                    color: theme.primary
                    radius: 20
                    implicitWidth: volume * 0.8
                    implicitHeight: 25
                    }
                Text{
                    color: volume<65? "white" : "black"
                    anchors.centerIn: volumeContainer
                    font.pixelSize: 15
                    font.italic: true
                    font.family: "Pixelon"
                    //visible: uPower.displayDevice.present
                    Layout.rightMargin: 2
                    //anchors.verticalCenterOffset: 1.5
                    text: volumeMuted ? "Muted" : volume + "%"
                }
                }


                Item{
                    id: vol_hoverer
                    implicitHeight: vol_hoverer_icon.height
                    implicitWidth: 30
                    visible: opacity
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: clock_rect.width/2+20
                    opacity: 1
                    property bool hovered: false
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onHoveredChanged: {
                            parent.hovered=!parent.hovered 
                            console.log("hovered",parent.hovered)  
                        }
                        onWheel:(wheel)=>{
                            if (wheel.angleDelta.y<0)bar.volume_up()
                            if (wheel.angleDelta.y>0)bar.volume_down()
                        }
                    }
                    Behavior on opacity{
                        NumberAnimation{duration:200}
                    }   
                    Rectangle{
                        id: vol_hoverer_icon
                        width: 30
                        height: 24
                        color: theme.primary
                        radius: 15
                        anchors.verticalCenter: parent.verticalCenter
                        Text{
                            text: "\uf028"
                            color: "black"
                            anchors.centerIn: parent
                        }
                        Text{visible:bar.volumeMuted||bar.volume===0;text:"|";color:"black";rotation:45;font.pixelSize:20;anchors.centerIn:parent;font.bold:true;font.family:"ESPACION"}
                        MouseArea{anchors.fill:parent;onClicked:Quickshell.execDetached(["wpctl","set-mute","@DEFAULT_AUDIO_SINK@","toggle"])}
                    }
                    Rectangle{
                        id: vol_hoverer_comp
                        width: vol_hoverer.hovered ? 90: 0
                        height:5
                        anchors.left: vol_hoverer_icon.right
                        Behavior on width{
                            NumberAnimation{
                                duration: 300
                            }
                        }
                        anchors.leftMargin: 8
                        radius: 20
                        anchors.verticalCenter: vol_hoverer.verticalCenter
                        anchors.verticalCenterOffset: 0.5
                        Rectangle{
                        anchors.left: parent.left
                        color: theme.primary
                        width: (bar.volume/100)*vol_hoverer_comp.width
                        height: vol_hoverer_comp.height
                        radius: parent.radius
                    }
                    } 
                }
          Item{}

        
        //systemtray
        Rectangle{
            id:systray
            anchors{
                right: parent.right
                rightMargin: volumeContainer.opacity ? 195 : 110
                verticalCenter: parent.verticalCenter
             //   verticalCenterOffset: -0.5
            }
            color: theme.primary
            radius: 20
            implicitWidth: 28.5 * tray.count
            implicitHeight: 25
            opacity: !(h_e.running||e_h.running)
           // onOpacityChanged:{console.log("changed")}
            Behavior on implicitWidth{
                NumberAnimation{
                    duration: 600
                    easing.type: Easing.InSine
                }
            }
            Behavior on opacity{
                NumberAnimation{duration:300}
            }
            Row{
                spacing:5
                anchors.right:parent.right
                anchors.rightMargin: 3
                Layout.alignment: Qt.AlignRight
                Repeater{
                    id: tray
                    model: bar.systemTray.items
                    delegate:
                        Rectangle{
                            width: height
                            height: 23
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset:1
                            color: theme.on_tertiary_fixed
                            radius: 15
                        Rectangle{
                        anchors.centerIn: parent
                        width:height
                        height: 12
                        radius:20
                        color: "transparent"
                        Image{
                            anchors.fill:parent
                            source: modelData.icon
                            fillMode: Image.PreserveAspectFit
                        }
                        MouseArea{
                            function killit(service){
                                Quickshell.execDetached(["killall",service])
                                console.log("killed",service)
                            }
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked:function(mouse) {
                                if (mouse.button === Qt.RightButton) {
                                    killit(modelData.title)
                                } else {
                                    modelData.activate()
                                }
                            }
                        }
                        }
                    }
                }
            }
        }
    }
}

