import QtQuick 2.15
import "../../motion"

QtObject {
    // ═══════════════════════════════════════════════════════
    // AUDI THEME
    // "Progressive Technology"
    // Sharp geometry, flat depth, technical precision
    // Inspired by audiusa.com
    // ═══════════════════════════════════════════════════════
    
    // Identity
    property string themeName: "audi"
    
    // ─────────────────────────────────────────────────────
    // THEME CONTRACT (Required Properties)
    // ─────────────────────────────────────────────────────
    
    // Tile Geometry (SHARP - key differentiator)
    property int tileRadius: 6           // Almost rectangular
    property real tileBlur: 0.02         // Minimal blur
    property real tileBorderOpacity: 0.20 // Stronger borders
    property real tileShadowOpacity: 0.15 // Less shadow
    
    // Background
    property real backgroundContrast: 0.85
    property color backgroundColor: "#0A0C0F"
    
    // Motion Profile (FAST - key differentiator)
    property string motionProfile: "sharp"
    property int transitionFast: 120      // Quick snaps
    property int transitionNormal: 220    // Crisp
    property int transitionSlow: 350      // Still faster than BMW
    property int easingType: Easing.OutQuart  // Sharper curve
    
    // Orb Style (GEOMETRIC - key differentiator)
    property string orbStyle: "geometric"  // Ticks, arcs, lines
    property bool useGeometricOrb: true
    property real orbGlowIntensity: 0.15   // Less glow
    property real orbPulseSpeed: 2500      // Faster pulse (ms)
    
    // ─────────────────────────────────────────────────────
    // COLORS (Higher contrast)
    // ─────────────────────────────────────────────────────
    property color primaryColor: "#FFFFFF"
    property color secondaryColor: "#1C1E22"
    property color accentColor: "#BB0A1E"    // Audi Red
    property color textColor: "#FFFFFF"
    
    property color colorSuccess: "#00CC66"   // Brighter green
    property color colorWarning: "#FF9500"   // Audi orange
    property color colorError: "#FF3B30"     // Vivid red

    // ─────────────────────────────────────────────────────
    // TYPOGRAPHY (Tighter, more technical)
    // ─────────────────────────────────────────────────────
    property string fontFamily: "Segoe UI"
    property int fontSizeH1: 28              // Smaller
    property int fontSizeH2: 20
    property int fontSizeBody: 13
    property real letterSpacing: 0.8         // Tighter
    
    // ─────────────────────────────────────────────────────
    // GLASS PROPERTIES (Flatter)
    // ─────────────────────────────────────────────────────
    property real glassOpacity: 0.04         // More transparent
    property real glassBorder: 0.20          // Stronger borders
    property real glassShadow: 0.12          // Less shadow

    // ─────────────────────────────────────────────────────
    // LAYOUT
    // ─────────────────────────────────────────────────────
    property int radiusSmall: 4
    property int radiusLarge: 8
    property int radiusTile: 6               // Sharp
    property int radiusPanel: 10             // Sharp
    property int padding: 20                 // Tighter
    
    // ─────────────────────────────────────────────────────
    // GRADIENTS (Minimal, flat)
    // ─────────────────────────────────────────────────────
    property bool useGradient: false         // Flat look
    property color gradientStart: "#12141A"
    property color gradientCenter: "#0A0C0F"
    property color gradientEnd: "#050608"
    
    property color orbGradientCenter: "#E0E8F0"
    property color orbGradientEdge: "#4080A0"

    // ─────────────────────────────────────────────────────
    // MOTION OBJECT
    // ─────────────────────────────────────────────────────
    property QtObject motion: Calm {}
    
    property bool showSidebar: true
}
