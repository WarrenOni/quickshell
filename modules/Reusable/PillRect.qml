import QtQuick
Item{
    id: pillrect
    property var first_text
    property var second_text
    property int radius: 0
    Rectangle{
    anchors.fill: parent
    width: 20
    height: 20
    color:theme.primary
    radius: pillrect.radius
    Column{
      anchors.centerIn: parent
      Text{
        text: pillrect.first_text
        font.family: "Espacion"
        font.pixelSize: 15
        font.italic: true
      }
      Text{
        text: pillrect.second_text
        font.family: "Espacion"
        font.bold: true
        font.pixelSize: 17
      }
    }
  }
}