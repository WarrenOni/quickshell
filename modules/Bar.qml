import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import "../"
import "./Reusable/"

PanelWindow {
    //----------
    // Corner{anchors.left: mainbar.left;anchors.top:mainbar.bottom}
    // Corner{anchors.right: mainbar.right;anchors.top:mainbar.bottom;deg:90}
    ///////////
    id: bar
    //-------vol
    property string whispering: P_data.whispering
    property int volume: P_data.volume
    property bool volumeMuted: P_data.volumeMuted
    property var defaultAudioSink: P_data.defaultAudioSink
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

    function volume_up() {
        console.log("vol_up");
        Quickshell.execDetached(["wpctl", "set-volume", "-l", "1", "@DEFAULT_AUDIO_SINK@", "2%+"]);
    }
    function volume_down() {
        console.log("vol_down");
        Quickshell.execDetached(["wpctl", "set-volume", "-l", "1", "@DEFAULT_AUDIO_SINK@", "2%-"]);
    }
    implicitHeight: 50
    exclusiveZone: 35
    color: "transparent"
    Rectangle{id:bar_fill;width:parent.width;height:bar.exclusiveZone;color:theme.background}
    Corners{anchors.left: bar_fill.left;anchors.top:bar_fill.bottom}
    Corners{anchors.right:bar_fill.right;anchors.top:bar_fill.bottom;rotation:90}
    anchors {
        top: true
        left: true
        right: true
    }
    // color: theme.background
    /////////////////
    Notif_Pop {
        id: notification_pop
    }
    ////////////
    //MENU
    Loader {
        id: menu2
        property bool open: false
        //asynchronous: true
        active: false
        visible: open
        function dash_starter() {
            menu2.active = true;
            menu2.open = !menu2.open;
        }
        sourceComponent: Extnded_clk {
            open: menu2.visible
            bar_window: bar
            bar_height: bar.exclusiveZone
            bar_width: bar.width
        }
        Connections {
            target: menu2.item
            function onToggle() {
                console.log("got_close_value");
                menu2.active = false;
            }
        }
        IpcHandler {
            target: "menu2"
            function open(): void {
                if (menu2.open === false)
                    menu2.dash_starter();
                else {
                    menu2.open = false;
                }
                console.log("application launcher started");
            }
        }
    }
    LazyLoader {
        id: bat_menu
        active: false
        component: Battery {
            id: bat_item
            visible: bat_menu.active
        }
    }
    Connections {
        target: bat_menu.item
        function onToggle() {
            bat_menu.active = false;
            console.log("gotit");
        }
    }
    Item {
        height: bar.exclusiveZone
        width: parent.width
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 15
            spacing: 5

            // 🔹 Workspaces
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
                        onClicked: Hyprland.dispatch("workspace " + modelData.id)
                    }
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }
        // 🔹 Clock
        Rectangle {
            id: clock_rect
            width: clock_text.width + 40
            height: 25
            radius: 15
            color: theme.primary
            anchors.centerIn: parent
            // anchors.verticalCenterOffset: -0.5
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    menu2.dash_starter();
                }
            }

            Text {
                id: clock_text
                color: "black"
                anchors.centerIn: parent
                font.pixelSize: 20
                font.italic: true
                font.bold: true
                font.letterSpacing: 3
                font.family: "Orbitron"
                text: P_data.current_time
            }
        }

        

        Item {
            id: vol_hoverer
            implicitHeight: vol_hoverer_icon.height
            implicitWidth: 30
            visible: opacity
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: clock_rect.width / 2 + 20
            opacity: P_data.audio_on ? 1 : 0
            property bool hovered: false
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onHoveredChanged: {
                    parent.hovered = !parent.hovered;
                    console.log("hovered", parent.hovered);
                }
                onWheel: wheel => {
                    if (wheel.angleDelta.y < 0)
                        bar.volume_up();
                    if (wheel.angleDelta.y > 0)
                        bar.volume_down();
                }
            }
            Behavior on opacity {
                NumberAnimation {
                    duration: 500
                }
            }
            Rectangle {
                id: vol_hoverer_icon
                width: 30
                height: 24
                color: theme.primary
                radius: 15
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    text: "\uf001"
                    color: "black"
                    anchors.centerIn: parent
                }
                Text {
                    visible: bar.volumeMuted || bar.volume === 0
                    text: "|"
                    color: "black"
                    rotation: 45
                    font.pixelSize: 20
                    anchors.centerIn: parent
                    font.bold: true
                    font.family: "ESPACION"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"])
                    onWheel: wheel => {if(wheel.angleDelta.y < 0)bar.volume_up();if(wheel.angleDelta.y > 0)bar.volume_down();}
                }
            }
            Rectangle {
                id: vol_hoverer_comp
                width: vol_hoverer.hovered ? 90 : 0
                height: 5
                anchors.left: vol_hoverer_icon.right
                Behavior on width {
                    NumberAnimation {
                        duration: 300
                    }
                }
                anchors.leftMargin: 8
                radius: 20
                anchors.verticalCenter: vol_hoverer.verticalCenter
                anchors.verticalCenterOffset: 0.5
                Rectangle {
                    anchors.left: parent.left
                    color: theme.primary
                    width: (bar.volume / 100) * vol_hoverer_comp.width
                    height: vol_hoverer_comp.height
                    radius: parent.radius
                }
            }
        }

        Rectangle{
            id: info_panel
            anchors.right: parent.right
            anchors.rightMargin:15
            anchors.verticalCenter:parent.verticalCenter
            width: info_panel_row.width+7
            height: parent.height-10
            color: theme.primary_container
            radius: 20
            Row{
                id: info_panel_row
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 3.5
                spacing: 4
                HoverPills{
                    id: volume_control
                    height: info_panel.height-4
                    width: hovered ? 60:25
                    Behavior on width{NumberAnimation{duration:300;easing.type:Easing.OutQuad}}
                    icon: {
                        if(volume===0||volumeMuted)return "\ueee8"
                        if(volume<=33)return "\uf026"
                        if(volume<=66)return "\uf027"
                        if(volume<=100)return "\uf028"
                        }
                    font: "Pixelon"
                    text: volumeMuted ? "Mute" : volume + "%"
                    MouseArea{
                        anchors.fill: parent
                        onWheel: wheel => {if(wheel.angleDelta.y < 0)bar.volume_up();if(wheel.angleDelta.y > 0)bar.volume_down();}
                        onClicked: Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"])
                    }
                }
                HoverPills{
                    id: brightness_controll
                    height: info_panel.height-4
                    width: hovered ? 50 : 25
                    Behavior on width{NumberAnimation{duration:300;easing.type:Easing.OutQuad}}
                    iconsize:14
                    icon: "\uf522"
                    font: "Pixelon"
                }
                HoverPills{
                    height: info_panel.height-4
                    width: hovered ? 55: 25
                    Behavior on width{NumberAnimation{duration:300;easing.type:Easing.OutQuad}}
                    iconsize:16
                    property int percent: P_data.power.displayDevice.percentage*100;
                    icon: {if (percent<=15) return "\uf244"
                            else if (percent<=30) return "\uf243"
                            else if (percent<=50) return "\uf242"
                            else if (percent<=75) return "\uf241"
                            else if (percent<=100) return "\uf240"
                            }
                    font: "Pixelon"
                    text: percent+"%"
                    MouseArea{
                        anchors.fill: parent
                        onClicked:{bat_menu.active=true;P_data.bat_open=!P_data.bat_open}
                    }
                }
            }
        }

        //systemtray
        Rectangle {
            id: systray
            anchors {
                right: info_panel.left
                rightMargin: 10
                verticalCenter: parent.verticalCenter
                //   verticalCenterOffset: -0.5
            }
            color: theme.primary_container
            radius: 20
            implicitWidth: 28.5 * tray.count
            implicitHeight: 25
            opacity: bar.systemTray.items.count != 0 ? 1 : 0
            visible: opacity !=0
            Behavior on anchors.rightMargin{NumberAnimation{duration:200;easing.type:Easing.OutExpo}}
            Behavior on implicitWidth {
                NumberAnimation {
                    duration: 600
                    easing.type: Easing.OutExpo
                }
            }
            Behavior on opacity {
                NumberAnimation {
                    duration: 300
                }
            }
            Row {
                spacing: 5
                anchors.right: parent.right
                anchors.rightMargin: 3
                Repeater {
                    id: tray
                    model: bar.systemTray.items
                    delegate: Rectangle {
                        width: height
                        height: 23
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 1
                        color: theme.on_tertiary_fixed
                        radius: 15
                        MouseArea {
                            function killit(service) {
                                Quickshell.execDetached(["killall", service]);
                                console.log("killed", service);
                            }
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked: function (mouse) {
                                if (mouse.button === Qt.RightButton) {
                                    killit(modelData.title);
                                } else {
                                    modelData.activate();
                                }
                            }
                        }
                        Rectangle {
                            anchors.centerIn: parent
                            width: height
                            height: 14
                            radius: 20
                            color: "transparent"
                            NumberAnimation on opacity{from:0;to:1;duration:300}
                            Image {
                                anchors.fill: parent
                                source: modelData.icon
                                fillMode: Image.PreserveAspectFit
                            }
                        }
                    }
                }
            }
        }
    }
}
