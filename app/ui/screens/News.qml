import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Theme 1.0

Item {
    id: root
    property var theme
    
    Text {
        anchors.centerIn: parent
        text: "News Feed Module\n(Coming Soon)"
        color: theme.textColor
        font.family: FontRegistry.current.name
        font.pixelSize: 24
        horizontalAlignment: Text.AlignHCenter
    }
}
