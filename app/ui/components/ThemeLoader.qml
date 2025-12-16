import QtQuick 2.15

Item {
    id: root
    
    // The active theme object is loaded here
    property alias activeTheme: loader.item
    
    // Public API (proxies to activeTheme)
    // We use a fallback logic in case loader is transitioning
    property color backgroundColor: loader.item ? loader.item.backgroundColor : "#000000"
    property color primaryColor: loader.item ? loader.item.primaryColor : "#FFFFFF"
    property color secondaryColor: loader.item ? loader.item.secondaryColor : "#333333"
    property color accentColor: loader.item ? loader.item.accentColor : "#808080"
    property color textColor: loader.item ? loader.item.textColor : "#FFFFFF"
    
    property color colorSuccess: loader.item ? loader.item.colorSuccess : "#00FF00"
    property color colorWarning: loader.item ? loader.item.colorWarning : "#FFFF00"
    property color colorError: loader.item ? loader.item.colorError : "#FF0000"
    
    property string fontFamily: loader.item ? loader.item.fontFamily : "Arial"
    property int fontSizeH1: loader.item ? loader.item.fontSizeH1 : 32
    property int fontSizeH2: loader.item ? loader.item.fontSizeH2 : 24
    property int fontSizeBody: loader.item ? loader.item.fontSizeBody : 14
    
    property int radiusLarge: loader.item ? loader.item.radiusLarge : 0
    property int radiusSmall: loader.item ? loader.item.radiusSmall : 0
    property int padding: loader.item ? loader.item.padding : 0
    
    // Motion object
    property var motion: loader.item ? loader.item.motion : null
    
    property string backgroundImage: loader.item ? loader.item.backgroundImage : ""
    
    // Gradient Proxies
    property bool useGradient: loader.item ? loader.item.useGradient : false
    property color gradientStart: loader.item ? loader.item.gradientStart : backgroundColor
    property color gradientCenter: loader.item ? loader.item.gradientCenter : backgroundColor
    property color gradientEnd: loader.item ? loader.item.gradientEnd : backgroundColor
    
    property color orbGradientCenter: loader.item ? loader.item.orbGradientCenter : primaryColor
    property color orbGradientEdge: loader.item ? loader.item.orbGradientEdge : secondaryColor
    
    property bool showSidebar: loader.item ? loader.item.showSidebar : false
    
    // Connection to Python state
    Connections {
        target: app
        function onThemeChanged() {
            // Logic to switch theme path
            // e.g. "base" -> "../../themes/base/Theme.qml"
            var t = app.currentTheme
            console.log("Loading theme: " + t)
            // Enforce BMW Theme
            loader.source = "../../themes/bmw/Theme.qml"
        }
    }

    Loader {
        id: loader
        source: "../../themes/bmw/Theme.qml" // BMW only
    }
}
