import QtQuick 2.15
import "../../motion"

QtObject {
    // Brand Neutral Design Grammar
    
    // Assets
    property string backgroundImage: ""

    // Colors
    property color backgroundColor: "#121212"
    property color primaryColor: "#FFFFFF"
    property color secondaryColor: "#333333"
    property color accentColor: "#808080"
    property color textColor: "#FFFFFF"
    
    // Semantic Colors for States
    property color colorSuccess: "#4CAF50" // Green (Listening)
    property color colorWarning: "#FFC107" // Amber (Thinking)
    property color colorError: "#F44336"   // Red (Error)

    // Typography
    property string fontFamily: "Arial"
    property int fontSizeH1: 32
    property int fontSizeH2: 24
    property int fontSizeBody: 14
    
    // Geometry
    property int radiusSmall: 4
    property int radiusLarge: 12
    property int padding: 16
    
    // Motion
    property QtObject motion: Calm {}
}
