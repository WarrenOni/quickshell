import QtQuick
import Quickshell.Wayland
import Quickshell
import Quickshell.Io
PanelWindow{
    color:"transparent"
    WlrLayershell.layer: WlrLayer.Background
    exclusionMode: ExlusionMode.Ignore
    Process{
        running: true
        command: ["glava","--desktop"]
    }
}