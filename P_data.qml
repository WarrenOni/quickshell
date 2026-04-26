pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Services.UPower
import Quickshell.Services.SystemTray
import Quickshell.Services.Notifications
//For_Persistant_Storing_data
Singleton{
    id:root
    property var wifiData: ({})
    property var bluetoothData: ({})
    readonly property var players: Mpris.players.values
    readonly property MprisPlayer player: players[0]
    readonly property bool audio_on: players.length > 0
    readonly property var power: UPower
    readonly property var systray: SystemTray
    property var noti;
    property bool tor_win: false
    property ListModel historyModel: ListModel {}
    signal new_notif(var data)
    onWifiDataChanged: console.log("wifi_data_changed",wifiData)
    onBluetoothDataChanged: console.log("bluetooth_data_changed")
    
    NotificationServer {
        id: notif
        // actionIconsSupported: true
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        bodySupported: true
        imageSupported: true
        keepOnReload: true
        persistenceSupported: true

        onNotification:(u)=> {
            u.tracked = true
            root.historyModel.insert(0,{
                summary: u.summary,
                id: u.id,
                body: u.body,
                image: u.image,
                appIcon: u.appIcon,
                app: u.appName,
                imp: u.urgency
            })
            root.new_notif(u)
            console.log("got")
        }

    }
}