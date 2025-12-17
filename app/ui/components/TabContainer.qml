import QtQuick 2.15
import "../panels"

Item {
    id: root
    property string activeTab: "HOME"

    width: parent.width
    height: parent.height
    clip: true

    // ═══════════════════════════════════════════════════════
    // NAVIGATION INDEX MAPPING
    // ═══════════════════════════════════════════════════════
    function tabIndex(tab) {
        switch (tab) {
        case "HOME": return 0
        case "ASSISTANT": return 1
        case "SYSTEM": return 2
        case "NETWORK": return 3
        case "SETTINGS": return 4
        }
        return 0
    }

    property int index: tabIndex(activeTab)

    // ═══════════════════════════════════════════════════════
    // CONTENT STRIP (Horizontal Panel Layout)
    // ═══════════════════════════════════════════════════════
    Row {
        id: strip
        width: parent.width * 5
        height: parent.height
        x: -parent.index * parent.width

        Behavior on x {
            NumberAnimation {
                duration: theme ? theme.transitionNormal : 360
                easing.type: theme ? theme.easingType : Easing.OutCubic
            }
        }

        // Panel 0: HOME (Dashboard)
        AssistantPanel { 
            id: homePanel
            width: root.width 
            height: root.height 
            theme: root.theme
            onNavigateTo: function(tab) { root.requestNavigation(tab) }
        }
        
        // Panel 1: ASSISTANT (AI Focus)
        MediaPanel { 
            width: root.width
            height: root.height
            theme: root.theme 
        }
        
        // Panel 2: SYSTEM
        VehiclePanel { 
            width: root.width
            height: root.height
            theme: root.theme 
        }
        
        // Panel 3: NETWORK
        NavPanel { 
            width: root.width
            height: root.height
            theme: root.theme 
        }
        
        // Panel 4: SETTINGS
        SettingsPanel { 
            id: settingsPanel
            width: root.width
            height: root.height
            theme: root.theme
            onNavigateTo: function(tab) { root.requestNavigation(tab) }
        }
    }
    
    property var theme
    signal requestNavigation(string tab)
}
