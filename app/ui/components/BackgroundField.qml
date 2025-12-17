import QtQuick 2.15

Item {
    id: root
    anchors.fill: parent

    // ═══════════════════════════════════════════════════════
    // AMBIENT BACKGROUND SYSTEM
    // Light-leaning atmospheric gradient with glass support
    // Dynamic wallpaper switching with crossfade
    // ═══════════════════════════════════════════════════════
    
    // External inputs
    property string assistantState: "IDLE"
    property string currentWallpaper: "ambient_sky.png"
    property color glowColor: "#6FAED9"
    property real glowStrength: 0.06
    property bool assistantActive: assistantState !== "IDLE"

    // ─────────────────────────────────────────────────────
    // LAYER 6: FOCUS DIMMER (Simplification for Active Mode)
    // ─────────────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: assistantActive ? 0.4 : 0.0 // Dim background substantially
        z: 100
        Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
    }

    // ─────────────────────────────────────────────────────
    // LAYER 1: Ambient Image (Dynamic Wallpaper)
    // ─────────────────────────────────────────────────────
    Image {
        id: wallpaper
        anchors.fill: parent
        source: "../../assets/wallpapers/" + currentWallpaper
        fillMode: Image.PreserveAspectCrop
        smooth: true
        opacity: 0.85
        
        onStatusChanged: {
            if (status === Image.Error) console.error("BackgroundField: Error loading " + source)
            else if (status === Image.Ready) console.log("BackgroundField: Loaded " + source)
        }
        
        // Very slow parallax drift (barely perceptible)
        SequentialAnimation on x {
            loops: Animation.Infinite
            NumberAnimation { to: 10; duration: 30000; easing.type: Easing.InOutSine }
            NumberAnimation { to: -10; duration: 30000; easing.type: Easing.InOutSine }
        }
        
        // Slow opacity drift
        SequentialAnimation on opacity {
            loops: Animation.Infinite
            NumberAnimation { to: 0.95; duration: 12000; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.85; duration: 12000; easing.type: Easing.InOutSine }
        }
        
        // Crossfade on source change
        Behavior on source {
            SequentialAnimation {
                NumberAnimation { target: wallpaper; property: "opacity"; to: 0; duration: 200 }
                PropertyAction { }
                NumberAnimation { target: wallpaper; property: "opacity"; to: 0.85; duration: 400 }
            }
        }
    }

    // ─────────────────────────────────────────────────────
    // LAYER 2: Gradient Overlay (Unifies colors, adds depth)
    // ─────────────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0.04, 0.06, 0.1, 0.3) }
            GradientStop { position: 0.5; color: "transparent" }
            GradientStop { position: 1.0; color: Qt.rgba(0.02, 0.04, 0.08, 0.5) }
        }
    }

    // ─────────────────────────────────────────────────────
    // LAYER 3: Glass Tint (Removes "photo" feel)
    // Cool blue-white tint for premium glass aesthetic
    // ─────────────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0.85, 0.9, 1.0, 0.08)
    }

    // ─────────────────────────────────────────────────────
    // LAYER 4: Orb Glow Field (Reactive ambient light)
    // Subtle radial emanating from orb position
    // ─────────────────────────────────────────────────────
    Rectangle {
        id: orbGlow
        width: parent.width * 0.8
        height: parent.width * 0.8
        radius: width / 2
        
        // Position towards right side (where orb lives)
        anchors.right: parent.right
        anchors.rightMargin: -parent.width * 0.15
        anchors.verticalCenter: parent.verticalCenter
        
        color: {
            switch(assistantState) {
                case "LISTENING": return Qt.rgba(0.3, 0.9, 1.0, glowStrength)
                case "THINKING": return Qt.rgba(1.0, 0.8, 0.3, glowStrength)
                case "RESPONDING": return Qt.rgba(0.3, 1.0, 0.5, glowStrength)
                default: return Qt.rgba(0.6, 0.8, 1.0, glowStrength * 0.5)
            }
        }
        
        Behavior on color { ColorAnimation { duration: 1200 } }
        
        // Soft breathing
        SequentialAnimation on opacity {
            loops: Animation.Infinite
            NumberAnimation { to: 1.0; duration: 6000; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.7; duration: 6000; easing.type: Easing.InOutSine }
        }
    }

    // ─────────────────────────────────────────────────────
    // LAYER 5: Vignette (Subtle edge darkening)
    // Focuses attention toward center
    // ─────────────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.7; color: "transparent" }
            GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.25) }
        }
    }
}
