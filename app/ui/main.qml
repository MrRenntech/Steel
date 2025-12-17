import QtQuick
import QtQuick.Window
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"
import "panels"

Window {
    id: root
    width: 1280
    height: 800
    visible: true
    title: "Steel v6.4 Refactored"
    color: "black"
    property string activeTab: "CORE"
    property alias appTheme: theme

    // Theme Engine
    ThemeLoader {
        id: theme
    }

    UIContext {
        id: ui
    }

    Component.onCompleted: ui.update(root)
    onWidthChanged: ui.update(root)
    onHeightChanged: ui.update(root)

    // Background: Ambient Atmosphere (Light-leaning)
    BackgroundField {
        id: backgroundLayer
        anchors.fill: parent
        z: 0
        assistantState: (app && app.assistantState) ? app.assistantState : "IDLE"
        currentWallpaper: (app && app.currentWallpaper) ? app.currentWallpaper : "ambient_sky.png"
    }

    // New Glass Top Bar (Status Strip)
    Rectangle {
        id: topBar
        height: 64 // Thin strip
        width: parent.width
        anchors.top: parent.top
        z: 100 // Always on top

        color: Qt.rgba(10/255, 18/255, 28/255, 0.6) // Glassy
        border.color: Qt.rgba(1,1,1,0.08)
        border.width: 1

        // Horizontal Line at bottom
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: Qt.rgba(1,1,1,0.1)
        }

        // BRANDING
        Text {
            text: "STEEL"
            font.pixelSize: 18
            font.weight: Font.Black
            color: "white"
            opacity: 0.9
            font.letterSpacing: 4.0 // Corrected
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 32
            font.family: theme.fontFamily
        }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 160 // Shift tabs right
            spacing: 42

            Repeater {
                model: ["CORE", "INPUT", "SYSTEM", "NETWORK", "SETTINGS"]

                delegate: Item {
                    property bool active: root.activeTab === modelData
                    width: textItem.implicitWidth + 12
                    height: parent.height
                    
                    // Tab Label
                    Text {
                        id: textItem
                        text: modelData
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: -2
                        font.pixelSize: 13
                        font.bold: true
                        color: active ? "white" : "white"
                        opacity: active ? 1.0 : 0.4 // Fade inactive
                        font.letterSpacing: 2.0 // Automotive wide
                        font.family: theme.fontFamily
                    }

                    // Glow Underline
                    Rectangle {
                        width: active ? parent.width : 0
                        height: 2
                        radius: 1
                        anchors.bottom: parent.bottom
                        color: theme.accentColor
                        opacity: active ? 1.0 : 0.0
                        
                        // Fake Glow (Shadow)
                        Rectangle {
                            anchors.centerIn: parent
                            width: parent.width + 4
                            height: 6
                            radius: 3
                            color: theme.accentColor
                            opacity: 0.4
                        }

                        Behavior on width {
                            NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.activeTab = modelData
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }

        // Right-side Status
        Row {
            anchors.right: parent.right
            anchors.rightMargin: 32
            anchors.verticalCenter: parent.verticalCenter
            spacing: 24

            Text {
                text: Qt.formatDateTime(new Date(), "hh:mm")
                font.pixelSize: 14
                opacity: 0.8
                color: "white"
                font.family: theme.fontFamily
                font.bold: true
            }

            Rectangle {
                width: 1
                height: 12
                color: "white"
                opacity: 0.2
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: "ONLINE"
                font.pixelSize: 11
                color: theme.colorSuccess
                font.letterSpacing: 1.2
                font.family: theme.fontFamily
                // Subtle glow/pulse?
                font.bold: true
            }
        }
    }

    // ═══════════════════════════════════════════════════════
    // MAIN CONTENT AREA (Between Top Bar and Bottom Bar)
    // Split: 65% Left (Tiles) / 35% Right (AI Core)
    // ═══════════════════════════════════════════════════════
    Row {
        id: mainContent
        anchors.top: topBar.bottom
        anchors.bottom: bottomBar.top
        anchors.left: parent.left
        anchors.right: parent.right

        // LEFT CONTENT ZONE (65%)
        Rectangle {
            width: parent.width * 0.65
            height: parent.height
            color: "transparent"

            TabContainer {
                anchors.fill: parent
                activeTab: root.activeTab
                theme: theme
            }
        }

        // RIGHT AI CORE ZONE (35%)
        Rectangle {
            width: parent.width * 0.35
            height: parent.height
            color: "transparent"

            // Light Glass Container
            Rectangle {
                anchors.fill: parent
                anchors.margins: 16
                anchors.bottomMargin: 8
                radius: 28
                
                color: Qt.rgba(1, 1, 1, 0.06)
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, 0.15)
                
                // Shadow
                Rectangle {
                    anchors.fill: parent
                    anchors.topMargin: 6
                    anchors.leftMargin: 3
                    anchors.rightMargin: -3
                    anchors.bottomMargin: -10
                    radius: parent.radius + 4
                    color: Qt.rgba(0, 0, 0, 0.3)
                    z: -1
                }
            }

            CoreVisual {
                id: core
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -20
                theme: root.appTheme
                assistantState: (app && app.assistantState) ? app.assistantState : "IDLE"
                activeTab: root.activeTab
                audioLevel: (app && app.audioLevel) ? app.audioLevel : 0.0

                onClicked: {
                    if (app.assistantState === "IDLE") {
                        app.request_listening()
                    } else {
                        app.set_state("IDLE")
                    }
                }
            }
        }
    }

    // ═══════════════════════════════════════════════════════
    // BOTTOM CONTEXT BAR (Hints, Mic, Actions)
    // ═══════════════════════════════════════════════════════
    Rectangle {
        id: bottomBar
        height: 56
        width: parent.width
        anchors.bottom: parent.bottom
        z: 100
        
        color: Qt.rgba(10/255, 18/255, 28/255, 0.7)
        border.color: Qt.rgba(1, 1, 1, 0.08)
        border.width: 1
        
        // Top border line
        Rectangle {
            anchors.top: parent.top
            width: parent.width
            height: 1
            color: Qt.rgba(1, 1, 1, 0.1)
        }
        
        Row {
            anchors.fill: parent
            anchors.leftMargin: 32
            anchors.rightMargin: 32
            spacing: 24
            
            // Left: Context hint
            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2
                
                Text {
                    text: {
                        switch((app && app.assistantState) ? app.assistantState : "IDLE") {
                            case "LISTENING": return "Listening..."
                            case "THINKING": return "Processing request..."
                            case "RESPONDING": return "Speaking..."
                            default: return "Ready for input"
                        }
                    }
                    font.pixelSize: 13
                    font.weight: Font.Medium
                    color: Qt.rgba(1, 1, 1, 0.8)
                    font.family: theme.fontFamily
                }
                
                Text {
                    text: "Click orb or press Space to activate voice"
                    font.pixelSize: 10
                    color: Qt.rgba(1, 1, 1, 0.4)
                    font.family: theme.fontFamily
                }
            }
            
            Item { width: 1; Layout.fillWidth: true }
            
            // Right: Mic level indicator
            Row {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8
                
                // Mic bars
                Repeater {
                    model: 5
                    Rectangle {
                        width: 3
                        height: {
                            var level = (app && app.audioLevel) ? app.audioLevel : 0
                            var baseHeight = 8 + index * 4
                            return baseHeight * (0.3 + level * 0.7)
                        }
                        radius: 1.5
                        color: {
                            var level = (app && app.audioLevel) ? app.audioLevel : 0
                            return level > 0.3 ? Qt.rgba(0.4, 0.9, 1.0, 0.8) : Qt.rgba(1, 1, 1, 0.3)
                        }
                        anchors.verticalCenter: parent.verticalCenter
                        
                        Behavior on height { NumberAnimation { duration: 50 } }
                        Behavior on color { ColorAnimation { duration: 100 } }
                    }
                }
                
                Text {
                    text: "MIC"
                    font.pixelSize: 9
                    font.letterSpacing: 1.0
                    color: Qt.rgba(1, 1, 1, 0.4)
                    font.family: theme.fontFamily
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            
            // Separator
            Rectangle {
                width: 1
                height: 24
                color: Qt.rgba(1, 1, 1, 0.15)
                anchors.verticalCenter: parent.verticalCenter
            }
            
            // Version
            Text {
                text: "v6.5"
                font.pixelSize: 10
                color: Qt.rgba(1, 1, 1, 0.3)
                font.family: theme.fontFamily
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    // ═══════════════════════════════════════════════════════
    // WALLPAPER PANEL OVERLAY
    // ═══════════════════════════════════════════════════════
    WallpaperPanel {
        id: wallpaperPanel
        z: 200
        theme: root.appTheme
    }
    
    // Function to open wallpaper panel (call from settings tile)
    function openWallpaperPanel() {
        wallpaperPanel.show()
    }

}
