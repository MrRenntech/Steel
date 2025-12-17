import QtQuick 2.15
import "../../motion"

QtObject {
    // AUDI Visual Language
    // "Progressive Technology"
    // Sharp geometry, flat depth, technical precision
    
    // Identity
    property string themeName: "audi"
    
    // Background: Pure dark with subtle warmth
    property string backgroundImage: ""
    property var backgroundGradient: null 
    property color backgroundColor: "#0A0C0F" // Near-black, warmer than BMW

    // Colors
    // Primary: Pure White for maximum contrast
    property color primaryColor: "#FFFFFF"
    // Secondary: Cool Slate
    property color secondaryColor: "#1C1E22"
    // Accent: Audi Red (used sparingly)
    property color accentColor: "#BB0A1E"
    property color textColor: "#FFFFFF"
    
    // Semantic Colors (Higher contrast than BMW)
    property color colorSuccess: "#00CC66" // Brighter green
    property color colorWarning: "#FF9500" // Audi orange
    property color colorError: "#FF3B30"   // Vivid red

    // Typography (Tighter, more technical)
    property string fontFamily: "Segoe UI"
    property int fontSizeH1: 28 // Smaller, more data density
    property int fontSizeH2: 20
    property int fontSizeBody: 13
    property real letterSpacing: 0.8 // Tighter than BMW
    
    // Geometry (SHARP - key difference from BMW)
    property int radiusSmall: 4   // Very subtle rounding
    property int radiusLarge: 8   // Almost rectangular
    property int radiusTile: 6    // Sharp tiles
    property int radiusPanel: 10  // Sharp panels
    property int padding: 20      // Tighter spacing
    
    // Glass Properties (Flatter, less blur)
    property real glassOpacity: 0.04      // More transparent
    property real glassBorder: 0.12       // Thinner borders
    property real glassShadow: 0.15       // Less shadow

    // Motion (Faster, sharper)
    property QtObject motion: Calm {} // Using same base, but faster durations
    property int transitionFast: 150    // Quick snaps
    property int transitionNormal: 250  // Crisp transitions
    property int transitionSlow: 400    // Still faster than BMW
    property int easingType: Easing.OutQuart // Sharper deceleration
    
    // Gradient Support (Minimal, flat)
    property bool useGradient: false    // Flatter look
    property color gradientStart: "#12141A"
    property color gradientCenter: "#0A0C0F"
    property color gradientEnd: "#050608"
    
    // Orb Gradient (Same AI identity, but crisper)
    property color orbGradientCenter: "#E0E8F0"
    property color orbGradientEdge: "#4080A0"

    // Layout Structure
    property bool showSidebar: true
    
    // Audi-specific: Geometric orb effects
    property bool useGeometricOrb: true // Enables tick marks, arcs instead of soft glow
}
