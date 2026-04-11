import QtQuick
Item{
    id: root
    property int r_width
    property int r_height
    property int r_radius
    property real r1_width
    property int seeker
    property bool seeker_active: false
    property color r_color
    property color r1_color

    height: root.r_height + seeker
    width: root.r_width
Rectangle{
    id:r1
    width: root.r_width
    height: root.r_height
    radius: root.r_radius
    color: root.r_color

}
Rectangle{
    id: r2
    anchors.left: r1.left
    width: root.r1_width
    height: root.r_height
    color: root.r1_color
    radius: root.r_radius
}
Rectangle{
    height:width
    color: r2.color
    visible: root.seeker_active //((r2.width < 10)|| (r2.width > r1.width - 10)) ? false: true
    width: root.seeker 
    radius: root.seeker/2
    anchors.horizontalCenter:r2.right
    anchors.verticalCenter: parent.verticalCenter
    anchors.verticalCenterOffset: -root.seeker/2
}
}