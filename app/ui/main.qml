import QtQuick
import QtQuick.Window
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"
import "panels"
import Theme 1.0


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
    property bool assistantActive: (app && app.assistantState) ? app.assistantState !== "IDLE" : false
    
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

    UIContext {
        id: ui
    }
    
    // Global Theme is now accessed via 'Theme' singleton


    Component.onCompleted: ui.update(root)
    onWidthChanged: ui.update(root)
    onHeightChanged: ui.update(root)
    
    // Current time



    // ═══════════════════════════════════════════════════════
    // LAYER 0: BACKGROUND
    // ═══════════════════════════════════════════════════════
    BackgroundField {
        id: backgroundLayer
        anchors.fill: parent
        z: 0
        assistantState: (app && app.assistantState) ? app.assistantState : "IDLE"
        currentWallpaper: Theme.wallpapers[Theme.activeWallpaperId] ? Theme.wallpapers[Theme.activeWallpaperId].source : "ambient_sky.png"
    }

    // ═══════════════════════════════════════════════════════
    // LAYER 1: MINIMAL TOP BAR (Brand + Time + Status)
    // No tabs. Maximum calm.
    // ═══════════════════════════════════════════════════════
    Rectangle {
        id: topBar
        width: parent.width
        height: 60
        color: "transparent"
        z: 10
        

        
        // Time (Center)
        // Time (Center)
        Row {
            anchors.centerIn: parent
            spacing: 8
            
            Text {
                id: timeDisplay
                text: Qt.formatTime(new Date(), "h:mm")
                color: Theme.textPrimary
                font.pixelSize: 16
                font.weight: Font.Medium
                font.family: FontRegistry.current.name
                
                Timer {
                    interval: 1000 * 60 // Update every minute
                    running: true
                    repeat: true
                    onTriggered: parent.text = Qt.formatTime(new Date(), "h:mm")
                }
            }
            
            Text {
                text: "24°C" // Static for now, as requested "add tiny weather"
                color: Theme.textSecondary
                font.pixelSize: 12
                font.weight: Font.Medium
                font.family: FontRegistry.current.name
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 1 // Optical alignment
                opacity: 0.8
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
                font.family: FontRegistry.current.name
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
                    radius: Theme.tileRadius / 2
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
                            font.family: FontRegistry.current.name
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
        
        // Behavior: Retreats when Assistant is Active
        opacity: assistantActive ? 0.0 : 1.0
        scale: assistantActive ? 0.96 : 1.0
        Behavior on opacity { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
        
        // Disable interaction when hidden
        visible: opacity > 0.01

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
                    onNavigateTo: function(tab) { root.navigateTo(tab) }
                }
                
                // Panel 1: ASSISTANT
                MediaPanel { }
                
                // Panel 2: SYSTEM
                VehiclePanel { }
                
                // Panel 3: NETWORK
                NavPanel { }
                
                // Panel 4: SETTINGS
                SettingsPanel { 
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
                radius: Theme.radiusPanel
                
                color: Qt.rgba(1, 1, 1, Theme.glassOpacity * 0.5)
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, Theme.glassBorder * 0.5)
                
                Behavior on radius { 
                    NumberAnimation { duration: Theme.transitionNormal } 
                }
            }

        }
    }

    // ═══════════════════════════════════════════════════════
    // LAYER 2.5: ASSISTANT OVERLAY (Fullscreen Dimmer)
    // ═══════════════════════════════════════════════════════
    Rectangle {
        id: assistantOverlay
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.35)
        opacity: assistantActive ? 1.0 : 0.0
        visible: opacity > 0.01
        z: 300 // Above content, below Orb
        
        Behavior on opacity { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
        
        // Block interaction with dashboard
        MouseArea {
            anchors.fill: parent
            enabled: parent.visible
        }
    }

    // ═══════════════════════════════════════════════════════
    // LAYER 3: ASSISTANT ORB (Global Overlay)
    // ═══════════════════════════════════════════════════════
    CoreVisual {
        id: core
        z: 500
        
        // Scale: Bigger when active (1.3x)
        scale: assistantActive ? 1.3 : 1.0
        Behavior on scale { NumberAnimation { duration: 500; easing.type: Easing.InOutQuart } }
        
        // POSITIONING LOGIC
        // Active: Absolute Center
        // Idle: Center of Right Panel (Right Panel width is 38% of parent)
        // Right Panel center X from parent left = contentStack width (62%) + (38% / 2) = 81%
        
        property real centerX: parent.width / 2
        property real centerY: parent.height / 2
        
        property real idleX: (parent.width * 0.62) + (parent.width * 0.38 * 0.5)
        property real idleY: parent.height / 2 - 40 // Matches previous offset
        
        x: (assistantActive ? centerX : idleX) - (width / 2)
        y: (assistantActive ? centerY : idleY) - (height / 2)
        
        Behavior on x { NumberAnimation { duration: 500; easing.type: Easing.InOutQuart } }
        Behavior on y { NumberAnimation { duration: 500; easing.type: Easing.InOutQuart } }

        assistantState: (app && app.assistantState) ? app.assistantState : "IDLE"
        // Bind to partialTranscript for live content
        assistantText: (app && app.partialTranscript) ? app.partialTranscript : "" 
        
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

    // ═══════════════════════════════════════════════════════
    // LAYER 4: OVERLAYS (Modal Panels)
    // ═══════════════════════════════════════════════════════
    WallpaperPanel {
        id: wallpaperPanel
        z: 200
    }
    
    function openWallpaperPanel() {
        wallpaperPanel.show()
    }
}
