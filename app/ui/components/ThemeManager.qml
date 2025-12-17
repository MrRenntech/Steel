import QtQuick 2.15

QtObject {
    id: root
    
    // ═══════════════════════════════════════════════════════
    // THEME MANAGER (Central Authority)
    // All tiles, orb, blur, motion read ONLY from here
    // ═══════════════════════════════════════════════════════
    
    // Current active theme ID
    property string activeThemeId: "bmw"
    
    // Wallpaper (atmosphere, separate from theme)
    property string wallpaperId: "ambient_sky.png"
    signal wallpaperChanged(string id)
    
    // Theme changed signal
    signal themeChanged(string id)
    
    // ─────────────────────────────────────────────────────
    // THEME CONTRACT (sacred - all themes must define these)
    // ─────────────────────────────────────────────────────
    
    // Geometry
    property int tileRadius: themes[activeThemeId].tileRadius
    property real tileBlur: themes[activeThemeId].tileBlur
    property real tileBorderOpacity: themes[activeThemeId].tileBorderOpacity
    property real tileShadowOpacity: themes[activeThemeId].tileShadowOpacity
    property int radiusPanel: themes[activeThemeId].radiusPanel
    property int padding: themes[activeThemeId].padding
    
    // Colors
    property color accentColor: themes[activeThemeId].accentColor
    property color backgroundColor: themes[activeThemeId].backgroundColor
    property color primaryColor: themes[activeThemeId].primaryColor
    property color secondaryColor: themes[activeThemeId].secondaryColor
    property color textColor: themes[activeThemeId].textColor
    property color colorSuccess: themes[activeThemeId].colorSuccess
    property color colorWarning: themes[activeThemeId].colorWarning
    property color colorError: themes[activeThemeId].colorError
    property real backgroundContrast: themes[activeThemeId].backgroundContrast
    
    // Glass
    property real glassOpacity: themes[activeThemeId].glassOpacity
    property real glassBorder: themes[activeThemeId].glassBorder
    property real glassShadow: themes[activeThemeId].glassShadow
    
    // Typography
    property string fontFamily: themes[activeThemeId].fontFamily
    property int fontSizeH1: themes[activeThemeId].fontSizeH1
    property int fontSizeH2: themes[activeThemeId].fontSizeH2
    property int fontSizeBody: themes[activeThemeId].fontSizeBody
    property real letterSpacing: themes[activeThemeId].letterSpacing
    
    // Motion
    property string motionProfile: themes[activeThemeId].motionProfile
    property int motionSpeed: themes[activeThemeId].transitionNormal
    property int transitionFast: themes[activeThemeId].transitionFast
    property int transitionNormal: themes[activeThemeId].transitionNormal
    property int transitionSlow: themes[activeThemeId].transitionSlow
    property int easingType: themes[activeThemeId].easingType
    
    // Orb personality
    property string orbStyle: themes[activeThemeId].orbStyle
    property bool useGeometricOrb: themes[activeThemeId].useGeometricOrb
    property real orbGlowIntensity: themes[activeThemeId].orbGlowIntensity
    property real orbPulseSpeed: themes[activeThemeId].orbPulseSpeed
    
    // Gradients
    property bool useGradient: themes[activeThemeId].useGradient
    property color gradientStart: themes[activeThemeId].gradientStart
    property color gradientCenter: themes[activeThemeId].gradientCenter
    property color gradientEnd: themes[activeThemeId].gradientEnd
    property color orbGradientCenter: themes[activeThemeId].orbGradientCenter
    property color orbGradientEdge: themes[activeThemeId].orbGradientEdge
    
    // ─────────────────────────────────────────────────────
    // THEME REGISTRY (all available themes)
    // ─────────────────────────────────────────────────────
    property var themes: ({
        "bmw": {
            // Identity
            id: "bmw",
            name: "BMW",
            description: "Soft, organic",
            
            // Geometry
            tileRadius: 20,
            tileBlur: 0.08,
            tileBorderOpacity: 0.15,
            tileShadowOpacity: 0.30,
            radiusPanel: 28,
            padding: 24,
            
            // Colors
            accentColor: "#6FAED9",
            backgroundColor: "#0E141B",
            primaryColor: "#EAF2F8",
            secondaryColor: "#1A222C",
            textColor: "#FFFFFF",
            colorSuccess: "#4A7A68",
            colorWarning: "#BF9E60",
            colorError: "#8C2F2F",
            backgroundContrast: 0.7,
            
            // Glass
            glassOpacity: 0.08,
            glassBorder: 0.15,
            glassShadow: 0.30,
            
            // Typography
            fontFamily: "Segoe UI",
            fontSizeH1: 32,
            fontSizeH2: 24,
            fontSizeBody: 14,
            letterSpacing: 1.2,
            
            // Motion
            motionProfile: "calm",
            transitionFast: 200,
            transitionNormal: 360,
            transitionSlow: 600,
            easingType: Easing.OutCubic,
            
            // Orb
            orbStyle: "organic",
            useGeometricOrb: false,
            orbGlowIntensity: 0.3,
            orbPulseSpeed: 5000,
            
            // Gradients
            useGradient: true,
            gradientStart: "#18202A",
            gradientCenter: "#121A24",
            gradientEnd: "#070B10",
            orbGradientCenter: "#D8E6F3",
            orbGradientEdge: "#5A8BB0"
        },
        
        "audi": {
            // Identity
            id: "audi",
            name: "AUDI",
            description: "Sharp, technical",
            
            // Geometry
            tileRadius: 6,
            tileBlur: 0.02,
            tileBorderOpacity: 0.20,
            tileShadowOpacity: 0.15,
            radiusPanel: 10,
            padding: 20,
            
            // Colors
            accentColor: "#BB0A1E",
            backgroundColor: "#0A0C0F",
            primaryColor: "#FFFFFF",
            secondaryColor: "#1C1E22",
            textColor: "#FFFFFF",
            colorSuccess: "#00CC66",
            colorWarning: "#FF9500",
            colorError: "#FF3B30",
            backgroundContrast: 0.85,
            
            // Glass
            glassOpacity: 0.04,
            glassBorder: 0.20,
            glassShadow: 0.12,
            
            // Typography
            fontFamily: "Segoe UI",
            fontSizeH1: 28,
            fontSizeH2: 20,
            fontSizeBody: 13,
            letterSpacing: 0.8,
            
            // Motion
            motionProfile: "sharp",
            transitionFast: 120,
            transitionNormal: 220,
            transitionSlow: 350,
            easingType: Easing.OutQuart,
            
            // Orb
            orbStyle: "geometric",
            useGeometricOrb: true,
            orbGlowIntensity: 0.15,
            orbPulseSpeed: 2500,
            
            // Gradients
            useGradient: false,
            gradientStart: "#12141A",
            gradientCenter: "#0A0C0F",
            gradientEnd: "#050608",
            orbGradientCenter: "#E0E8F0",
            orbGradientEdge: "#4080A0"
        }
    })
    
    // ─────────────────────────────────────────────────────
    // PUBLIC API
    // ─────────────────────────────────────────────────────
    
    function setTheme(themeId) {
        if (themes[themeId]) {
            console.log("ThemeManager: Switching to " + themeId)
            activeThemeId = themeId
            themeChanged(themeId)
        } else {
            console.warn("ThemeManager: Unknown theme " + themeId)
        }
    }
    
    function setWallpaper(wallpaper) {
        console.log("ThemeManager: Setting wallpaper to " + wallpaper)
        wallpaperId = wallpaper
        wallpaperChanged(wallpaper)
    }
    
    function getThemeList() {
        return Object.keys(themes)
    }
    
    function getThemeInfo(themeId) {
        return themes[themeId] || null
    }
}
