pragma Singleton
import QtQuick 2.15

QtObject {
    property string family: "Segoe UI"
    property int h1: 24
    property int h2: 18
    property int h3: 16
    property int body: 14
    property int small: 12
    property int tiny: 10
    
    property real letterSpacing: 0.2
    property int weightPrimary: Font.Medium
    property int weightSecondary: Font.Normal
}
