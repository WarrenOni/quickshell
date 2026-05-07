import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import qs.modules.Reusable
//import Quickshell.Services.UPower
import "../"

PopupWindow{
  id:root
  implicitHeight: 400
  implicitWidth: 380
 // property int bar_width
 // property int bar_height
  property var bar_window
  property int sweepangle:P_data.power.displayDevice.percentage * 100
  property color textcolor: "white"
  visible: true
  signal toggle()
  color:"transparent"
  anchor.rect.x: 1220//bar_width / 2 - implicitWidth / 2
  anchor.rect.y: 35//bar_height
  anchor.window: bar_window
  Process{
    id: proc
    command: ["./.config/quickshell/Extra/batinfo.sh"]
    stdout:StdioCollector{
      onDataChanged: (data) => P_data.batinfo=JSON.parse(text.trim())
    }
  }
  Component.onCompleted:{
    proc.running=true
    }

  Item{
    id:mainmenu
    width: parent.width
    height: parent.height
    x: P_data.bat_open ? 0: 385
    Behavior on x{
      NumberAnimation{
        duration:400;easing.type:Easing.OutQuad
        onRunningChanged:if(!P_data.bat_open&&mainmenu.x===385){toggle()}
        }
    }
  Column{
    anchors.fill: parent
    spacing:5
    Item{
      anchors.fill: parent
      MorphShape1{
        id: semicirc
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -10
        sweepangle: root.sweepangle*1.8
      }
      Text{
        anchors.centerIn:parent
        anchors.verticalCenterOffset:-50
        anchors.horizontalCenterOffset: -5
        font.pixelSize: 35
        color:root.textcolor
        text:{
          if (root.sweepangle<=25) return "\uf244"
          else if (root.sweepangle<=50) return "\uf243"
          else if (root.sweepangle<70) return "\uf242"
          else if (root.sweepangle<80) return "\uf241"
          else if (root.sweepangle>=80) return "\uf240"
        }
      }
      Text{
        anchors.centerIn: parent
        anchors.verticalCenterOffset:-5
        font.pixelSize: 25
        font.bold: true
        color:root.textcolor
        font.family: "Espacion"
        text: root.sweepangle + "%"+"\nBAT"
      }
    }
    Row{
      anchors.centerIn:parent
      anchors.verticalCenterOffset: 70
      spacing: 80
      PillRect{
          first_text: P_data.batinfo.Cap
          second_text:"Capacity"
          width:120
          height:60
          radius:20
      }
      PillRect{
          first_text: P_data.batinfo.Time
          second_text:"Time Left"
          width:120
          height:60
          radius:20
      }
    }
    Item{
    }
  }
  }
}
