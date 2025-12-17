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
            text: "ASSISTANT"
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
            text: "MIC INPUT"
            font.pixelSize: 18
            font.weight: Font.Medium
            opacity: Theme.opSecondary
            color: Theme.textSecondary
            font.family: FontRegistry.current.name
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
                color: Theme.colorSuccess
            }
        }
        
        Text {
            text: (app && app.audioLevel > 0.05) ? "Listening…" : "Idle"
            font.pixelSize: 13
            opacity: Theme.opMuted
            color: Theme.textSecondary
            font.family: FontRegistry.current.name
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
