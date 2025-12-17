import QtQuick 2.15
import "../panels"

Item {
    id: root
    property string activeTab: "ASSISTANT"

    width: parent.width
    height: parent.height
    clip: true // Ensure sliding content doesn't bleed

    function tabIndex(tab) {
        switch (tab) {
        case "CORE": return 0
        case "INPUT": return 1
        case "SYSTEM": return 2
        case "NETWORK": return 3
        case "SETTINGS": return 4
        }
        return 0
    }

    property int index: tabIndex(activeTab)

    // CONTENT STRIP
    Row {
        id: strip
        width: parent.width * 5
        height: parent.height
        x: -parent.index * parent.width // Use parent width for sliding step

        Behavior on x {
            NumberAnimation {
                duration: 360
                easing.type: Easing.OutCubic
            }
        }

        // Panel instances
        // Assume these components exist in ../panels
        AssistantPanel { 
            width: root.width 
            height: root.height 
            theme: root.theme // Fixed binding
            // Safer to assume ThemeLoader is global or passed down.
            // main.qml has `ThemeLoader { id: theme }`.
            // We can reference it if TabContainer is child of Window?
            // Or pass theme property to TabContainer.
        }
        MediaPanel { width: root.width; height: root.height; theme: root.theme }
        VehiclePanel { width: root.width; height: root.height; theme: root.theme }
        NavPanel { width: root.width; height: root.height; theme: root.theme }
        SettingsPanel { width: root.width; height: root.height; theme: root.theme }
    }
    
    property var theme // Accept theme property
}
