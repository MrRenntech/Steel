import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    property var theme
    
    Text {
        anchors.centerIn: parent
        text: "Security / VPN Module\n(Coming Soon)"
        color: theme.textColor
        font.family: theme.fontFamily
        font.pixelSize: 24
        horizontalAlignment: Text.AlignHCenter
    }
}
