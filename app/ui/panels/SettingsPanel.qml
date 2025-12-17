import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../components"

Item {
    id: root
    width: parent ? parent.width : 500
    height: parent ? parent.height : 600
    property var theme
    
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
                            font.family: theme ? theme.fontFamily : "Segoe UI"
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
                    font.family: theme ? theme.fontFamily : "Segoe UI"
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
                                font.family: theme ? theme.fontFamily : "Segoe UI"
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
                    font.family: theme ? theme.fontFamily : "Segoe UI"
                }
                Text {
                    text: "Customize your environment"
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                    color: Qt.rgba(1, 1, 1, 0.9)
                    font.family: theme ? theme.fontFamily : "Segoe UI"
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
                    font.family: theme ? theme.fontFamily : "Segoe UI"
                }
                
                Row {
                    spacing: 12
                    
                    // BMW Theme option
                    Rectangle {
                        width: 120
                        height: 80
                        radius: 12
                        color: theme && theme.themeName === "bmw" 
                            ? Qt.rgba(0.4, 0.9, 1.0, 0.15) 
                            : Qt.rgba(1, 1, 1, 0.06)
                        border.width: theme && theme.themeName === "bmw" ? 2 : 1
                        border.color: theme && theme.themeName === "bmw" 
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
                                font.family: theme ? theme.fontFamily : "Segoe UI"
                            }
                            Text {
                                text: "Soft, organic"
                                font.pixelSize: 10
                                color: Qt.rgba(1, 1, 1, 0.5)
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.family: theme ? theme.fontFamily : "Segoe UI"
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                console.log("Switching to BMW theme")
                                if(root.theme) root.theme.setTheme("bmw")
                            }
                        }
                    }
                    
                    // Audi Theme option
                    Rectangle {
                        width: 120
                        height: 80
                        radius: 12
                        color: theme && theme.themeName === "audi" 
                            ? Qt.rgba(0.4, 0.9, 1.0, 0.15) 
                            : Qt.rgba(1, 1, 1, 0.06)
                        border.width: theme && theme.themeName === "audi" ? 2 : 1
                        border.color: theme && theme.themeName === "audi" 
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
                                font.family: theme ? theme.fontFamily : "Segoe UI"
                            }
                            Text {
                                text: "Sharp, technical"
                                font.pixelSize: 10
                                color: Qt.rgba(1, 1, 1, 0.5)
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.family: theme ? theme.fontFamily : "Segoe UI"
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                console.log("Switching to Audi theme")
                                if(root.theme) root.theme.setTheme("audi")
                            }
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
                    font.family: theme ? theme.fontFamily : "Segoe UI"
                }
                
                GridView {
                    width: parent.width
                    height: 140
                    cellWidth: 160
                    cellHeight: 100
                    clip: true
                    
                    model: WallpaperModel {}
                    
                    delegate: Item {
                        width: 152
                        height: 92
                        
                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 4
                            radius: 10
                            color: Qt.rgba(1, 1, 1, 0.06)
                            border.width: app && app.currentWallpaper === model.source ? 2 : 1
                            border.color: app && app.currentWallpaper === model.source 
                                ? Qt.rgba(0.4, 0.9, 1.0, 0.8) 
                                : Qt.rgba(1, 1, 1, 0.15)
                            clip: true
                            
                            Image {
                                anchors.fill: parent
                                anchors.margins: 1
                                source: "../../assets/wallpapers/" + model.source
                                fillMode: Image.PreserveAspectCrop
                                opacity: 0.85
                            }
                            
                            // Gradient overlay
                            Rectangle {
                                anchors.fill: parent
                                radius: parent.radius
                                gradient: Gradient {
                                    GradientStop { position: 0.6; color: "transparent" }
                                    GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.6) }
                                }
                            }
                            
                            // Label
                            Text {
                                text: model.name
                                font.pixelSize: 10
                                font.weight: Font.Medium
                                color: Qt.rgba(1, 1, 1, 0.9)
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.margins: 8
                                font.family: theme ? theme.fontFamily : "Segoe UI"
                            }
                            
                            // Selection indicator
                            Rectangle {
                                visible: app && app.currentWallpaper === model.source
                                width: 18
                                height: 18
                                radius: 9
                                color: Qt.rgba(0.4, 0.9, 1.0, 0.9)
                                anchors.top: parent.top
                                anchors.right: parent.right
                                anchors.margins: 6
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "✓"
                                    font.pixelSize: 10
                                    font.weight: Font.Bold
                                    color: Qt.rgba(0, 0, 0, 0.8)
                                }
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: if(app) app.set_wallpaper(model.source)
                            }
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
                    font.family: theme ? theme.fontFamily : "Segoe UI"
                }
                Text {
                    text: "Sound and voice settings"
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                    color: Qt.rgba(1, 1, 1, 0.9)
                    font.family: theme ? theme.fontFamily : "Segoe UI"
                }
            }
            
            Text {
                text: "Audio settings coming soon"
                font.pixelSize: 13
                color: Qt.rgba(1, 1, 1, 0.5)
                font.family: theme ? theme.fontFamily : "Segoe UI"
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
                    font.family: theme ? theme.fontFamily : "Segoe UI"
                }
                Text {
                    text: "Data and security"
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                    color: Qt.rgba(1, 1, 1, 0.9)
                    font.family: theme ? theme.fontFamily : "Segoe UI"
                }
            }
            
            Text {
                text: "Privacy settings coming soon"
                font.pixelSize: 13
                color: Qt.rgba(1, 1, 1, 0.5)
                font.family: theme ? theme.fontFamily : "Segoe UI"
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
                    font.family: theme ? theme.fontFamily : "Segoe UI"
                }
                Text {
                    text: "Steel OS"
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                    color: Qt.rgba(1, 1, 1, 0.9)
                    font.family: theme ? theme.fontFamily : "Segoe UI"
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
                        font.family: theme ? theme.fontFamily : "Segoe UI"
                        width: 100
                    }
                    Text {
                        text: "6.5"
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        color: Qt.rgba(1, 1, 1, 0.9)
                        font.family: theme ? theme.fontFamily : "Segoe UI"
                    }
                }
                
                Row {
                    spacing: 12
                    Text {
                        text: "AI Engine"
                        font.pixelSize: 12
                        color: Qt.rgba(1, 1, 1, 0.5)
                        font.family: theme ? theme.fontFamily : "Segoe UI"
                        width: 100
                    }
                    Text {
                        text: "Google Gemini 1.5 Pro"
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        color: Qt.rgba(1, 1, 1, 0.9)
                        font.family: theme ? theme.fontFamily : "Segoe UI"
                    }
                }
                
                Row {
                    spacing: 12
                    Text {
                        text: "Framework"
                        font.pixelSize: 12
                        color: Qt.rgba(1, 1, 1, 0.5)
                        font.family: theme ? theme.fontFamily : "Segoe UI"
                        width: 100
                    }
                    Text {
                        text: "PySide6 / Qt 6"
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        color: Qt.rgba(1, 1, 1, 0.9)
                        font.family: theme ? theme.fontFamily : "Segoe UI"
                    }
                }
            }
        }
    }
}
