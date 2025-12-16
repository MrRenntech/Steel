import QtQuick 2.15
import "../../motion"

QtObject {
    // BMW Test Theme
    property string backgroundImage: "../../assets/ui/bmw_dashboard.png"

    property color backgroundColor: "#001133" // Deep Blue
    property color primaryColor: "#0066B1"
    property color secondaryColor: "#003366"
    property color accentColor: "#FFFFFF"
    property color textColor: "#FFFFFF"
    
    property color colorSuccess: "#0066B1" // BMW Blue
    property color colorWarning: "#F59C1A" // Warning Orange
    property color colorError: "#D90022"   // Error Red

    property string fontFamily: "Arial"
    property int fontSizeH1: 40
    property int fontSizeH2: 28
    property int fontSizeBody: 16
    
    property int radiusSmall: 2
    property int radiusLarge: 8
    property int padding: 20
    
    property QtObject motion: Dynamic {}
}
