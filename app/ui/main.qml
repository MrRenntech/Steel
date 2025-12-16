import QtQuick
import QtQuick.Window
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Window {
    width: 800
    height: 600
    visible: true
    title: "Steel v6.4 Refactored"
    color: "black"

    // Theme Engine
    ThemeLoader {
        id: theme
    }

    // Background Gradient (Premium Depth)
    Rectangle {
        anchors.fill: parent
        color: theme.backgroundColor // Fallback
        
        gradient: theme.useGradient ? gradientObj : null
        
        Gradient {
            id: gradientObj
            GradientStop { position: 0.0; color: theme.gradientStart }
            GradientStop { position: 0.5; color: theme.gradientCenter }
            GradientStop { position: 1.0; color: theme.gradientEnd }
        }
    }

    // Background Image (Overlay if theme has one)
    Image {
        anchors.fill: parent
        source: theme.backgroundImage
        fillMode: Image.PreserveAspectCrop
        visible: source !== ""
        opacity: 0.5
    }

    // Central AI Core
    // Offset Logic: The Orb "leans" towards the information panel (-6% width),
    // creating a visual tension that links the two elements.
    CoreVisual {
        id: core
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -parent.width * 0.06 // Visual lean towards panel
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 20
        theme: theme
        assistantState: app.assistantState
        onClicked: {
            if (app.assistantState === "IDLE") {
                app.set_state("LISTENING")
            } else {
                app.set_state("IDLE")
            }
        }
    }

    // Visual Link: Subtle Accent Echo
    // A faint highlight that bridges the gap between the Orb and the Panel,
    // implying they are part of the same system without using a hard line.
    Rectangle {
        width: 2
        height: 120
        anchors.verticalCenter: core.verticalCenter
        anchors.right: contextColumn.left
        anchors.rightMargin: 24
        color: Qt.rgba(
            theme.accentColor.r,
            theme.accentColor.g,
            theme.accentColor.b,
            0.08
        )
    }

    // Right-side Context Column (BMW-style Refined)
    Rectangle {
        id: contextColumn
        width: parent.width * 0.28
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        color: Qt.rgba(
            theme.secondaryColor.r,
            theme.secondaryColor.g,
            theme.secondaryColor.b,
            0.35
        )

        // Subtle Visual Link: Accent colored border echo
        border.color: Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.08)
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 40
            spacing: 0

            // 1. ASSISTANT LABEL
            Text {
                text: "ASSISTANT"
                color: theme.textColor
                font.family: theme.fontFamily
                font.pixelSize: 11
                opacity: 0.35
                font.letterSpacing: 1.4
            }

            // 2. STATE (Hero)
            Text {
                text: app.assistantState
                color: theme.primaryColor
                font.family: theme.fontFamily
                font.pixelSize: 32
                font.bold: true
                opacity: 0.95
            }
            
            // 3. Breathing Space
            Item { Layout.preferredHeight: 28 }

            // 4. SYSTEM LABEL
            Text {
                text: "SYSTEM"
                color: theme.textColor
                font.family: theme.fontFamily
                font.pixelSize: 11
                opacity: 0.35
                font.letterSpacing: 1.4
            }
            
            // SYSTEM Value
            Text {
                text: "ONLINE"
                color: theme.textColor
                font.family: theme.fontFamily
                font.pixelSize: 15
                opacity: 0.8
                // No bold, Neutral color
            }

            // 5. Push Time Down (35% of height)
            Item { Layout.preferredHeight: contextColumn.height * 0.35 }

            // TIME
            Text {
                id: timeLabel
                text: Qt.formatDateTime(new Date(), "hh:mm AP")
                color: theme.textColor
                font.family: theme.fontFamily
                font.pixelSize: 24
                opacity: 0.85
            }

            // DATE
            Text {
                id: dateLabel
                text: Qt.formatDateTime(new Date(), "dddd, dd MMM")
                color: theme.textColor
                font.family: theme.fontFamily
                font.pixelSize: 12
                opacity: 0.45
            }
            
            Item { Layout.fillHeight: true }
        }
        
        Timer {
            interval: 1000; running: true; repeat: true
            onTriggered: {
                timeLabel.text = Qt.formatDateTime(new Date(), "hh:mm AP")
                dateLabel.text = Qt.formatDateTime(new Date(), "dddd, dd MMM")
            }
        }
    }
    

    property bool devMode: false

    Shortcut {
        sequence: "Ctrl+D"
        onActivated: devMode = !devMode
    }

    // Debug Controls (Strictly for verifying states)
    Rectangle {
        id: devPanel
        visible: devMode
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20
        width: devLayout.implicitWidth + 20
        height: devLayout.implicitHeight + 20
        color: "#111111" // Dark background
        border.color: theme.primaryColor
        border.width: 1
        radius: 8
        opacity: 0.3 // De-emphasized
        
        // Appear on hover
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: devPanel.opacity = 1.0
            onExited: devPanel.opacity = 0.3
            propagateComposedEvents: true
            z: -1
        }

        ColumnLayout {
            id: devLayout
            anchors.centerIn: parent
            spacing: 5
            
            Text {
                text: "DEV CONTROLS"
                color: theme.textColor
                font.family: theme.fontFamily
                font.pixelSize: 10
                font.bold: true
                Layout.alignment: Qt.AlignRight
            }
            
            Text {
                text: "STATE: " + app.assistantState
                color: theme.textColor
                font.family: theme.fontFamily
                font.pixelSize: 10
                Layout.alignment: Qt.AlignRight
            }
            
            GridLayout {
                columns: 2
                columnSpacing: 5
                rowSpacing: 5
                Layout.alignment: Qt.AlignRight
                
                DebugButton { text: "IDLE"; onClicked: app.set_state("IDLE") }
                DebugButton { text: "LISTEN"; onClicked: app.set_state("LISTENING") }
                DebugButton { text: "THINK"; onClicked: app.set_state("THINKING") }
                DebugButton { text: "RESPOND"; onClicked: app.set_state("RESPONDING") }
                DebugButton { text: "ERROR"; onClicked: app.set_state("ERROR") }
                // DebugButton { text: "THEME"; onClicked: app.cycle_theme() } // Disabled
            }
        }
    }
    
    component DebugButton: Button {
        background: Rectangle {
            color: parent.down ? theme.primaryColor : Qt.rgba(1,1,1,0.1)
            radius: 4
            border.color: theme.primaryColor
            border.width: 1
        }
        contentItem: Text {
            text: parent.text
            color: parent.down ? theme.backgroundColor : theme.textColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 12
            padding: 8
        }
    }
}
