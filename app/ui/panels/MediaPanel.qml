import QtQuick 2.15

Item {

    property var theme

    Column {
        spacing: 12
        anchors.centerIn: parent

        Text {
            text: "MIC INPUT"
            font.pixelSize: 14
            opacity: 0.6
            color: theme.textColor
            font.family: theme.fontFamily
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            width: 280
            height: 6
            radius: 3
            color: Qt.rgba(1,1,1,0.1)

            Rectangle {
                width: parent.width * app.audioLevel
                height: parent.height
                radius: 3
                color: theme.colorSuccess
            }
        }
        
        Text {
            text: (app.audioLevel > 0.05) ? "Listening…" : "Idle"
            font.pixelSize: 10
            opacity: 0.4
            color: theme.textColor
            font.family: theme.fontFamily
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
