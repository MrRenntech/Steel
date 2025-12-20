import QtQuick 2.15
import Theme 1.0

Item {
    id: root
    width: 200
    height: 320
    
    // ═══════════════════════════════════════════════════════
    // ARCHITECTURE: THE ORBITAL STACK
    // ═══════════════════════════════════════════════════════
    // This component renders the BMW-style "Thinking Orb".
    // 
    // LAYERS (Back to Front):
    // 1. [-3] Depth Plate: Anchor point, moves inversely to mouse (Parallax).
    // 2. [-2] Focus Plane: High contrast backing for readability.
    // 3. [-1] Field Noise: Subtle texture (Optional).
    // 4. [ 0] Ambient Glow: Proximity-reactive bloom.
    // 5. [ 1] Halo Ring: Floating indicator, follows mouse (Parallax).
    // 6. [ 2] Core Sphere: The physical object, pivots in 3D.
    //
    // GEOMETRY:
    // All layers are aligned to `orbCenterY` (100) to ensure perfect concentricity
    // while the 3D Rotation pivots around this same point.
    
    // ═══════════════════════════════════════════════════════
    // INPUTS
    // ═══════════════════════════════════════════════════════
    property string assistantState: "IDLE"
    property string activeTab: "CORE"
    property real audioLevel: 0.0
    property string assistantText: "" // Output text from Assistant
    property string interactionMode: "COMMAND"  // COMMAND or CONVERSATION
    signal clicked()

    // State helpers
    property bool listening: assistantState === "LISTENING" || assistantState === "PRE_LISTEN" || assistantState === "HOLDING"
    property bool thinking: assistantState === "THINKING" || assistantState === "PROCESSING"
    property bool responding: assistantState === "RESPONDING"
    property bool idle: assistantState === "IDLE"
    property bool active: !idle
    
    // Mode helpers (for visual cues)
    property bool conversationMode: interactionMode === "CONVERSATION"
    
    // Reset orb rotation when thinking stops
    onThinkingChanged: {
        if (!thinking) orb.rotation = 0
    }

    // Dynamic Opacity
    opacity: activeTab === "CORE" ? 1.0 : 0.35
    Behavior on opacity { NumberAnimation { duration: 600 } }

    // Theme helpers
    property color accentColor: Theme.themes[Theme.activeThemeId].accentColor || "#00D4FF"
    property color secondaryColor: Theme.themes[Theme.activeThemeId].primaryColor || "#FFFFFF"

    // ═══════════════════════════════════════════════════════
    // 3D INTERACTION LOGIC
    // ═══════════════════════════════════════════════════════
    property point mousePos: Qt.point(width/2, height/2)
    property bool hovering: false
    property real orbCenterY: 100 // Global Geometric Center
    
    // Parallax Math (Smoothed)
    property real parallaxX: (mousePos.x - width/2) / width
    property real parallaxY: (mousePos.y - height/2) / height
    
    property real smoothX: 0
    property real smoothY: 0
    
    Behavior on smoothX { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
    Behavior on smoothY { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
    
    // Pump the values
    onParallaxXChanged: smoothX = parallaxX
    onParallaxYChanged: smoothY = parallaxY

    // 3D Tilt Transform
    // 3D Tilt Transform
    transform: [
        Rotation {
            origin.x: width / 2
            origin.y: orbCenterY // Pivot around the Orb, not the container center
            axis { x: 1; y: 0; z: 0 }
            angle: -smoothY * 15 // Tilt X based on Y
        },
        Rotation {
            origin.x: width / 2
            origin.y: orbCenterY // Pivot around the Orb
            axis { x: 0; y: 1; z: 0 }
            angle: smoothX * 15 // Tilt Y based on X
        }
    ]

    // [DELETED] LAYER -10: GLOBAL CONTEXT DIMMER (Handled by main.qml Overlay now)

    // ═══════════════════════════════════════════════════════
    // LAYER -2: DEPTH PLATE (Rolled Back - Not a monument)
    // ═══════════════════════════════════════════════════════
    Rectangle {
        width: 300
        height: 300
        radius: width / 2
        color: Qt.rgba(0, 0, 0, 0.18) // Rolled back from 0.28
        
        // Parallax: Inverse, Heavy (Depth Anchor)
        // Center of Orb is at y=40 (margin) + 60 (half height) = 100
        x: (parent.width - width)/2 - (smoothX * 10)
        y: orbCenterY - (height/2) - (smoothY * 10)
        
        z: -3
        
        // Deep Shadow (Reduced Radius)
        Rectangle {
            z: -1
            width: parent.width + 20 // Reduced spread
            height: parent.height + 20
            radius: width / 2
            color: Qt.rgba(0, 0, 0, 0.45)
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 12 // Reduced offset
            visible: true
            opacity: 0.5 
        }
    }

    // ═══════════════════════════════════════════════════════
    // LAYER -1: FOCUS PLANE (Contrast Disc)
    // ═══════════════════════════════════════════════════════
    Rectangle {
        width: 260
        height: 260
        radius: width / 2
        color: Qt.rgba(0, 0, 0, 0.18)
        
        // Align to orbCenterY
        x: (parent.width - width)/2
        y: orbCenterY - (height/2)
        
        z: -2
    }

    // ═══════════════════════════════════════════════════════
    // LAYER 0: FIELD NOISE (Optional - Context)
    // ═══════════════════════════════════════════════════════
    Rectangle {
        id: fieldNoise
        // Align to orbCenterY
        x: (parent.width - width)/2
        y: orbCenterY - (height/2)
        
        width: 200
        height: 200
        radius: 100

        border.width: 0
        opacity: 0 
        
        Behavior on opacity { NumberAnimation { duration: 1000 } }
        color: Qt.rgba(1,1,1,0.02)
    }

    // ═══════════════════════════════════════════════════════
    // LAYER 1: AMBIENT GLOW (Bloom)
    // ═══════════════════════════════════════════════════════
    Rectangle {
        id: ambientGlow
        // Align to Orb Center (Parallax tracked via anchors)
        anchors.centerIn: undefined
        x: (parent.width - width)/2
        y: 100 - (height/2)
        width: orb.width + 60
        height: width
        radius: width / 2
        
        // Proximity Reactivity: Glow brightens when hovered
        property real proximityStart: hovering ? 0.4 : 0.0
        
        // Mode-based glow adjustment
        // CONVERSATION: Softer, warmer glow
        // COMMAND: Crisp accent color
        property real modeOpacity: conversationMode ? 0.35 : 0.25
        
        // State-dependent color
        color: listening ? Qt.rgba(accentColor.r, accentColor.g, accentColor.b, modeOpacity)
             : thinking ? Qt.rgba(1.0, 0.8, 0.3, 0.2)
             : responding ? Qt.rgba(0.2, 1.0, 0.6, 0.3 + (root.audioLevel * 0.2))
             : conversationMode ? Qt.rgba(1.0, 0.9, 0.8, 0.08 + proximityStart)  // Warmer idle in conversation
             : Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.05 + proximityStart)
        
        Behavior on color { ColorAnimation { duration: 800 } }
        
        scale: responding ? (1.0 + root.audioLevel * 0.15) : 1.0
        Behavior on scale { NumberAnimation { duration: 60; easing.type: Easing.OutQuad } }
        
        // Idle Breathing beat
        SequentialAnimation on opacity {
            loops: Animation.Infinite
            running: idle && !hovering // Pause on hover
            NumberAnimation { to: 0.8; duration: 4000; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.4; duration: 4000; easing.type: Easing.InOutSine }
        }
    }

    // ═══════════════════════════════════════════════════════
    // LAYER 2: HALO RING (Contextual)
    // ═══════════════════════════════════════════════════════
    Rectangle {
        id: haloRing
        width: 180
        height: 180
        radius: width / 2
        color: "transparent"
        
        // Parallax: Direct, Float (Forward)
        // Parallax: Direct, Float (Forward)
        // Center of Orb is at y=40 + 60 = 100
        x: (parent.width - width)/2 + (smoothX * 20)
        y: (100) - (height/2) + (smoothY * 20)
        
        // STEP 4 REFINEMENT: 1.5px (Calm) - softer in conversation mode
        border.width: conversationMode ? 1.0 : 1.5
        border.color: Qt.rgba(accentColor.r, accentColor.g, accentColor.b, conversationMode ? 0.45 : 0.65)
        
        // Animation: Breathing (IDLE) vs Tighten (LISTENING)
        // Focus Response: Tighten by ~4% when listening
        scale: listening ? 0.96 : (active ? 1.0 : scale) 
        
        SequentialAnimation on scale {
            loops: Animation.Infinite
            running: idle
            NumberAnimation { to: 1.03; duration: 4000; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.97; duration: 4000; easing.type: Easing.InOutSine }
        }
    
        Behavior on scale { NumberAnimation { duration: 400; easing.type: Easing.OutQuad } }
    }

    // ═══════════════════════════════════════════════════════
    // LAYER 3: CORE SPHERE (The physical object)
    // ═══════════════════════════════════════════════════════
    Rectangle {
        id: orb
        width: 120
        height: 120
        radius: width / 2
        
        // Pivot from center (Parallax: Medium)
        x: (parent.width - width)/2
        y: 40 // Keep top margin default
        anchors.topMargin: 40

        // Micro Shadow
        Rectangle {
            z: -1
            width: parent.width + 4
            height: parent.height + 4
            radius: width / 2
            color: Qt.rgba(0, 0, 0, 0.30)
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 6
            visible: true
        }

        // Thinking Rotation (Very Slow)
        RotationAnimation on rotation {
            from: 0
            to: 360
            duration: 14000
            loops: Animation.Infinite
            running: thinking
        }
        
        // Gradient simulation 
        // Focus Response: Increase contrast slightly on LISTENING
        gradient: Gradient {
            GradientStop { 
                position: 0.0 
                color: listening ? Qt.lighter(accentColor, 1.50) : Qt.lighter(accentColor, 1.35) 
                Behavior on color { ColorAnimation { duration: 400 } }
            }
            GradientStop { 
                position: 1.0 
                color: Qt.darker(secondaryColor, 1.6) 
            }
        }
        
        // Inner Glow
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.width: 0
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1,1,1,0.4) }
                GradientStop { position: 1.0; color: "transparent" }
            }
            opacity: 0.5
        }
    }

    // ═══════════════════════════════════════════════════════
    // MICRO-CONTEXT (One Clear Line)
    // ═══════════════════════════════════════════════════════
    
    // Status Text
    // ═══════════════════════════════════════════════════════
    // CONVERSATIONAL ANCHORS (State + Content)
    // ═══════════════════════════════════════════════════════
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: orb.bottom
        anchors.topMargin: 48
        spacing: 8
        visible: active // Only show when active
        
        // Line 1: STATE (Neutral)
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: listening ? "Listening" 
                : thinking ? "Thinking" 
                : responding ? "Speaking"
                : ""
            
            font.pixelSize: 14
            font.weight: Font.Medium
            opacity: 0.7
            color: Theme.textSecondary
            font.family: FontRegistry.current.name
            font.capitalization: Font.AllUppercase
            font.letterSpacing: 1.0
        }

        // Line 2: CONTENT (Dynamic Transcript)
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: assistantState === "HOLDING" ? "I'm listening..." 
                : assistantState === "PRE_LISTEN" ? "Listening..."
                : (assistantText !== "" ? assistantText : (listening ? "..." : ""))
            
            font.pixelSize: 22 // Larger, readable
            font.weight: Font.Medium
            wrapMode: Text.WordWrap
            width: 600 // Constrain width for readability
            horizontalAlignment: Text.AlignHCenter
            
            color: Theme.textPrimary
            font.family: FontRegistry.current.name
            
            Behavior on opacity { NumberAnimation { duration: 200 } }
        }
    }

    MouseArea {
        id: mouseTrack
        anchors.fill: parent
        anchors.margins: -100 // Extend interaction zone
        hoverEnabled: true
        onPositionChanged: {
            mousePos = Qt.point(mouseX, mouseY)
        }
        onEntered: hovering = true
        onExited: {
            hovering = false
            mousePos = Qt.point(width/2, height/2) // Reset
        }
        onClicked: root.clicked()
        cursorShape: Qt.PointingHandCursor
    }
}
