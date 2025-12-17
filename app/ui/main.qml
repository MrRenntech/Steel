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
    title: "Steel OS v6.8"
    color: "black"
    
    // ═══════════════════════════════════════════════════════
    // NAVIGATION STATE (Single Source of Truth)
    // ═══════════════════════════════════════════════════════
    property string activeTab: "HOME"
    
    // Navigation index mapping
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
    
    // Alias for components
    property alias theme: themeManager

    UIContext {
        id: ui
    }

    Component.onCompleted: ui.update(root)
    onWidthChanged: ui.update(root)
    onHeightChanged: ui.update(root)

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
    // LAYER 1: TOP BAR (Navigation)
    // ═══════════════════════════════════════════════════════
    Rectangle {
        id: topBar
        height: 64
        width: parent.width
        anchors.top: parent.top
        z: 100

        color: Qt.rgba(10/255, 18/255, 28/255, 0.6)
        border.color: Qt.rgba(1,1,1,0.08)
        border.width: 1

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
            font.letterSpacing: 4.0
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 32
            font.family: themeManager.fontFamily
        }

        // NAVIGATION TABS
        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 160
            spacing: 42

            Repeater {
                model: ["HOME", "ASSISTANT", "SYSTEM", "NETWORK", "SETTINGS"]

                delegate: Item {
                    property bool active: root.activeTab === modelData
                    width: textItem.implicitWidth + 12
                    height: topBar.height
                    
                    Text {
                        id: textItem
                        text: modelData
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: -2
                        font.pixelSize: 13
                        font.bold: true
                        font.letterSpacing: 1.2
                        color: active ? themeManager.primaryColor : Qt.rgba(1,1,1,0.5)
                        font.family: themeManager.fontFamily
                        
                        Behavior on color { 
                            ColorAnimation { duration: themeManager.transitionFast } 
                        }
                    }
                    
                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width
                        height: 2
                        color: themeManager.accentColor
                        opacity: active ? 1 : 0
                        
                        Behavior on opacity { 
                            NumberAnimation { duration: themeManager.transitionFast } 
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.navigateTo(modelData)
                    }
                }
            }
        }

        // STATUS
        Row {
            anchors.right: parent.right
            anchors.rightMargin: 32
            anchors.verticalCenter: parent.verticalCenter
            spacing: 12
            
            Rectangle {
                width: 8
                height: 8
                radius: 4
                color: themeManager.colorSuccess
            }
            
            Text {
                text: "ONLINE"
                font.pixelSize: 11
                color: themeManager.colorSuccess
                font.letterSpacing: 1.2
                font.family: themeManager.fontFamily
                font.bold: true
            }
        }
    }

    // ═══════════════════════════════════════════════════════
    // LAYER 2: MAIN CONTENT (StackLayout + AI Core)
    // ═══════════════════════════════════════════════════════
    Row {
        id: mainContent
        anchors.top: topBar.bottom
        anchors.bottom: bottomBar.top
        anchors.left: parent.left
        anchors.right: parent.right

        // LEFT: CONTENT STACK (65%)
        Rectangle {
            width: parent.width * 0.65
            height: parent.height
            color: "transparent"

            StackLayout {
                id: contentStack
                anchors.fill: parent
                currentIndex: tabIndex[activeTab] || 0

                // Panel 0: HOME
                AssistantPanel { 
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

        // RIGHT: AI CORE ZONE (35%)
        Rectangle {
            width: parent.width * 0.35
            height: parent.height
            color: "transparent"

            // Glass Container
            Rectangle {
                anchors.fill: parent
                anchors.margins: 16
                anchors.bottomMargin: 8
                radius: themeManager.radiusPanel
                
                color: Qt.rgba(1, 1, 1, themeManager.glassOpacity)
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, themeManager.glassBorder)
                
                Behavior on radius { 
                    NumberAnimation { duration: themeManager.transitionNormal } 
                }
                
                // Shadow
                Rectangle {
                    anchors.fill: parent
                    anchors.topMargin: 6
                    anchors.leftMargin: 3
                    anchors.rightMargin: -3
                    anchors.bottomMargin: -10
                    radius: parent.radius + 4
                    color: Qt.rgba(0, 0, 0, themeManager.glassShadow)
                    z: -1
                }
            }

            CoreVisual {
                id: core
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -20
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
    // LAYER 3: BOTTOM CONTEXT BAR
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
            
            // Context hint
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
                    font.family: themeManager.fontFamily
                }
                
                Text {
                    text: "Click orb or press Space to activate voice"
                    font.pixelSize: 10
                    color: Qt.rgba(1, 1, 1, 0.4)
                    font.family: themeManager.fontFamily
                }
            }
            
            Item { width: 1; Layout.fillWidth: true }
            
            // Mic level indicator
            Row {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8
                
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
                            return level > 0.3 ? themeManager.accentColor : Qt.rgba(1, 1, 1, 0.3)
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
                    font.family: themeManager.fontFamily
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            
            Rectangle {
                width: 1
                height: 24
                color: Qt.rgba(1, 1, 1, 0.15)
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Text {
                text: "v6.8"
                font.pixelSize: 10
                color: Qt.rgba(1, 1, 1, 0.3)
                font.family: themeManager.fontFamily
                anchors.verticalCenter: parent.verticalCenter
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
