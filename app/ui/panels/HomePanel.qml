import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../components"
import Theme 1.0


Item {
    id: root
    width: parent ? parent.width : 500
    height: parent ? parent.height : 600
    
    signal navigateTo(string tab)

    // Readability layer - text never on raw wallpaper
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, Theme.readabilityOpacity)
        z: -1
    }

    // ═══════════════════════════════════════════════════════
    // HOME PANEL - Only 3 focused tiles
    // Primary focus: Status overview
    // ═══════════════════════════════════════════════════════

    Column {
        anchors.fill: parent
        anchors.leftMargin: Theme.padding
        anchors.rightMargin: Theme.padding
        anchors.topMargin: 20
        anchors.bottomMargin: 20
        spacing: 16
        
        // ─────────────────────────────────────────────────────
        // Tile 1: SYSTEM HEALTH
        // ─────────────────────────────────────────────────────
        GlassTile {
            width: parent.width
            height: 100
            
            title: "SYSTEM"
            value: "Nominal"
            subtitle: "CPU 12% · RAM 4.2 GB · 62°C"
            statusHint: "OK"
            icon: "../../assets/icons/vehicle.svg"
            uiScale: 1.0
        }
        
        // ─────────────────────────────────────────────────────
        // Tile 2: ASSISTANT STATUS
        // ─────────────────────────────────────────────────────
        GlassTile {
            width: parent.width
            height: 100
            
            title: "ASSISTANT"
            value: app && app.assistantState === "LISTENING" ? "Listening" 
                 : app && app.assistantState === "THINKING" ? "Processing"
                 : app && app.assistantState === "RESPONDING" ? "Speaking"
                 : "Standby"
            subtitle: app && app.assistantState !== "IDLE" 
                ? "Voice input active" 
                : "Click orb to activate"
            statusHint: app && app.assistantState !== "IDLE" ? "ACTIVE" : ""
            highlighted: app && app.assistantState !== "IDLE"
            icon: "../../assets/icons/mic.svg"
            uiScale: 1.0
            
            onClicked: {
                if (app.assistantState === "IDLE") {
                    app.request_listening()
                } else {
                    app.set_state("IDLE")
                }
            }
        }
        
        // ─────────────────────────────────────────────────────
        // Tile 3: NETWORK
        // ─────────────────────────────────────────────────────
        GlassTile {
            width: parent.width
            height: 100
            
            title: "NETWORK"
            value: "Online"
            subtitle: "Latency 18 ms · Cloud connected"
            statusHint: "STABLE"
            icon: "../../assets/icons/nav.svg"
            uiScale: 1.0
        }
        
        // Fill remaining space
        Item {
            width: parent.width
            Layout.fillHeight: true
        }
    }
}
