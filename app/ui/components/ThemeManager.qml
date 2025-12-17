import QtQuick 2.15

QtObject {
    id: root
    
    // ═══════════════════════════════════════════════════════
    // THEME MANAGER V2 (Central Authority)
    // All tiles, orb, blur, motion read ONLY from here
    // ═══════════════════════════════════════════════════════
    
    // Current active theme ID
    property string activeThemeId: "bmw"
    
    // Current active wallpaper
    property string activeWallpaperId: "ambient_sky"
    
    // Signals
    signal wallpaperChanged(string id)
    signal themeChanged(string id)
    
    // ─────────────────────────────────────────────────────
    // WALLPAPER REGISTRY (with luminance metadata)
    // ─────────────────────────────────────────────────────
    property var wallpapers: ({
        "ambient_sky": {
            name: "Ambient Sky",
            source: "ambient_sky.png",
            luminance: 0.25,        // Dark
            accentHint: "#6FAED9",  // Cool blue
            mood: "calm"
        },
        "warm_dawn": {
            name: "Warm Dawn",
            source: "warm_dawn.png",
            luminance: 0.55,        // Mid-tone
            accentHint: "#E8A87C",  // Warm orange
            mood: "warm"
        },
        "glass_fog": {
            name: "Glass Fog",
            source: "glass_fog.png",
            luminance: 0.70,        // Bright
            accentHint: "#B0C4DE",  // Light steel
            mood: "neutral"
        },
        "midnight": {
            name: "Midnight",
            source: "midnight.png",
            luminance: 0.10,        // Very dark
            accentHint: "#4A5568",  // Slate
            mood: "focus"
        },
        "aurora": {
            name: "Aurora",
            source: "aurora.png",
            luminance: 0.30,
            accentHint: "#48BB78",  // Green
            mood: "vibrant"
        }
    })
    
    // Current wallpaper properties
    property real wallpaperLuminance: wallpapers[activeWallpaperId] 
        ? wallpapers[activeWallpaperId].luminance : 0.25
    property string wallpaperId: wallpapers[activeWallpaperId] 
        ? wallpapers[activeWallpaperId].source : "ambient_sky.png"
    
    // ─────────────────────────────────────────────────────
    // ADAPTIVE TEXT (based on wallpaper luminance)
    // ─────────────────────────────────────────────────────
    property color primaryText: wallpaperLuminance > 0.6 
        ? "#0A0A0A" : "#FFFFFF"
    property color secondaryText: wallpaperLuminance > 0.6 
        ? "#444444" : "#CCCCCC"
    property real textOpacityPrimary: wallpaperLuminance > 0.6 
        ? 0.9 : 0.95
    property real textOpacitySecondary: wallpaperLuminance > 0.6 
        ? 0.6 : 0.5
    
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
    
    // Colors (theme base, but text adapts to wallpaper)
    property color accentColor: themes[activeThemeId].accentColor
    property color backgroundColor: themes[activeThemeId].backgroundColor
    property color primaryColor: primaryText  // ADAPTIVE
    property color secondaryColor: secondaryText  // ADAPTIVE
    property color textColor: primaryText  // ADAPTIVE
    property color colorSuccess: themes[activeThemeId].colorSuccess
    property color colorWarning: themes[activeThemeId].colorWarning
    property color colorError: themes[activeThemeId].colorError
    property real backgroundContrast: themes[activeThemeId].backgroundContrast
    
    // Glass
    property real glassOpacity: themes[activeThemeId].glassOpacity
    property real glassBorder: themes[activeThemeId].glassBorder
    property real glassShadow: themes[activeThemeId].glassShadow
    
    // Typography (per-theme identity)
    property string fontFamily: themes[activeThemeId].fontFamily
    property int fontWeightPrimary: themes[activeThemeId].fontWeightPrimary
    property int fontWeightSecondary: themes[activeThemeId].fontWeightSecondary
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
    // THEME REGISTRY
    // ─────────────────────────────────────────────────────
    property var themes: ({
        "bmw": {
            // Identity
            id: "bmw",
            name: "BMW",
            description: "Soft, organic",
            
            // Typography (BMW Type Next style → Inter fallback)
            fontFamily: "Inter, Segoe UI",
            fontWeightPrimary: Font.Medium,
            fontWeightSecondary: Font.Normal,
            fontSizeH1: 32,
            fontSizeH2: 24,
            fontSizeBody: 14,
            letterSpacing: 1.2,
            textTransform: "none",
            
            // Geometry (SOFT EDGES)
            tileRadius: 18,
            tileBlur: 0.08,
            tileBorderOpacity: 0.15,
            tileShadowOpacity: 0.30,
            radiusPanel: 28,
            padding: 24,
            
            // Tile Interaction (ORGANIC)
            tileHoverLift: 0,
            tilePressScale: 0.97,
            tileBreathingEnabled: true,
            
            // Colors
            accentColor: "#6FAED9",
            backgroundColor: "#0E141B",
            colorSuccess: "#4A7A68",
            colorWarning: "#BF9E60",
            colorError: "#8C2F2F",
            backgroundContrast: 0.7,
            
            // Glass (DEEP)
            glassOpacity: 0.08,
            glassBorder: 0.15,
            glassShadow: 0.30,
            
            // Motion (CALM)
            motionProfile: "calm",
            transitionFast: 200,
            transitionNormal: 420,
            transitionSlow: 600,
            easingType: Easing.OutCubic,
            
            // Orb (ORGANIC SOUL)
            orbStyle: "organic",
            useGeometricOrb: false,
            orbGlowIntensity: 0.3,
            orbPulseSpeed: 5000,
            orbSegments: 0,
            orbRingGap: 0,
            
            // Gradients
            useGradient: true,
            gradientStart: "#18202A",
            gradientCenter: "#121A24",
            gradientEnd: "#070B10",
            orbGradientCenter: "#D8E6F3",
            orbGradientEdge: "#5A8BB0",
            
            // Adaptive text behavior
            adaptiveText: true
        },
        
        "audi": {
            // Identity
            id: "audi",
            name: "AUDI",
            description: "Sharp, technical",
            
            // Typography (Audi Type Extended style → Montserrat fallback)
            fontFamily: "Montserrat, Segoe UI",
            fontWeightPrimary: Font.Light,
            fontWeightSecondary: Font.ExtraLight,
            fontSizeH1: 26,
            fontSizeH2: 18,
            fontSizeBody: 12,
            letterSpacing: 0.6,
            textTransform: "uppercase",
            
            // Geometry (HARD EDGES)
            tileRadius: 6,
            tileBlur: 0.25,
            tileBorderOpacity: 0.25,
            tileShadowOpacity: 0.08,
            radiusPanel: 8,
            padding: 18,
            
            // Tile Interaction (TECHNICAL)
            tileHoverLift: 3,
            tilePressScale: 0.98,
            tileBreathingEnabled: false,
            
            // Colors (HIGH CONTRAST)
            accentColor: "#EAEAEA",
            backgroundColor: "#08090B",
            colorSuccess: "#00E676",
            colorWarning: "#FF9100",
            colorError: "#FF1744",
            backgroundContrast: 1.15,
            
            // Glass (FLAT)
            glassOpacity: 0.03,
            glassBorder: 0.25,
            glassShadow: 0.08,
            
            // Motion (FAST, DIRECT)
            motionProfile: "sharp",
            transitionFast: 80,
            transitionNormal: 180,
            transitionSlow: 280,
            easingType: Easing.OutQuart,
            
            // Orb (GEOMETRIC MACHINE)
            orbStyle: "geometric",
            useGeometricOrb: true,
            orbGlowIntensity: 0.08,
            orbPulseSpeed: 1500,
            orbSegments: 12,
            orbRingGap: 4,
            
            // Gradients (FLAT)
            useGradient: false,
            gradientStart: "#0A0B0D",
            gradientCenter: "#08090B",
            gradientEnd: "#040506",
            orbGradientCenter: "#F0F0F0",
            orbGradientEdge: "#808080",
            
            // Adaptive text behavior
            adaptiveText: true
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
    
    function setWallpaper(wallpaperId) {
        if (wallpapers[wallpaperId]) {
            console.log("ThemeManager: Setting wallpaper to " + wallpaperId)
            activeWallpaperId = wallpaperId
            wallpaperChanged(wallpapers[wallpaperId].source)
        } else {
            console.warn("ThemeManager: Unknown wallpaper " + wallpaperId)
        }
    }
    
    function getThemeList() {
        return Object.keys(themes)
    }
    
    function getWallpaperList() {
        return Object.keys(wallpapers)
    }
    
    function getThemeInfo(themeId) {
        return themes[themeId] || null
    }
    
    function getWallpaperInfo(wallpaperId) {
        return wallpapers[wallpaperId] || null
    }
}
