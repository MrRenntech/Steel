import QtQuick 2.15
import "../../motion"

QtObject {
    // BMW Visual Language
    // "Engineering Confidence"
    // Soft gradients, organic curves, calm motion
    
    // Identity
    property string themeName: "bmw"
    
    // Background: Near-black with blue-gray hint (Graphite Blue)
    property string backgroundImage: ""
    property var backgroundGradient: null 
    property color backgroundColor: "#0E141B" // BMW Graphite Blue

    // Colors
    property color primaryColor: "#EAF2F8"
    property color secondaryColor: "#1A222C"
    property color accentColor: "#6FAED9" // iDrive Blue
    property color textColor: "#FFFFFF"
    
    // Semantic Colors (Desaturated, Cold)
    property color colorSuccess: "#4A7A68" // Cold Green
    property color colorWarning: "#BF9E60" // Muted Gold
    property color colorError: "#8C2F2F"   // Desaturated Red

    // Typography
    property string fontFamily: "Segoe UI"
    property int fontSizeH1: 32
    property int fontSizeH2: 24
    property int fontSizeBody: 14
    property real letterSpacing: 1.2 // More relaxed
    
    // Geometry (Soft, rounded)
    property int radiusSmall: 8
    property int radiusLarge: 16
    property int radiusTile: 20   // Soft tiles
    property int radiusPanel: 28  // Soft panels
    property int padding: 24
    
    // Glass Properties (Deep, blurred)
    property real glassOpacity: 0.08
    property real glassBorder: 0.15
    property real glassShadow: 0.30

    // Motion
    property QtObject motion: Calm {}
    property int transitionFast: 200
    property int transitionNormal: 360
    property int transitionSlow: 600
    property int easingType: Easing.OutCubic // Softer deceleration
    
    // Gradient Support
    property bool useGradient: true
    property color gradientStart: "#18202A"
    property color gradientCenter: "#121A24"
    property color gradientEnd: "#070B10"
    
    // Orb Gradient
    property color orbGradientCenter: "#D8E6F3"
    property color orbGradientEdge: "#5A8BB0"

    // Layout Structure
    property bool showSidebar: true
    
    // BMW-specific: Organic orb effects
    property bool useGeometricOrb: false // Uses soft glow instead of tick marks
}

