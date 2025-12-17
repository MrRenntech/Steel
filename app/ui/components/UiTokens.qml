import QtQuick 2.15

QtObject {
    // ═════════════════════════════════════════════════════════════════════════
    // UI TOKENS (The Law)
    // ═════════════════════════════════════════════════════════════════════════

    // TEXT COLORS
    // ─────────────────────────────────────────────────────────────────────────
    property color textPrimary: "#F5F7FA"   // High visibility white-ish
    property color textSecondary: "#CBD1D8" // Soft contour
    property color textMuted: "#9AA2AD"     // Metadata / De-emphasized

    // TEXT OPACITY LAYERS (System-Wide Contrast)
    // ─────────────────────────────────────────────────────────────────────────
    // 1.0 = Critical data (Values, Headlines)
    property real opPrimary: 1.0       
    // 0.75 = Context (Labels, Units)
    property real opSecondary: 0.75    
    // 0.55 = Passive (Footnotes, Metadata)
    property real opMuted: 0.55        

    // SURFACES & GLASS
    // ─────────────────────────────────────────────────────────────────────────
    // Standard glass opacity for tiles
    property real glassOpacity: 0.18   
    // Subtle border definition
    property real glassBorderOpacity: 0.25 
    // Dimming layer behind text on busy backgrounds
    property real readabilityLayerOpacity: 0.22 

    // BLUR & SHADOW
    // ─────────────────────────────────────────────────────────────────────────
    property real backdropBlur: 28     // Premium glass feel
    property real shadowSoft: 0.25     // Elevated element shadow
    
    // FONTS (Profiles)
    // ─────────────────────────────────────────────────────────────────────────
    // These strings map to actual loaded fonts. theme.activeFont selects one.
    property string fontBMW: "Inter, Helvetica, Arial, sans-serif"
    property string fontAudi: "Montserrat, Verdana, sans-serif"
    property string fontBentley: "Times New Roman, Georgia, serif" // Or Playfair if available
}
