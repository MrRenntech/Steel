import QtQuick 2.15
import "../../motion"

QtObject {
    // Audi Theme
    property string backgroundImage: "../../assets/ui/audi_dashboard.png"
    
    property color backgroundColor: "#1A1A1A" // Tech Grey
    property color primaryColor: "#FF0000"    // Red
    property color secondaryColor: "#000000"
    property color accentColor: "#FFFFFF"
    property color textColor: "#E0E0E0"

    property color colorSuccess: "#FF0000" // Audi Red
    property color colorWarning: "#FF6600" 
    property color colorError: "#FFFFFF"   // Critical white or red

    property string fontFamily: "Verdana"
    property int fontSizeH1: 30
    property int fontSizeH2: 22
    property int fontSizeBody: 12
    
    property int radiusSmall: 0 // Sharp
    property int radiusLarge: 2
    property int padding: 12
    
    property QtObject motion: Dynamic {} // Tech precise
}
