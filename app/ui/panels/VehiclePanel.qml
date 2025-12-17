import QtQuick 2.15

Item {
    id: root
    property var theme

    // Readability layer - text never on raw wallpaper
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, theme ? theme.readabilityOpacity : 0.22)
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
            opacity: theme ? theme.opMuted : 0.55
            color: theme ? theme.textMuted : "#9AA1AB"
            font.family: theme ? theme.activeFont : "Segoe UI"
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: "EVENT LOGS"
            font.pixelSize: 24
            font.weight: Font.Medium
            opacity: theme ? theme.opPrimary : 1.0
            color: theme ? theme.textPrimary : "#F4F6F8"
            font.family: theme ? theme.activeFont : "Segoe UI"
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
        
        Text {
            text: "System diagnostics and runtime events"
            font.pixelSize: 13
            opacity: theme ? theme.opMuted : 0.55
            color: theme ? theme.textSecondary : "#C7CCD3"
            font.family: theme ? theme.activeFont : "Segoe UI"
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
