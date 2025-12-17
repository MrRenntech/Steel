import QtQuick 2.15
import "../../motion"

QtObject {
    // ═══════════════════════════════════════════════════════
    // BMW THEME (bmw_base)
    // "Engineering Confidence"
    // Soft gradients, organic curves, calm motion
    // ═══════════════════════════════════════════════════════
    
    // Identity
    property string themeName: "bmw"
    
    // ─────────────────────────────────────────────────────
    // THEME CONTRACT (Required Properties)
    // ─────────────────────────────────────────────────────
    
    // Tile Geometry
    property int tileRadius: 20         // Rounded, organic
    property real tileBlur: 0.08        // Soft blur
    property real tileBorderOpacity: 0.15
    property real tileShadowOpacity: 0.30
    
    // Background
    property real backgroundContrast: 0.7
    property color backgroundColor: "#0E141B"
    
    // Motion Profile
    property string motionProfile: "calm"
    property int transitionFast: 200
    property int transitionNormal: 360
    property int transitionSlow: 600
    property int easingType: Easing.OutCubic
    
    // Orb Style
    property string orbStyle: "organic"   // Soft glow, breathing
    property bool useGeometricOrb: false
    property real orbGlowIntensity: 0.3
    property real orbPulseSpeed: 5000     // Slow breathing (ms)
    
    // ─────────────────────────────────────────────────────
    // COLORS
    // ─────────────────────────────────────────────────────
    property color primaryColor: "#EAF2F8"
    property color secondaryColor: "#1A222C"
    property color accentColor: "#6FAED9"    // iDrive Blue
    property color textColor: "#FFFFFF"
    
    property color colorSuccess: "#4A7A68"   // Cold Green
    property color colorWarning: "#BF9E60"   // Muted Gold
    property color colorError: "#8C2F2F"     // Desaturated Red

    // ─────────────────────────────────────────────────────
    // TYPOGRAPHY
    // ─────────────────────────────────────────────────────
    property string fontFamily: "Segoe UI"
    property int fontSizeH1: 32
    property int fontSizeH2: 24
    property int fontSizeBody: 14
    property real letterSpacing: 1.2
    
    // ─────────────────────────────────────────────────────
    // GLASS PROPERTIES
    // ─────────────────────────────────────────────────────
    property real glassOpacity: 0.08
    property real glassBorder: 0.15
    property real glassShadow: 0.30

    // ─────────────────────────────────────────────────────
    // LAYOUT
    // ─────────────────────────────────────────────────────
    property int radiusSmall: 8
    property int radiusLarge: 16
    property int radiusTile: 20
    property int radiusPanel: 28
    property int padding: 24
    
    // ─────────────────────────────────────────────────────
    // GRADIENTS
    // ─────────────────────────────────────────────────────
    property bool useGradient: true
    property color gradientStart: "#18202A"
    property color gradientCenter: "#121A24"
    property color gradientEnd: "#070B10"
    
    property color orbGradientCenter: "#D8E6F3"
    property color orbGradientEdge: "#5A8BB0"

    // ─────────────────────────────────────────────────────
    // MOTION OBJECT
    // ─────────────────────────────────────────────────────
    property QtObject motion: Calm {}
    
    property bool showSidebar: true
}
