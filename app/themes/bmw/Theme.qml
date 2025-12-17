import QtQuick 2.15
import "../../motion"

QtObject {
    // BMW Visual Language
    // "Engineering Confidence"
    
    // Background: Near-black with blue-gray hint (Graphite Blue)
    // Concept: "Lit from above" - creates vertical depth
    property string backgroundImage: ""
    property var backgroundGradient: null 
    property color backgroundColor: "#0E141B" // BMW Graphite Blue

    // Colors
    // Primary: Soft White (#EAF2F8) for readability
    property color primaryColor: "#EAF2F8"
    // Secondary: Dark Slate (#1A222C) for surfaces
    property color secondaryColor: "#1A222C"
    // Accent: iDrive Blue (#6FAED9) for technical highlights
    property color accentColor: "#6FAED9"
    property color textColor: "#FFFFFF"
    
    // Semantic Colors (Desaturated, Cold)
    property color colorSuccess: "#4A7A68" // Cold Green
    property color colorWarning: "#BF9E60" // Muted Gold
    property color colorError: "#8C2F2F"   // Desaturated Red

    // Typography
    property string fontFamily: "Segoe UI"
    property int fontSizeH1: 32 // Calm sizing
    property int fontSizeH2: 24
    property int fontSizeBody: 14
    
    // Geometry (Minimal borders, soft edges)
    property int radiusSmall: 1
    property int radiusLarge: 4
    property int padding: 24 // Calm, deliberate spacing
    
    // Motion
    property QtObject motion: Calm {} // "Calm"
    
    // Gradient Support ("Premium Depth")
    property bool useGradient: true
    property color gradientStart: "#18202A"   // Top glow
    property color gradientCenter: "#121A24"  // Core graphite
    property color gradientEnd: "#070B10"     // Bottom falloff
    
    // Orb Gradient (Subtle Radial Simulation)
    property color orbGradientCenter: "#D8E6F3" // Lighter Center (Cool White-Blue)
    property color orbGradientEdge: "#5A8BB0"   // Darker Edge (Muted Blue)

    // Layout Structure
    property bool showSidebar: true
}
