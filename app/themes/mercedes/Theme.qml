import QtQuick 2.15
import "../../motion"

QtObject {
    // Mercedes Theme
    property string backgroundImage: "../../assets/ui/merc_dashboard.png"

    property color backgroundColor: "#000000" // Obsidian
    property color primaryColor: "#00F5FF"    // EQ Cyan
    property color secondaryColor: "#111111"
    property color accentColor: "#00F5FF"
    property color textColor: "#FFFFFF"

    property color colorSuccess: "#00F5FF" // EQ Cyan
    property color colorWarning: "#B0B0FF" // EQ Lavender
    property color colorError: "#FF3333"

    property string fontFamily: "Times New Roman"
    property int fontSizeH1: 36
    property int fontSizeH2: 24
    property int fontSizeBody: 14
    
    property int radiusSmall: 8
    property int radiusLarge: 20
    property int padding: 24
    
    property QtObject motion: Calm {} // Fluid luxury
}
