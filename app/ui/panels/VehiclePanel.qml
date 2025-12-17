import QtQuick 2.15
import Theme 1.0


Item {
    id: root

    // Readability layer - text never on raw wallpaper
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, Theme.readabilityOpacity)
        z: -1
    }

    Column {
        spacing: 16
        anchors.centerIn: parent

        Text {
            text: "SYSTEM"
            font.pixelSize: 11
            font.weight: Font.Medium
            font.letterSpacing: 1.4
            opacity: Theme.opMuted
            color: Theme.textMuted
            font.family: FontRegistry.current.name
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: "EVENT LOGS"
            font.pixelSize: 24
            font.weight: Font.Medium
            opacity: Theme.opPrimary
            color: Theme.textPrimary
            font.family: FontRegistry.current.name
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
        
        Text {
            text: "System diagnostics and runtime events"
            font.pixelSize: 13
            opacity: Theme.opMuted
            color: Theme.textSecondary
            font.family: FontRegistry.current.name
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
