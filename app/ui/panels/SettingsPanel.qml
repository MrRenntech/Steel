import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../components"
import Theme 1.0


Item {
    id: root
    width: parent ? parent.width : 500
    height: parent ? parent.height : 600
    
    // Active section
    property string activeSection: "appearance"
    
    // Navigation signal
    signal navigateTo(string tab)

    // ═══════════════════════════════════════════════════════
    // SETTINGS PANEL - Premium Nested Layout
    // ═══════════════════════════════════════════════════════

    Row {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 24

        // ─────────────────────────────────────────────────────
        // LEFT: Settings Navigation (Sidebar)
        // ─────────────────────────────────────────────────────
        Rectangle {
            id: sidebar
            width: 180
            height: parent.height
            radius: 16
            color: Qt.rgba(1, 1, 1, 0.04)
            border.color: Qt.rgba(1, 1, 1, 0.1)
            
            Column {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 4
                
                // Back button
                Rectangle {
                    width: parent.width
                    height: 40
                    radius: 8
                    color: Qt.rgba(1, 1, 1, 0.08)
                    border.color: Qt.rgba(1, 1, 1, 0.15)
                    
                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        spacing: 8
                        
                        Text {
                            text: "←"
                            font.pixelSize: 16
                            color: Qt.rgba(1, 1, 1, 0.8)
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        Text {
                            text: "Back to Home"
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            color: Qt.rgba(1, 1, 1, 0.8)
                            font.family: FontRegistry.current.name
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.navigateTo("HOME")
                    }
                }
                
                // Spacer
                Item { width: 1; height: 8 }
                
                // Section header
                Text {
                    text: "SETTINGS"
                    font.pixelSize: 10
                    font.weight: Font.Medium
                    font.letterSpacing: 1.4
                    color: Qt.rgba(1, 1, 1, 0.4)
                    font.family: FontRegistry.current.name
                    bottomPadding: 12
                }
                
                // Navigation items
                Repeater {
                    model: [
                        { id: "appearance", label: "Appearance", icon: "🎨" },
                        { id: "audio", label: "Audio", icon: "🔊" },
                        { id: "privacy", label: "Privacy", icon: "🔒" },
                        { id: "about", label: "About", icon: "ℹ️" }
                    ]
                    
                    Rectangle {
                        width: parent.width
                        height: 40
                        radius: 8
                        color: activeSection === modelData.id 
                            ? Qt.rgba(1, 1, 1, 0.12) 
                            : "transparent"
                        
                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            spacing: 10
                            
                            Text {
                                text: modelData.icon
                                font.pixelSize: 14
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            
                            Text {
                                text: modelData.label
                                font.pixelSize: 13
                                font.weight: activeSection === modelData.id ? Font.Medium : Font.Normal
                                color: activeSection === modelData.id 
                                    ? Qt.rgba(1, 1, 1, 0.95)
                                    : Qt.rgba(1, 1, 1, 0.6)
                                font.family: FontRegistry.current.name
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: activeSection = modelData.id
                        }
                    }
                }
            }
        }

        // ─────────────────────────────────────────────────────
        // RIGHT: Settings Content Area
        // ─────────────────────────────────────────────────────
        Rectangle {
            id: contentArea
            width: parent.width - sidebar.width - 24
            height: parent.height
            radius: 20
            color: Qt.rgba(1, 1, 1, 0.06)
            border.color: Qt.rgba(1, 1, 1, 0.12)
            
            // Shadow
            Rectangle {
                anchors.fill: parent
                anchors.topMargin: 6
                anchors.leftMargin: 3
                anchors.rightMargin: -3
                anchors.bottomMargin: -8
                radius: parent.radius + 4
                color: Qt.rgba(0, 0, 0, 0.25)
                z: -1
            }
            
            // Content loader
            Loader {
                anchors.fill: parent
                anchors.margins: 24
                sourceComponent: {
                    switch(activeSection) {
                        case "appearance": return appearanceSection
                        case "audio": return audioSection
                        case "privacy": return privacySection
                        case "about": return aboutSection
                        default: return appearanceSection
                    }
                }
            }
        }
    }

    // ═══════════════════════════════════════════════════════
    // APPEARANCE SECTION (Theme + Wallpaper)
    // ═══════════════════════════════════════════════════════
    Component {
        id: appearanceSection
        
        Column {
            spacing: 24
            
            // Header
            Column {
                spacing: 4
                Text {
                    text: "APPEARANCE"
                    font.pixelSize: 10
                    font.weight: Font.Medium
                    font.letterSpacing: 1.4
                    color: Qt.rgba(1, 1, 1, 0.4)
                    font.family: FontRegistry.current.name
                }
                Text {
                    text: "Customize your environment"
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                    color: Qt.rgba(1, 1, 1, 0.9)
                    font.family: FontRegistry.current.name
                }
            }
            
            // Theme Selection
            Column {
                spacing: 12
                width: parent.width
                
                Text {
                    text: "Theme"
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    color: Qt.rgba(1, 1, 1, 0.7)
                    font.family: FontRegistry.current.name
                }
                
                Row {
                    spacing: 12
                    
                    // BMW Theme option
                    Rectangle {
                        width: 120
                        height: 80
                        radius: 12
                        color: Theme.activeThemeId === "bmw" 
                            ? Qt.rgba(0.4, 0.9, 1.0, 0.15) 
                            : Qt.rgba(1, 1, 1, 0.06)
                        border.width: Theme.activeThemeId === "bmw" ? 2 : 1
                        border.color: Theme.activeThemeId === "bmw" 
                            ? Qt.rgba(0.4, 0.9, 1.0, 0.6)
                            : Qt.rgba(1, 1, 1, 0.15)
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 4
                            Text {
                                text: "BMW"
                                font.pixelSize: 14
                                font.weight: Font.Medium
                                color: Qt.rgba(1, 1, 1, 0.9)
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.family: FontRegistry.current.name
                            }
                            Text {
                                text: "Soft, organic"
                                font.pixelSize: 9
                                color: Qt.rgba(1, 1, 1, 0.5)
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.family: FontRegistry.current.name
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Theme.applyTheme("bmw")
                        }
                    }

                    // AUDI Theme option
                    Rectangle {
                        width: 120
                        height: 80
                        radius: 12
                        color: Theme.activeThemeId === "audi" 
                            ? Qt.rgba(0.4, 0.9, 1.0, 0.15) 
                            : Qt.rgba(1, 1, 1, 0.06)
                        border.width: Theme.activeThemeId === "audi" ? 2 : 1
                        border.color: Theme.activeThemeId === "audi" 
                            ? Qt.rgba(0.4, 0.9, 1.0, 0.6)
                            : Qt.rgba(1, 1, 1, 0.15)
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 4
                            Text {
                                text: "AUDI"
                                font.pixelSize: 14
                                font.weight: Font.Medium
                                color: Qt.rgba(1, 1, 1, 0.9)
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.family: FontRegistry.current.name
                            }
                            Text {
                                text: "Sharp, technical"
                                font.pixelSize: 9
                                color: Qt.rgba(1, 1, 1, 0.5)
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.family: FontRegistry.current.name
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Theme.applyTheme("audi")
                        }
                    }

                    // BENTLEY Theme option
                    Rectangle {
                        width: 120
                        height: 80
                        radius: 12
                        color: Theme.activeThemeId === "bentley" 
                            ? Qt.rgba(0.4, 0.9, 1.0, 0.15) 
                            : Qt.rgba(1, 1, 1, 0.06)
                        border.width: Theme.activeThemeId === "bentley" ? 2 : 1
                        border.color: Theme.activeThemeId === "bentley" 
                            ? Qt.rgba(0.4, 0.9, 1.0, 0.6)
                            : Qt.rgba(1, 1, 1, 0.15)
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 4
                            Text {
                                text: "BENTLEY"
                                font.pixelSize: 14
                                font.weight: Font.Medium
                                color: Qt.rgba(1, 1, 1, 0.9)
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.family: FontRegistry.current.name
                            }
                            Text {
                                text: "Elegant, luxurious"
                                font.pixelSize: 9
                                color: Qt.rgba(1, 1, 1, 0.5)
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.family: FontRegistry.current.name
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Theme.applyTheme("bentley")
                        }
                    }
                }
            }
            
            // Wallpaper Selection
            Column {
                spacing: 12
                width: parent.width
                
                Text {
                    text: "Wallpaper"
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    color: Qt.rgba(1, 1, 1, 0.7)
                    font.family: FontRegistry.current.name
                }
                
                Flow {
                    width: parent.width
                    spacing: 12
                    
                    Repeater {
                        model: WallpaperModel {}
                        
                        delegate: Rectangle {
                            width: 140
                            height: 80
                            radius: 12
                            color: "transparent"
                            border.width: Theme.activeWallpaperId === model.source ? 2 : 1
                            border.color: Theme.activeWallpaperId === model.source 
                                ? Theme.accentColor 
                                : Qt.rgba(1, 1, 1, 0.1)
                            
                            // Real Preview Image
                            Image {
                                anchors.fill: parent
                                anchors.margins: 4
                                source: "../../assets/wallpapers/" + model.source
                                fillMode: Image.PreserveAspectCrop
                                opacity: 1.0
                            }
                            
                            // Label Overlay
                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: 4
                                radius: 8
                                color: "transparent"
                                gradient: Gradient {
                                    GradientStop { position: 0.6; color: "transparent" }
                                    GradientStop { position: 1.0; color: Qt.rgba(0,0,0,0.7) }
                                }
                            }
                            
                            // Label
                            Text {
                                text: model.name
                                font.pixelSize: 10
                                font.weight: Font.Medium
                                color: "#FFFFFF"
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.margins: 8
                                font.family: FontRegistry.current.name
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Theme.setWallpaper(model.source)
                            }
                        }
                    }
                }
            }
            
            // Font Selection
            Column {
                spacing: 12
                width: parent.width
                
                Text {
                    text: "Font"
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    color: Qt.rgba(1, 1, 1, 0.7)
                    font.family: FontRegistry.current.name
                }
                
                Row {
                    spacing: 12
                    
                    // BMW Font (Inter)
                    Rectangle {
                        width: 100
                        height: 60
                        radius: 8
                        color: Theme.activeThemeId === "bmw"
                            ? Qt.rgba(0.4, 0.9, 1.0, 0.15) 
                            : Qt.rgba(1, 1, 1, 0.06)
                        border.width: Theme.activeThemeId === "bmw" ? 2 : 1
                        border.color: Theme.activeThemeId === "bmw"
                            ? Qt.rgba(0.4, 0.9, 1.0, 0.6)
                            : Qt.rgba(1, 1, 1, 0.15)
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 2
                            Text {
                                text: "Inter"
                                font.pixelSize: 14
                                font.weight: Font.Medium
                                font.family: FontRegistry.current.name
                                color: Qt.rgba(1, 1, 1, 0.9)
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Text {
                                text: "BMW"
                                font.pixelSize: 9
                                color: Qt.rgba(1, 1, 1, 0.5)
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Theme.applyTheme("bmw")
                        }
                    }
                    
                    // Audi Font (Montserrat)
                    Rectangle {
                        width: 100
                        height: 60
                        radius: 8
                        color: Theme.activeThemeId === "audi"
                            ? Qt.rgba(0.4, 0.9, 1.0, 0.15) 
                            : Qt.rgba(1, 1, 1, 0.06)
                        border.width: Theme.activeThemeId === "audi" ? 2 : 1
                        border.color: Theme.activeThemeId === "audi"
                            ? Qt.rgba(0.4, 0.9, 1.0, 0.6)
                            : Qt.rgba(1, 1, 1, 0.15)
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 2
                            Text {
                                text: "Montserrat"
                                font.pixelSize: 12
                                font.weight: Font.Light
                                font.family: FontRegistry.current.name
                                color: Qt.rgba(1, 1, 1, 0.9)
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Text {
                                text: "AUDI"
                                font.pixelSize: 9
                                color: Qt.rgba(1, 1, 1, 0.5)
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Theme.applyTheme("audi")
                        }
                    }

                    // Bentley Font (Playfair Display)
                    Rectangle {
                        width: 100
                        height: 60
                        radius: 8
                        color: Theme.activeThemeId === "bentley"
                            ? Qt.rgba(0.4, 0.9, 1.0, 0.15) 
                            : Qt.rgba(1, 1, 1, 0.06)
                        border.width: Theme.activeThemeId === "bentley" ? 2 : 1
                        border.color: Theme.activeThemeId === "bentley"
                            ? Qt.rgba(0.4, 0.9, 1.0, 0.6)
                            : Qt.rgba(1, 1, 1, 0.15)
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 2
                            Text {
                                text: "Playfair"
                                font.pixelSize: 14
                                font.weight: Font.Normal
                                font.family: FontRegistry.current.name
                                color: Qt.rgba(1, 1, 1, 0.9)
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Text {
                                text: "BENTLEY"
                                font.pixelSize: 9
                                color: Qt.rgba(1, 1, 1, 0.5)
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Theme.applyTheme("bentley")
                        }
                    }
                }
            }
        }
    }
    
    // ═══════════════════════════════════════════════════════
    // AUDIO SECTION
    // ═══════════════════════════════════════════════════════
    Component {
        id: audioSection
        
        Column {
            spacing: 24
            
            Column {
                spacing: 4
                Text {
                    text: "AUDIO"
                    font.pixelSize: 10
                    font.weight: Font.Medium
                    font.letterSpacing: 1.4
                    color: Qt.rgba(1, 1, 1, 0.4)
                    font.family: FontRegistry.current.name
                }
                Text {
                    text: "Sound and voice settings"
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                    color: Qt.rgba(1, 1, 1, 0.9)
                    font.family: FontRegistry.current.name
                }
            }
            
            Text {
                text: "Audio settings coming soon"
                font.pixelSize: 13
                color: Qt.rgba(1, 1, 1, 0.5)
                font.family: FontRegistry.current.name
            }
        }
    }

    // ═══════════════════════════════════════════════════════
    // PRIVACY SECTION
    // ═══════════════════════════════════════════════════════
    Component {
        id: privacySection
        
        Column {
            spacing: 24
            
            Column {
                spacing: 4
                Text {
                    text: "PRIVACY"
                    font.pixelSize: 10
                    font.weight: Font.Medium
                    font.letterSpacing: 1.4
                    color: Qt.rgba(1, 1, 1, 0.4)
                    font.family: FontRegistry.current.name
                }
                Text {
                    text: "Data and security"
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                    color: Qt.rgba(1, 1, 1, 0.9)
                    font.family: FontRegistry.current.name
                }
            }
            
            Text {
                text: "Privacy settings coming soon"
                font.pixelSize: 13
                color: Qt.rgba(1, 1, 1, 0.5)
                font.family: FontRegistry.current.name
            }
        }
    }

    // ═══════════════════════════════════════════════════════
    // ABOUT SECTION
    // ═══════════════════════════════════════════════════════
    Component {
        id: aboutSection
        
        Column {
            spacing: 24
            
            Column {
                spacing: 4
                Text {
                    text: "ABOUT"
                    font.pixelSize: 10
                    font.weight: Font.Medium
                    font.letterSpacing: 1.4
                    color: Qt.rgba(1, 1, 1, 0.4)
                    font.family: FontRegistry.current.name
                }
                Text {
                    text: "Steel OS"
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                    color: Qt.rgba(1, 1, 1, 0.9)
                    font.family: FontRegistry.current.name
                }
            }
            
            Column {
                spacing: 8
                
                Row {
                    spacing: 12
                    Text {
                        text: "Version"
                        font.pixelSize: 12
                        color: Qt.rgba(1, 1, 1, 0.5)
                        font.family: FontRegistry.current.name
                        width: 100
                    }
                    Text {
                        text: "6.6"
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        color: Qt.rgba(1, 1, 1, 0.9)
                        font.family: FontRegistry.current.name
                    }
                }
                
                Row {
                    spacing: 12
                    Text {
                        text: "AI Engine"
                        font.pixelSize: 12
                        color: Qt.rgba(1, 1, 1, 0.5)
                        font.family: FontRegistry.current.name
                        width: 100
                    }
                    Text {
                        text: "Google Gemini 1.5 Pro"
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        color: Qt.rgba(1, 1, 1, 0.9)
                        font.family: FontRegistry.current.name
                    }
                }
                
                Row {
                    spacing: 12
                    Text {
                        text: "Framework"
                        font.pixelSize: 12
                        color: Qt.rgba(1, 1, 1, 0.5)
                        font.family: FontRegistry.current.name
                        width: 100
                    }
                    Text {
                        text: "PySide6 / Qt 6"
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        color: Qt.rgba(1, 1, 1, 0.9)
                        font.family: FontRegistry.current.name
                    }
                }
            }
        }
    }
}
