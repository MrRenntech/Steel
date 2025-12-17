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
            text: "ASSISTANT"
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
            text: "MIC INPUT"
            font.pixelSize: 18
            font.weight: Font.Medium
            opacity: theme ? theme.opSecondary : 0.75
            color: theme ? theme.textSecondary : "#C7CCD3"
            font.family: theme ? theme.activeFont : "Segoe UI"
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            width: 280
            height: 6
            radius: 3
            color: Qt.rgba(1,1,1,0.1)
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                width: parent.width * (app ? app.audioLevel : 0)
                height: parent.height
                radius: 3
                color: theme ? theme.colorSuccess : "#4A7A68"
            }
        }
        
        Text {
            text: (app && app.audioLevel > 0.05) ? "Listening…" : "Idle"
            font.pixelSize: 13
            opacity: theme ? theme.opMuted : 0.55
            color: theme ? theme.textSecondary : "#C7CCD3"
            font.family: theme ? theme.activeFont : "Segoe UI"
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
