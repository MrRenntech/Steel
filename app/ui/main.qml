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
    title: "Steel OS v7.0"
    color: "black"
    
    // ═══════════════════════════════════════════════════════
    // NAVIGATION STATE (Single Source of Truth)
    // ═══════════════════════════════════════════════════════
    property string activeTab: "HOME"
    
    property var tabIndex: ({
        "HOME": 0,
        "ASSISTANT": 1,
        "SYSTEM": 2,
        "NETWORK": 3,
        "SETTINGS": 4
    })
    
    function navigateTo(tab) {
        if (tabIndex[tab] !== undefined) {
            activeTab = tab
        }
    }

    // ═══════════════════════════════════════════════════════
    // THEME MANAGER (Central Authority)
    // ═══════════════════════════════════════════════════════
    ThemeManager {
        id: themeManager
    }
    
    property alias theme: themeManager

    UIContext {
        id: ui
    }

    Component.onCompleted: ui.update(root)
    onWidthChanged: ui.update(root)
    onHeightChanged: ui.update(root)
    
    // Current time
    property string currentTime: ""
    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var now = new Date()
            currentTime = Qt.formatTime(now, "hh:mm")
        }
    }

    // ═══════════════════════════════════════════════════════
    // LAYER 0: BACKGROUND
    // ═══════════════════════════════════════════════════════
    BackgroundField {
        id: backgroundLayer
        anchors.fill: parent
        z: 0
        assistantState: (app && app.assistantState) ? app.assistantState : "IDLE"
        currentWallpaper: themeManager.wallpaperId
    }

    // ═══════════════════════════════════════════════════════
    // LAYER 1: MINIMAL TOP BAR (Brand + Time + Status)
    // No tabs. Maximum calm.
    // ═══════════════════════════════════════════════════════
    Rectangle {
        id: topBar
        height: 48
        width: parent.width
        anchors.top: parent.top
        anchors.left: sideRail.right
        anchors.right: parent.right
        z: 100

        color: Qt.rgba(10/255, 18/255, 28/255, 0.5)
        border.color: Qt.rgba(1,1,1,0.06)
        border.width: 1

        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: Qt.rgba(1,1,1,0.08)
        }

        // BRANDING (Left)
        Text {
            text: "STEEL"
            font.pixelSize: 14
            font.weight: Font.Bold
            color: Qt.rgba(1, 1, 1, 0.7)
            font.letterSpacing: 3.0
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 24
            font.family: themeManager.fontFamily
        }
        
        // TIME (Center)
        Text {
            text: currentTime
            font.pixelSize: 14
            font.weight: Font.Medium
            color: Qt.rgba(1, 1, 1, 0.8)
            font.letterSpacing: 1.0
            anchors.centerIn: parent
            font.family: themeManager.fontFamily
        }

        // STATUS (Right) - Just dot, no text
        Row {
            anchors.right: parent.right
            anchors.rightMargin: 24
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8
            
            Rectangle {
                width: 6
                height: 6
                radius: 3
                color: themeManager.colorSuccess
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Text {
                text: "ONLINE"
                font.pixelSize: 10
                color: Qt.rgba(1, 1, 1, 0.4)
                font.letterSpacing: 1.0
                font.family: themeManager.fontFamily
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    // ═══════════════════════════════════════════════════════
    // LAYER 1B: SIDE RAIL (Icon Navigation)
    // Slim, whispers navigation. 56px.
    // ═══════════════════════════════════════════════════════
    Rectangle {
        id: sideRail
        width: 56
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        z: 100
        
        color: Qt.rgba(8/255, 12/255, 18/255, 0.7)
        border.color: Qt.rgba(1,1,1,0.06)
        border.width: 1
        
        // Right edge line
        Rectangle {
            anchors.right: parent.right
            height: parent.height
            width: 1
            color: Qt.rgba(1,1,1,0.08)
        }
        
        Column {
            anchors.top: parent.top
            anchors.topMargin: 16
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 4
            
            // Logo at top
            Text {
                text: "S"
                font.pixelSize: 20
                font.weight: Font.Black
                color: Qt.rgba(1, 1, 1, 0.8)
                font.family: themeManager.fontFamily
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Item { width: 1; height: 24 }
            
            // Navigation icons
            Repeater {
                model: [
                    { tab: "HOME", icon: "⌂", label: "Home" },
                    { tab: "ASSISTANT", icon: "◉", label: "Assistant" },
                    { tab: "SYSTEM", icon: "⚙", label: "System" },
                    { tab: "NETWORK", icon: "◎", label: "Network" },
                    { tab: "SETTINGS", icon: "☰", label: "Settings" }
                ]
                
                delegate: Rectangle {
                    width: 44
                    height: 44
                    radius: themeManager.tileRadius / 2
                    color: root.activeTab === modelData.tab 
                        ? Qt.rgba(1, 1, 1, 0.12)
                        : hovered ? Qt.rgba(1, 1, 1, 0.06) : "transparent"
                    
                    property bool hovered: false
                    
                    Behavior on color { ColorAnimation { duration: 150 } }
                    
                    Text {
                        text: modelData.icon
                        font.pixelSize: 18
                        color: root.activeTab === modelData.tab 
                            ? Qt.rgba(1, 1, 1, 0.9)
                            : Qt.rgba(1, 1, 1, 0.5)
                        anchors.centerIn: parent
                        
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                    
                    // Hover tooltip
                    Rectangle {
                        id: tooltip
                        visible: parent.hovered
                        x: parent.width + 8
                        anchors.verticalCenter: parent.verticalCenter
                        width: tooltipText.implicitWidth + 16
                        height: 28
                        radius: 6
                        color: Qt.rgba(0, 0, 0, 0.8)
                        border.color: Qt.rgba(1,1,1,0.2)
                        
                        Text {
                            id: tooltipText
                            text: modelData.label
                            font.pixelSize: 11
                            color: Qt.rgba(1, 1, 1, 0.9)
                            anchors.centerIn: parent
                            font.family: themeManager.fontFamily
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: parent.hovered = true
                        onExited: parent.hovered = false
                        onClicked: root.navigateTo(modelData.tab)
                    }
                }
            }
        }
    }

    // ═══════════════════════════════════════════════════════
    // LAYER 2: MAIN CONTENT (StackLayout + AI Core)
    // ═══════════════════════════════════════════════════════
    Row {
        id: mainContent
        anchors.top: topBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: sideRail.right
        anchors.right: parent.right

        // LEFT: CONTENT STACK (65%)
        Rectangle {
            width: parent.width * 0.62
            height: parent.height
            color: "transparent"

            StackLayout {
                id: contentStack
                anchors.fill: parent
                currentIndex: tabIndex[activeTab] || 0

                // Panel 0: HOME (Simplified)
                HomePanel { 
                    theme: themeManager
                    onNavigateTo: function(tab) { root.navigateTo(tab) }
                }
                
                // Panel 1: ASSISTANT
                MediaPanel { theme: themeManager }
                
                // Panel 2: SYSTEM
                VehiclePanel { theme: themeManager }
                
                // Panel 3: NETWORK
                NavPanel { theme: themeManager }
                
                // Panel 4: SETTINGS
                SettingsPanel { 
                    theme: themeManager
                    onNavigateTo: function(tab) { root.navigateTo(tab) }
                }
            }
        }

        // RIGHT: ASSISTANT PRESENCE ONLY (38%)
        Rectangle {
            width: parent.width * 0.38
            height: parent.height
            color: "transparent"

            // Glass Container (subtle)
            Rectangle {
                anchors.fill: parent
                anchors.margins: 12
                anchors.bottomMargin: 0
                radius: themeManager.radiusPanel
                
                color: Qt.rgba(1, 1, 1, themeManager.glassOpacity * 0.5)
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, themeManager.glassBorder * 0.5)
                
                Behavior on radius { 
                    NumberAnimation { duration: themeManager.transitionNormal } 
                }
            }

            CoreVisual {
                id: core
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -40
                theme: themeManager
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
    // LAYER 4: OVERLAYS (Modal Panels)
    // ═══════════════════════════════════════════════════════
    WallpaperPanel {
        id: wallpaperPanel
        z: 200
        theme: themeManager
    }
    
    function openWallpaperPanel() {
        wallpaperPanel.show()
    }
}
