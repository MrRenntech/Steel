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
    color: theme.backgroundColor

    // Theme Engine
    ThemeLoader {
        id: theme
    }

    // Background Image (if theme has one)
    Image {
        anchors.fill: parent
        source: theme.backgroundImage
        fillMode: Image.PreserveAspectCrop
        visible: source !== ""
        opacity: 0.5
    }

    // Central AI Core
    CoreVisual {
        anchors.centerIn: parent
        theme: theme
        assistantState: app.assistantState
    }
    
    // Debug Controls (Strictly for verifying states)
    Rectangle {
        id: devPanel
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
                DebugButton { text: "THEME"; onClicked: app.cycle_theme() }
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
