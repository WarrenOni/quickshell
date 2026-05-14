import QtQuick
import Quickshell
import QtQuick.Effects
import qs
import "./Reusable"
PanelWindow{
    anchors.top:true
    exclusiveZone:0
    width: 400
    height: 500
    color:"transparent"
    Rectangle{
        anchors.fill: parent
        color:theme.background
        radius:20   
    }
    Column{
        anchors.fill: parent
        topPadding: 15
        spacing: 10
        Row{
            width: parent.width
            height: 40
            //Rectangle{anchors.fill:parent}
            Text{
                text:P_data.player.desktopEntry
                font.pixelSize: 19
                font.family: P_data.whispering
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                }
            HoverPills{
                width: hovered ? 70 : 30
                height: 30
                radius: 12
                padding: 6
                Behavior on width{NumberAnimation{duration:200;easing.type:Easing.OutQuad}}
                text: "Close"
                icon: "\uf025"
                iconsize:20
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 20
            }
        }
        Rectangle{
                anchors.horizontalCenter: parent.horizontalCenter
                visible: true 
                height: 300
                width: 300

                radius: 10
                border.color: theme.secondary
                color: "transparent"
                border.width: 4
                RectangularShadow{anchors.fill:parent;spread:3}
                Image{
                    id: trackart
                    visible:true
                    anchors.centerIn: parent
                    source: P_data.players ? P_data.player.trackArtUrl : null
                    sourceSize.width: width*1.5
                    sourceSize.height: height*1.5
                    //mipmap: true
                    height: parent.height-10
                    width: parent.width -10
                    cache: true
                    fillMode: Image.PreserveAspectCrop
                    MouseArea{
                        anchors.fill: parent
                        onClicked: root.player.raise()
                    }
            }
        }
        Row{
            width: parent.width
            height: 40
            //Rectangle{anchors.fill: parent}
            Text{
                anchors.horizontalCenter: parent.horizontalCenter
                text: P_data.players ? P_data.player.trackTitle : null
                font.pixelSize: 19
                font.family: P_data.whispering
                color: "white"
            }
        }
    }
}