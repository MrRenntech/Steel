pragma Singleton
import QtQuick 2.15
import QtQuick 2.15

// ═════════════════════════════════════════════════════════════════════════
// GLOBAL THEME SINGLETON
// The Single Source of Truth for Design, Motion, and Assets.
// ═════════════════════════════════════════════════════════════════════════

QtObject {
    id: root

    // ─────────────────────────────────────────────────────────────────────────
    // 1. STATE & IDENTITY
    // ─────────────────────────────────────────────────────────────────────────
    property string activeThemeId: "bmw"
    property string activeWallpaperId: "ambient_sky.png"
    
    // Derived light/dark mode for text contrast (User requested contrast-aware text)
    property bool lightWallpaper: wallpaperLuminance > 0.65
    property real wallpaperLuminance: wallpapers[activeWallpaperId] 
        ? wallpapers[activeWallpaperId].luminance : 0.25

    // Public Signals
    signal themeChanged(string id)
    signal wallpaperChanged(string id)
    
    // Connect to Python's theme and wallpaper changes
    property var _connections: Connections {
        target: app
        function onThemeChanged() {
            if (app && app.currentTheme) {
                console.log("Theme.qml: Python requested theme: " + app.currentTheme)
                root.applyTheme(app.currentTheme)
            }
        }
        function onWallpaperChanged() {
            if (app && app.currentWallpaper) {
                console.log("Theme.qml: Python requested wallpaper: " + app.currentWallpaper)
                root.setWallpaper(app.currentWallpaper)
            }
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // 2. TEXT TOKENS (Responsive to Wallpaper)
    // ─────────────────────────────────────────────────────────────────────────
    // If light wallpaper -> Dark text. Else -> Light text.
    property color textPrimary: lightWallpaper ? "#0F0F0F" : "#F5F7FA"
    property color textSecondary: lightWallpaper ? "#333333" : "#CBD1D8"
    property color textMuted: lightWallpaper ? "#555555" : "#9AA2AD"

    // Opacity Levels (Constant)
    property real opPrimary: 1.0       
    property real opSecondary: 0.75    
    property real opMuted: 0.55        
    
    // Readability Layer (Darkens background if needed)
    property real readabilityOpacity: lightWallpaper ? 0.05 : 0.22 

    // ─────────────────────────────────────────────────────────────────────────
    // 3. FONT SYSTEM
    // ─────────────────────────────────────────────────────────────────────────
    // Active font based on theme

    
    // ─────────────────────────────────────────────────────────────────────────
    // 4. GEOMETRY & GLASS (Proxied)
    // ─────────────────────────────────────────────────────────────────────────
    property int tileRadius: themes[activeThemeId].tileRadius
    property real tileBlur: themes[activeThemeId].tileBlur
    property real tileBorderOpacity: themes[activeThemeId].tileBorderOpacity
    property real tileShadowOpacity: themes[activeThemeId].tileShadowOpacity
    property int radiusPanel: themes[activeThemeId].radiusPanel
    property int padding: themes[activeThemeId].padding

    // Glass Values
    property real glassOpacity: themes[activeThemeId].glassOpacity
    property real glassBorder: themes[activeThemeId].glassBorder
    property real glassShadow: themes[activeThemeId].glassShadow
    property real tileBackingOpacity: 0.35

    // ─────────────────────────────────────────────────────────────────────────
    // 5. COLORS (Theme Identity)
    // ─────────────────────────────────────────────────────────────────────────
    property color accentColor: themes[activeThemeId].accentColor
    property color backgroundColor: themes[activeThemeId].backgroundColor
    property color colorSuccess: themes[activeThemeId].colorSuccess
    property color colorWarning: themes[activeThemeId].colorWarning
    property color colorError: themes[activeThemeId].colorError
    property real backgroundContrast: themes[activeThemeId].backgroundContrast

    // ─────────────────────────────────────────────────────────────────────────
    // 6. MOTION & ORB
    // ─────────────────────────────────────────────────────────────────────────
    property string motionProfile: themes[activeThemeId].motionProfile
    property int motionSpeed: themes[activeThemeId].transitionNormal
    property int transitionFast: themes[activeThemeId].transitionFast
    property int transitionNormal: themes[activeThemeId].transitionNormal
    property int transitionSlow: themes[activeThemeId].transitionSlow
    property int easingType: themes[activeThemeId].easingType

    // Orb
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

    // ─────────────────────────────────────────────────────────────────────────
    // 7. API METHODS
    // ─────────────────────────────────────────────────────────────────────────
    function applyTheme(themeId) {
        if (themes[themeId]) {
            console.log("Theme.qml: Switching to " + themeId)
            activeThemeId = themeId
            
            // STRICT FONT REGISTRY UPDATE
            if (themeId === "bmw") {
                FontRegistry.current = FontRegistry.bmw
                Typography.letterSpacing = 0.2
            } else if (themeId === "audi") {
                FontRegistry.current = FontRegistry.audi
                Typography.letterSpacing = 0.6
            } else if (themeId === "bentley") {
                FontRegistry.current = FontRegistry.bentley
                Typography.letterSpacing = 0.1
            }

            themeChanged(themeId)
        } else {
            console.warn("Theme.qml: Unknown theme " + themeId)
        }
    }
    
    function setWallpaper(wallpaperId) {
        if (wallpapers[wallpaperId]) {
            console.log("Theme.qml: Setting wallpaper to " + wallpaperId)
            activeWallpaperId = wallpaperId
            wallpaperChanged(wallpapers[wallpaperId].source)
        } else {
            console.warn("Theme.qml: Unknown wallpaper " + wallpaperId)
        }
    }
    
    // Helpers
    function getThemeList() { return Object.keys(themes) }
    function getWallpaperList() { return Object.keys(wallpapers) }
    function getActiveWallpaperSource() { 
        return wallpapers[activeWallpaperId] ? wallpapers[activeWallpaperId].source : "ambient_sky.png" 
    }

    // ─────────────────────────────────────────────────────────────────────────
    // 8. DATA REGISTRIES (Internal)
    // ─────────────────────────────────────────────────────────────────────────
    
    // Wallpapers
    property var wallpapers: ({
        "ambient_sky.png": { name: "Ambient Sky", source: "ambient_sky.png", luminance: 0.25, mood: "calm" },
        "warm_dawn.png":   { name: "City Dawn",   source: "warm_dawn.png",   luminance: 0.55, mood: "warm" },
        "glass_fog.png":   { name: "Glass City",   source: "glass_fog.png",   luminance: 0.70, mood: "neutral" },
        "soft_horizon.png":{ name: "Nordic Landscape",source: "soft_horizon.png",luminance: 0.60, mood: "calm" },
        "bmw.png":         { name: "Midnight City", source: "bmw.png", luminance: 0.10, mood: "dark" },
        "bentley.png":     { name: "Royal Estate", source: "bentley.png", luminance: 0.30, mood: "luxury" }
    })

    // Themes
    property var themes: ({
        "bmw": {
            id: "bmw", name: "BMW", description: "Clean, technical",
            fontFamily: Fonts.inter,
            fontWeightPrimary: Font.Medium, fontWeightSecondary: Font.Normal,
            tileRadius: 18, tileBlur: 0, tileBorderOpacity: 0.15, tileShadowOpacity: 0.30, radiusPanel: 24, padding: 24,
            accentColor: "#2E86C1", backgroundColor: "#000000",
            colorSuccess: "#66BB6A", colorWarning: "#FFA726", colorError: "#EF5350", backgroundContrast: 1.0,
            glassOpacity: 0.08, glassBorder: 0.15, glassShadow: 0.30,
            motionProfile: "organic", transitionFast: 180, transitionNormal: 420, transitionSlow: 600, easingType: Easing.OutCubic,
            orbStyle: "organic", useGeometricOrb: false, orbGlowIntensity: 0.3, orbPulseSpeed: 4000,
            useGradient: true, gradientStart: "#141414", gradientCenter: "#0A0A0A", gradientEnd: "#000000",
            orbGradientCenter: "#A0D8EF", orbGradientEdge: "#2E86C1"
        },
        "audi": {
            id: "audi", name: "AUDI", description: "Sharp, technical",
            fontFamily: Fonts.montserrat,
            fontWeightPrimary: Font.Light, fontWeightSecondary: Font.ExtraLight,
            tileRadius: 6, tileBlur: 0.25, tileBorderOpacity: 0.25, tileShadowOpacity: 0.08, radiusPanel: 8, padding: 18,
            accentColor: "#EAEAEA", backgroundColor: "#08090B",
            colorSuccess: "#00E676", colorWarning: "#FF9100", colorError: "#FF1744", backgroundContrast: 1.15,
            glassOpacity: 0.03, glassBorder: 0.25, glassShadow: 0.08,
            motionProfile: "sharp", transitionFast: 80, transitionNormal: 180, transitionSlow: 280, easingType: Easing.OutQuart,
            orbStyle: "geometric", useGeometricOrb: true, orbGlowIntensity: 0.08, orbPulseSpeed: 1500,
            useGradient: false, gradientStart: "#0A0B0D", gradientCenter: "#08090B", gradientEnd: "#040506",
            orbGradientCenter: "#F0F0F0", orbGradientEdge: "#808080"
        },
        "bentley": {
            id: "bentley", name: "BENTLEY", description: "Elegant, luxurious",
            fontFamily: Fonts.playfair,
            fontWeightPrimary: Font.Normal, fontWeightSecondary: Font.Normal,
            tileRadius: 12, tileBlur: 0.06, tileBorderOpacity: 0.12, tileShadowOpacity: 0.25, radiusPanel: 20, padding: 28,
            accentColor: "#C9A962", backgroundColor: "#0D1210",
            colorSuccess: "#6B8E5A", colorWarning: "#D4A853", colorError: "#A65454", backgroundContrast: 0.65,
            glassOpacity: 0.10, glassBorder: 0.12, glassShadow: 0.35,
            motionProfile: "stately", transitionFast: 250, transitionNormal: 500, transitionSlow: 800, easingType: Easing.InOutQuad,
            orbStyle: "organic", useGeometricOrb: false, orbGlowIntensity: 0.25, orbPulseSpeed: 6000,
            useGradient: true, gradientStart: "#1A1F1A", gradientCenter: "#0D1210", gradientEnd: "#050807",
            orbGradientCenter: "#F5EED9", orbGradientEdge: "#C9A962"
        }
    })
}
