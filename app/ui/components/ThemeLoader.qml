import QtQuick 2.15

Item {
    id: root
    
    // Current theme name
    property string themeName: loader.item ? loader.item.themeName : "bmw"
    
    // The active theme object is loaded here
    property alias activeTheme: loader.item
    
    // ═══════════════════════════════════════════════════════
    // PUBLIC API (Proxies to activeTheme)
    // ═══════════════════════════════════════════════════════
    
    // Colors
    property color backgroundColor: loader.item ? loader.item.backgroundColor : "#000000"
    property color primaryColor: loader.item ? loader.item.primaryColor : "#FFFFFF"
    property color secondaryColor: loader.item ? loader.item.secondaryColor : "#333333"
    property color accentColor: loader.item ? loader.item.accentColor : "#808080"
    property color textColor: loader.item ? loader.item.textColor : "#FFFFFF"
    
    property color colorSuccess: loader.item ? loader.item.colorSuccess : "#00FF00"
    property color colorWarning: loader.item ? loader.item.colorWarning : "#FFFF00"
    property color colorError: loader.item ? loader.item.colorError : "#FF0000"
    
    // Typography
    property string fontFamily: loader.item ? loader.item.fontFamily : "Segoe UI"
    property int fontSizeH1: loader.item ? loader.item.fontSizeH1 : 32
    property int fontSizeH2: loader.item ? loader.item.fontSizeH2 : 24
    property int fontSizeBody: loader.item ? loader.item.fontSizeBody : 14
    property real letterSpacing: loader.item ? loader.item.letterSpacing : 1.0
    
    // Geometry
    property int radiusLarge: loader.item ? loader.item.radiusLarge : 16
    property int radiusSmall: loader.item ? loader.item.radiusSmall : 8
    property int radiusTile: loader.item ? loader.item.radiusTile : 20
    property int radiusPanel: loader.item ? loader.item.radiusPanel : 28
    property int padding: loader.item ? loader.item.padding : 24
    
    // Glass Properties
    property real glassOpacity: loader.item ? loader.item.glassOpacity : 0.08
    property real glassBorder: loader.item ? loader.item.glassBorder : 0.15
    property real glassShadow: loader.item ? loader.item.glassShadow : 0.30
    
    // Motion
    property var motion: loader.item ? loader.item.motion : null
    property int transitionFast: loader.item ? loader.item.transitionFast : 200
    property int transitionNormal: loader.item ? loader.item.transitionNormal : 360
    property int transitionSlow: loader.item ? loader.item.transitionSlow : 600
    property int easingType: loader.item ? loader.item.easingType : Easing.OutCubic
    
    // Background
    property string backgroundImage: loader.item ? loader.item.backgroundImage : ""
    property bool useGradient: loader.item ? loader.item.useGradient : false
    property color gradientStart: loader.item ? loader.item.gradientStart : backgroundColor
    property color gradientCenter: loader.item ? loader.item.gradientCenter : backgroundColor
    property color gradientEnd: loader.item ? loader.item.gradientEnd : backgroundColor
    
    // Orb
    property color orbGradientCenter: loader.item ? loader.item.orbGradientCenter : primaryColor
    property color orbGradientEdge: loader.item ? loader.item.orbGradientEdge : secondaryColor
    property bool useGeometricOrb: loader.item ? loader.item.useGeometricOrb : false
    
    // Layout
    property bool showSidebar: loader.item ? loader.item.showSidebar : false
    
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
    
    // Connection to Python state
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
        source: "../../themes/bmw/Theme.qml" // Default to BMW
        asynchronous: false
    }
}
