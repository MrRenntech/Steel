import QtQuick 2.15

Item {

    property var theme

    Column {
        spacing: 8
        anchors.centerIn: parent

        Text { 
            text: "SYSTEM STATUS"
            opacity: 0.6
            color: theme.textColor
            font.family: theme.fontFamily
            font.pixelSize: 10
            font.bold: true
        }
        Text { 
            text: "MIC: ONLINE"
            color: theme.colorSuccess
            font.family: theme.fontFamily
        }
        Text { 
            text: "AI CORE: READY"
            color: theme.colorSuccess
            font.family: theme.fontFamily
        }
    }
}
