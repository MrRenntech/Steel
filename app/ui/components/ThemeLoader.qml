import QtQuick 2.15

Item {
    id: root
    
    // Current theme name
    property string themeName: loader.item ? loader.item.themeName : "bmw"
    property alias activeTheme: loader.item
    
    // ═══════════════════════════════════════════════════════
    // THEME CONTRACT (Proxied from active theme)
    // ═══════════════════════════════════════════════════════
    
    // Tile Geometry
    property int tileRadius: loader.item ? loader.item.tileRadius : 20
    property real tileBlur: loader.item ? loader.item.tileBlur : 0.08
    property real tileBorderOpacity: loader.item ? loader.item.tileBorderOpacity : 0.15
    property real tileShadowOpacity: loader.item ? loader.item.tileShadowOpacity : 0.30
    
    // Background
    property real backgroundContrast: loader.item ? loader.item.backgroundContrast : 0.7
    property color backgroundColor: loader.item ? loader.item.backgroundColor : "#0E141B"
    
    // Motion Profile
    property string motionProfile: loader.item ? loader.item.motionProfile : "calm"
    property int transitionFast: loader.item ? loader.item.transitionFast : 200
    property int transitionNormal: loader.item ? loader.item.transitionNormal : 360
    property int transitionSlow: loader.item ? loader.item.transitionSlow : 600
    property int easingType: loader.item ? loader.item.easingType : Easing.OutCubic
    
    // Orb Style
    property string orbStyle: loader.item ? loader.item.orbStyle : "organic"
    property bool useGeometricOrb: loader.item ? loader.item.useGeometricOrb : false
    property real orbGlowIntensity: loader.item ? loader.item.orbGlowIntensity : 0.3
    property real orbPulseSpeed: loader.item ? loader.item.orbPulseSpeed : 5000
    
    // ═══════════════════════════════════════════════════════
    // COLORS
    // ═══════════════════════════════════════════════════════
    property color primaryColor: loader.item ? loader.item.primaryColor : "#FFFFFF"
    property color secondaryColor: loader.item ? loader.item.secondaryColor : "#333333"
    property color accentColor: loader.item ? loader.item.accentColor : "#6FAED9"
    property color textColor: loader.item ? loader.item.textColor : "#FFFFFF"
    
    property color colorSuccess: loader.item ? loader.item.colorSuccess : "#00FF00"
    property color colorWarning: loader.item ? loader.item.colorWarning : "#FFFF00"
    property color colorError: loader.item ? loader.item.colorError : "#FF0000"
    
    // ═══════════════════════════════════════════════════════
    // TYPOGRAPHY
    // ═══════════════════════════════════════════════════════
    property string fontFamily: loader.item ? loader.item.fontFamily : "Segoe UI"
    property int fontSizeH1: loader.item ? loader.item.fontSizeH1 : 32
    property int fontSizeH2: loader.item ? loader.item.fontSizeH2 : 24
    property int fontSizeBody: loader.item ? loader.item.fontSizeBody : 14
    property real letterSpacing: loader.item ? loader.item.letterSpacing : 1.0
    
    // ═══════════════════════════════════════════════════════
    // GEOMETRY (Layout radii)
    // ═══════════════════════════════════════════════════════
    property int radiusSmall: loader.item ? loader.item.radiusSmall : 8
    property int radiusLarge: loader.item ? loader.item.radiusLarge : 16
    property int radiusTile: loader.item ? loader.item.radiusTile : 20
    property int radiusPanel: loader.item ? loader.item.radiusPanel : 28
    property int padding: loader.item ? loader.item.padding : 24
    
    // ═══════════════════════════════════════════════════════
    // GLASS PROPERTIES
    // ═══════════════════════════════════════════════════════
    property real glassOpacity: loader.item ? loader.item.glassOpacity : 0.08
    property real glassBorder: loader.item ? loader.item.glassBorder : 0.15
    property real glassShadow: loader.item ? loader.item.glassShadow : 0.30
    
    // ═══════════════════════════════════════════════════════
    // GRADIENTS
    // ═══════════════════════════════════════════════════════
    property bool useGradient: loader.item ? loader.item.useGradient : true
    property color gradientStart: loader.item ? loader.item.gradientStart : "#18202A"
    property color gradientCenter: loader.item ? loader.item.gradientCenter : "#121A24"
    property color gradientEnd: loader.item ? loader.item.gradientEnd : "#070B10"
    
    property color orbGradientCenter: loader.item ? loader.item.orbGradientCenter : "#D8E6F3"
    property color orbGradientEdge: loader.item ? loader.item.orbGradientEdge : "#5A8BB0"
    
    // ═══════════════════════════════════════════════════════
    // OTHER
    // ═══════════════════════════════════════════════════════
    property var motion: loader.item ? loader.item.motion : null
    property bool showSidebar: loader.item ? loader.item.showSidebar : true
    property string backgroundImage: loader.item ? loader.item.backgroundImage : ""
    
    // ═══════════════════════════════════════════════════════
    // THEME SWITCHING
    // ═══════════════════════════════════════════════════════
    
    function setTheme(name) {
        var validThemes = ["bmw", "audi"]
        if (validThemes.indexOf(name) === -1) {
            console.warn("Unknown theme: " + name + ", defaulting to bmw")
            name = "bmw"
        }
        console.log("Switching theme to: " + name)
        loader.source = "../../themes/" + name + "/Theme.qml"
    }
    
    // Connection to Python state (if used)
    Connections {
        target: app
        function onThemeChanged() {
            var t = app.currentTheme
            console.log("Theme change requested: " + t)
            root.setTheme(t)
        }
    }

    Loader {
        id: loader
        source: "../../themes/bmw/Theme.qml"
        asynchronous: false
    }
}
