import QtQuick 2.15

QtObject {
    // Calm Profile
    property int breathe: 2000
    property int attend: 600
    property int think: 1000
    property int respond: 300
    property int error: 1000

    property var easingSoft: Easing.InOutQuad
    property var easingFocus: Easing.OutSine
}
