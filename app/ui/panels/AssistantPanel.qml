import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../components"
import Theme 1.0

Item {
    id: root
    width: parent ? parent.width : 500
    height: parent ? parent.height : 600
    
    // Navigation signal
    signal navigateTo(string tab)

    // ═══════════════════════════════════════════════════════
    // HOME DASHBOARD - System Information Grid
    // ═══════════════════════════════════════════════════════

    GridLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.padding
        anchors.rightMargin: Theme.padding
        anchors.topMargin: 12
        anchors.bottomMargin: 12
        columns: 2
        rowSpacing: 12
        columnSpacing: 12
        
        // ─────────────────────────────────────────────────────
        // PRIMARY STATUS CLUSTER (2x2)
        // ─────────────────────────────────────────────────────
        
        GlassTile {
            Layout.fillWidth: true
            Layout.preferredHeight: 110
            title: "COGNITIVE CORE"
            value: "Active"
            subtitle: "Neural engine online"
            statusHint: "RUNNING"
            icon: "../../assets/icons/settings.svg"
            uiScale: ui.scale
        }

        GlassTile {
            Layout.fillWidth: true
            Layout.preferredHeight: 110
            title: "VOICE INTERFACE"
            value: app && app.assistantState === "LISTENING" ? "Listening" : "Standby"
            subtitle: app && app.assistantState === "LISTENING" ? "Audio streaming" : "Awaiting activation"
            statusHint: app && app.assistantState === "LISTENING" ? "LIVE" : ""
            highlighted: app && app.assistantState === "LISTENING"
            icon: "../../assets/icons/mic.svg"
            uiScale: ui.scale
        }

        GlassTile {
            Layout.fillWidth: true
            Layout.preferredHeight: 110
            title: "RUNTIME"
            value: "Nominal"
            subtitle: "CPU 12% · RAM 4.2 GB"
            statusHint: "OK"
            icon: "../../assets/icons/vehicle.svg"
            uiScale: ui.scale

        }

        GlassTile {
            Layout.fillWidth: true
            Layout.preferredHeight: 110
            title: "CONNECTIVITY"
            value: "Online"
            subtitle: "Latency 18 ms"
            statusHint: "STABLE"
            icon: "../../assets/icons/nav.svg"
            uiScale: ui.scale

        }

        // ─────────────────────────────────────────────────────
        // SECONDARY STATUS (Full-width context tiles)
        // ─────────────────────────────────────────────────────
        
        GlassTile {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            Layout.preferredHeight: 72
            
            title: "INTERACTION LOG"
            value: (app && app.last_intent) ? app.last_intent : "No recent commands"
            subtitle: (app && app.last_intent) ? "Processed successfully" : "Voice or keyboard ready"
            icon: "../../assets/icons/mic.svg"
            uiScale: ui.scale

        }
        
        GlassTile {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            Layout.preferredHeight: 72
            
            title: "TASK MONITOR"
            value: "System idle"
            subtitle: "No background operations"
            icon: "../../assets/icons/settings.svg"
            uiScale: ui.scale

        }
        
        GlassTile {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            Layout.preferredHeight: 72
            
            title: "SETTINGS"
            value: "Appearance & Themes"
            subtitle: "Wallpaper, themes, preferences"
            statusHint: "CUSTOMIZE"
            icon: "../../assets/icons/settings.svg"
            uiScale: ui.scale

            
            onClicked: root.navigateTo("SETTINGS")
        }
        
        // Breathing room
        Item {
            Layout.fillHeight: true
            Layout.columnSpan: 2
        }
    }
}
