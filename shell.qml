import Quickshell
import Quickshell.Services.Pipewire
//import Quickshell.Hyprland
import Quickshell.Io
//import Quickshell.Services.UPower
import QtQuick
import "./modules/"
import "./Extra"
//import qs.modules.Reusable

/* Req:
    fonts: pixelon, orbitron, Whispering Signature\-Personal use
 */

ShellRoot{ 
    id: root
    Colors {id:theme
    //property string background: "#ffffff"
    }

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

    Bar {
         // forward audio properties from the shell root
            whispering: root.whispering
            volume: root.volume
            volumeMuted: root.volumeMuted
            defaultAudioSink: root.defaultAudioSink
        }
    LazyLoader{
        id: wallpaper_selector
        active: root.wallselect
        component:Wallpaper{
            onToggle:{root.wallselect=false}
        }
        //source: "Extra/Wallpaper.qml"
        }
    IpcHandler {
            target: "wallselect"
            function open(): void {
                root.wallselect = !root.wallselect
                console.log("wallpaper_selector_launched")
        }
    }
    LazyLoader{
        id: launcher
        active: root.launcher
        loading: root.launcher
        component: Launcher{
            onToggle: root.launcher=false
        }
    }
    
    IpcHandler {
            target: "launcher"
            function open(): void {
                root.launcher = !root.launcher
                //root.launcher.visible = !root.launcher.visible
                console.log("application launcher started")
            }
    }
    LazyLoader{
        id: tor_win
        active: P_data.tor_win
        loading: P_data.tor_win
        component: Torrer{}
    }
}
