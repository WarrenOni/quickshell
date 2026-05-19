pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Networking
import Quickshell.Services.UPower
import Quickshell.Services.SystemTray
import Quickshell.Services.Notifications
import Quickshell.Services.Pipewire

//For_Persistant_Storing_data
Singleton {
    id: root
    readonly property var wifiData: Network
    property var bluetoothData: ({})
    property var batinfo: ({})
    readonly property var players: Mpris.players.values
    readonly property MprisPlayer player: players[0]
    readonly property bool audio_on: players.length > 0
    readonly property var power: UPower
    readonly property var systray: SystemTray
    property bool bat_open: false
    property bool media_player_vis: false
    property var noti
    property color power_color: "#00ff00"
    property var current_time: Qt.formatDateTime(clock.date, "hh:mm")
    property bool tor_win: false
    property bool dash_open: false
    //layout changing
    property bool wrapperlayout: true
    //  property string app: player.
    property bool first_run: true
    property ListModel historyModel: ListModel {}
    property string whispering: "Whispering Signature\-Personal use"
    //vol
    property var defaultAudioSink: Pipewire.defaultAudioSink
    property int volume: defaultAudioSink && defaultAudioSink.audio ? Math.round(defaultAudioSink.audio.volume * 100) : 0
    property bool volumeMuted: defaultAudioSink && defaultAudioSink.audio ? defaultAudioSink.audio.muted : false
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
    ///
    signal new_notif(var data)
    onBluetoothDataChanged: console.log("bluetooth_data_changed")

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    NotificationServer {
        id: notif
        //  actionIconsSupported: true
        actionsSupported: true
        // bodyHyperlinksSupported: true
        // bodyImagesSupported: true
        // bodyMarkupSupported: true
        bodySupported: true
        imageSupported: true
        keepOnReload: true
        persistenceSupported: true
        onNotification: u => {
            u.tracked = true;
            root.historyModel.insert(0, {
                summary: u.summary,
                id: u.id,
                body: u.body,
                image: u.image,
                appIcon: u.appIcon,
                app: u.appName,
                imp: u.urgency
            });
            root.new_notif(u);
            console.log("got");
        }
    }
}
