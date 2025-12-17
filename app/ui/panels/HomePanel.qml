import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../components"

Item {
    id: root
    width: parent ? parent.width : 500
    height: parent ? parent.height : 600
    property var theme
    
    signal navigateTo(string tab)

    // Readability layer - text never on raw wallpaper
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, theme ? theme.readabilityOpacity : 0.22)
        z: -1
    }

    // ═══════════════════════════════════════════════════════
    // HOME PANEL - Only 3 focused tiles
    // Primary focus: Status overview
    // ═══════════════════════════════════════════════════════

    Column {
        anchors.fill: parent
        anchors.leftMargin: theme ? theme.padding : 24
        anchors.rightMargin: theme ? theme.padding : 24
        anchors.topMargin: 20
        anchors.bottomMargin: 20
        spacing: 16
        
        // ─────────────────────────────────────────────────────
        // Tile 1: SYSTEM HEALTH
        // ─────────────────────────────────────────────────────
        GlassTile {
            width: parent.width
            height: 100
            theme: root.theme
            
            title: "SYSTEM"
            value: "Nominal"
            subtitle: "CPU 12% · RAM 4.2 GB · 62°C"
            statusHint: "OK"
            icon: "../../assets/icons/vehicle.svg"
            uiScale: ui.scale
        }
        
        // ─────────────────────────────────────────────────────
        // Tile 2: ASSISTANT STATUS
        // ─────────────────────────────────────────────────────
        GlassTile {
            width: parent.width
            height: 100
            theme: root.theme
            
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
            uiScale: ui.scale
            
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
            theme: root.theme
            
            title: "NETWORK"
            value: "Online"
            subtitle: "Latency 18 ms · Cloud connected"
            statusHint: "STABLE"
            icon: "../../assets/icons/nav.svg"
            uiScale: ui.scale
        }
        
        // Fill remaining space
        Item {
            width: parent.width
            Layout.fillHeight: true
        }
    }
}
