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

    
    // Map tab names to index
    property var tabIndex: {
        "HOME": 0,
        "ASSISTANT": 1,
        "SYSTEM": 2,
        "NETWORK": 3,
        "SETTINGS": 4
    }

    StackLayout {
        id: contentStack
        anchors.fill: parent
        currentIndex: tabIndex[activeTab] || 0
        
        // Panel 0: HOME (Simplified)
        HomePanel { 
            width: root.width
            height: root.height
            onNavigateTo: function(tab) { root.requestNavigation(tab) }
        }
        
        // Panel 1: ASSISTANT (AI Focus)
        MediaPanel { 
            width: root.width
            height: root.height
        }
        
        // Panel 2: SYSTEM
        VehiclePanel { 
            width: root.width
            height: root.height
        }
        
        // Panel 3: NETWORK
        NavPanel { 
            width: root.width
            height: root.height
        }
        
        // Panel 4: SETTINGS
        SettingsPanel { 
            id: settingsPanel
            width: root.width
            height: root.height
            onNavigateTo: function(tab) { root.requestNavigation(tab) }
        }
    }
    
    signal requestNavigation(string tab)
}
