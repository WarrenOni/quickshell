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
    Loader{active:true;sourceComponent:Bar{}}
    LazyLoader{active:P_data.wrapperlayout;WrapperLayout{}}
    LazyLoader{
        id: wallpaper_selector
        active: root.wallselect
        component:Wallpaper{
            onToggle:{root.wallselect=false}
        }
        //source: "Extra/Wallpaper.qml"
        }
    //LazyLoader{active:P_data.audio_on;component:Music_Visualizer{}}
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
    LazyLoader{active:P_data.media_player_vis;component:Media_Player{}}
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
