import QtQuick 2.15
import QtQuick.Layouts 1.15

// ═══════════════════════════════════════════════════════
// WALLPAPER PANEL
// Premium curated wallpaper selection overlay
// ═══════════════════════════════════════════════════════

Rectangle {
    id: root
    anchors.fill: parent
    color: Qt.rgba(0, 0, 0, 0.7)
    opacity: 0
    visible: opacity > 0
    
    property var theme
    signal closed()
    
    // Show/hide with animation
    function show() { opacity = 1 }
    function hide() { opacity = 0 }
    
    Behavior on opacity { 
        NumberAnimation { duration: 300; easing.type: Easing.OutCubic } 
    }
    
    // Click outside to close
    MouseArea {
        anchors.fill: parent
        onClicked: root.hide()
    }
    
    // Glass Panel
    Rectangle {
        id: panel
        width: Math.min(parent.width * 0.7, 700)
        height: Math.min(parent.height * 0.7, 500)
        anchors.centerIn: parent
        radius: 28
        
        // Light glass
        color: Qt.rgba(1, 1, 1, 0.08)
        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.2)
        
        // Shadow
        Rectangle {
            anchors.fill: parent
            anchors.topMargin: 8
            anchors.leftMargin: 4
            anchors.rightMargin: -4
            anchors.bottomMargin: -12
            radius: parent.radius + 4
            color: Qt.rgba(0, 0, 0, 0.4)
            z: -1
        }
        
        // Prevent clicks from closing
        MouseArea {
            anchors.fill: parent
            onClicked: {} // Absorb
        }
        
        Column {
            anchors.fill: parent
            anchors.margins: 32
            spacing: 24
            
            // Header
            Item {
                width: parent.width
                height: 50
                
                Column {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 4
                    
                    Text {
                        text: "WALLPAPER"
                        font.pixelSize: 11
                        font.weight: Font.Medium
                        font.letterSpacing: 1.6
                        color: Qt.rgba(1, 1, 1, 0.5)
                        font.family: theme ? theme.fontFamily : "Segoe UI"
                    }
                    
                    Text {
                        text: "Choose Atmosphere"
                        font.pixelSize: 22
                        font.weight: Font.DemiBold
                        color: Qt.rgba(1, 1, 1, 0.9)
                        font.family: theme ? theme.fontFamily : "Segoe UI"
                    }
                }
                
                // Close button
                Rectangle {
                    width: 36
                    height: 36
                    radius: 18
                    color: Qt.rgba(1, 1, 1, 0.08)
                    border.color: Qt.rgba(1, 1, 1, 0.15)
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    
                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        font.pixelSize: 16
                        color: Qt.rgba(1, 1, 1, 0.6)
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.hide()
                    }
                }
            }
            
            // Wallpaper Grid
            GridView {
                id: wallpaperGrid
                width: parent.width
                height: parent.height - 80
                cellWidth: 180
                cellHeight: 130
                clip: true
                
                model: WallpaperModel {}
                
                delegate: Item {
                    width: wallpaperGrid.cellWidth - 16
                    height: wallpaperGrid.cellHeight - 16
                    
                    Rectangle {
                        id: card
                        anchors.fill: parent
                        anchors.margins: 8
                        radius: 14
                        color: Qt.rgba(1, 1, 1, 0.06)
                        border.width: app && app.currentWallpaper === model.source ? 2 : 1
                        border.color: app && app.currentWallpaper === model.source 
                            ? Qt.rgba(0.4, 0.9, 1.0, 0.8) 
                            : Qt.rgba(1, 1, 1, 0.15)
                        clip: true
                        
                        // Preview image
                        Image {
                            anchors.fill: parent
                            anchors.margins: 1
                            source: "../../assets/wallpapers/" + model.source
                            fillMode: Image.PreserveAspectCrop
                            opacity: 0.8
                            
                            // Rounded corners
                            layer.enabled: true
                        }
                        
                        // Overlay gradient for text readability
                        Rectangle {
                            anchors.fill: parent
                            radius: parent.radius
                            gradient: Gradient {
                                GradientStop { position: 0.5; color: "transparent" }
                                GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.6) }
                            }
                        }
                        
                        // Label
                        Column {
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.margins: 12
                            spacing: 2
                            
                            Text {
                                text: model.name
                                font.pixelSize: 12
                                font.weight: Font.Medium
                                color: Qt.rgba(1, 1, 1, 0.9)
                                font.family: theme ? theme.fontFamily : "Segoe UI"
                            }
                            
                            Text {
                                text: model.description
                                font.pixelSize: 9
                                color: Qt.rgba(1, 1, 1, 0.5)
                                font.family: theme ? theme.fontFamily : "Segoe UI"
                            }
                        }
                        
                        // Selection indicator
                        Rectangle {
                            visible: app && app.currentWallpaper === model.source
                            width: 20
                            height: 20
                            radius: 10
                            color: Qt.rgba(0.4, 0.9, 1.0, 0.9)
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.margins: 8
                            
                            Text {
                                anchors.centerIn: parent
                                text: "✓"
                                font.pixelSize: 12
                                font.weight: Font.Bold
                                color: Qt.rgba(0, 0, 0, 0.8)
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            
                            onEntered: card.color = Qt.rgba(1, 1, 1, 0.12)
                            onExited: card.color = Qt.rgba(1, 1, 1, 0.06)
                            
                            onClicked: {
                                if (app) {
                                    app.set_wallpaper(model.source)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
