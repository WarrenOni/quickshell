pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Services.UPower
import Quickshell.Services.SystemTray
//For_Persistant_Storing_data
Singleton{
    property var wifiData: ({})
    property var bluetoothData: ({})
    property var players: Mpris.players.values
    property MprisPlayer player: player[0]
    property bool audio_on: players.length > 0
    property var power: UPower
    property var systray: SystemTray
    onWifiDataChanged: console.log("wifi_data_changed",wifiData)
    onBluetoothDataChanged: console.log("bluetooth_data_changed")
    
}