import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick
import "./modules/"
//import "./modules/Widget/"
import "./Extra/"

//import "~/.config/quickshell"

/* Req:
    fonts: pixelon, orbitron, Whispering Signature\-Personal use
 */

ShellRoot{ 
    id: root
    Colors {id:theme}

    property bool wallselect: false
    property bool launcher: false
     //pipewire_audio
    property string whispering: "Whispering Signature\-Personal use"
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
            whispering: root.whispering
            volume: root.volume
            volumeMuted: root.volumeMuted
            defaultAudioSink: root.defaultAudioSink
        }
    }

    Loader{
        id: wallpaper_selector
        active: root.wallselect
        source:"Extra/Wallpaper.qml" 

        IpcHandler {
            target: "wallselect"
            function open(): void {
                root.wallselect = !root.wallselect
                console.log("fixed")
            }
            }
        }
    Loader{
        id: launcher
        active: root.launcher
        source:"Extra/Launcher.qml" 

        IpcHandler {
            target: "launcher"
            function open(): void {
                root.launcher = !root.launcher
                console.log("application launcher started")
            }
            }
        }
}