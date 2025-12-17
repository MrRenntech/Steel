import QtQuick 2.15

Item {

    property var theme

    Text {
        anchors.centerIn: parent
        text: "NAVIGATION SYSTEM"
        opacity: 0.4
        color: theme.textColor
        font.family: theme.fontFamily
    }
}
