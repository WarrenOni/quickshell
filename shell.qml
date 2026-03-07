import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick
import "./modules/"
import "./modules/Widget/"

//import "~/.config/quickshell"

/* Req:
    fonts: pixelon, orbitron
 */

ShellRoot{ 
    id: root
    Colors {id:theme}

     //pipewire_audio
    property var defaultAudioSink: Pipewire.defaultAudioSink
    property int volume: defaultAudioSink && defaultAudioSink.audio 
        ? Math.round(defaultAudioSink.audio.volume * 100) : 0
    property bool volumeMuted: defaultAudioSink && defaultAudioSink.audio 
        ?  defaultAudioSink.audio.muted :  false
    PwObjectTracker{ 
        objects: [Pipewire.defaultAudioSink]
         }
    

    Loader {
        active: true
        sourceComponent: Bar {
            // forward audio properties from the shell root
            volume: root.volume
            volumeMuted: root.volumeMuted
            defaultAudioSink: root.defaultAudioSink
        }
    }
}