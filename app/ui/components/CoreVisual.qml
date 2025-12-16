import QtQuick 2.15

Item {
    id: root
    width: 250
    height: 250
    
    // Inputs
    property var theme
    property string assistantState: "IDLE" // "IDLE" | "LISTENING" | "THINKING" | "RESPONDING" | "ERROR"
    
    // Internal Animation Properties
    property color visualColor: theme.secondaryColor
    
    property real visualScale: 1.0
    Behavior on visualScale { 
        NumberAnimation { 
            duration: theme.motion ? theme.motion.attend : 600
            easing.type: theme.motion ? theme.motion.easingSoft : Easing.InOutQuad 
        } 
    }
    
    property real visualRotation: 0
    property int currentDuration: 1000
    
    Rectangle {
        id: core
        anchors.centerIn: parent
        width: 120
        height: 120
        radius: width/2
        color: root.visualColor
        border.color: theme.primaryColor
        border.width: 2
        
        // Unified Scale Pipeline: Base (State) * Modulation (Animation)
        property real modulationScale: 1.0
        
        // Text Label
        Text {
            anchors.centerIn: parent
            text: "STEEL"
            color: theme.textColor
            font.family: theme.fontFamily
            font.bold: true
            font.pixelSize: 14
            opacity: 0.9
        }
        
        // Continuous Transformations
        scale: root.visualScale * modulationScale
        rotation: root.visualRotation
        
        // Smooth transitions for STATE properties
        Behavior on color { ColorAnimation { duration: theme.motion.respond } }
        Behavior on rotation { NumberAnimation { duration: theme.motion.attend; easing.type: theme.motion.easingSoft } }
        
        // --- ANIMATIONS (Targeting modulationScale only) ---
        
        // IDLE: Breathe
        SequentialAnimation on modulationScale {
            id: animBreathe
            running: false
            loops: Animation.Infinite
            NumberAnimation { to: 1.05; duration: root.currentDuration; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.95; duration: root.currentDuration; easing.type: Easing.InOutSine }
        }
        
        // LISTENING: Attention Pulse (Expansion - Receptive)
        SequentialAnimation on modulationScale {
            id: animAttend
            running: false
            loops: Animation.Infinite
            NumberAnimation { to: 1.12; duration: root.currentDuration; easing.type: theme.motion.easingFocus }
            NumberAnimation { to: 1.0; duration: root.currentDuration; easing.type: Easing.InSine }
        }
        
        // RESPONDING: Fast Pulse (Contraction - Expressive)
        SequentialAnimation on modulationScale {
            id: animRespond
            running: false
            loops: Animation.Infinite
            NumberAnimation { to: 0.92; duration: root.currentDuration; easing.type: theme.motion.easingFocus }
            NumberAnimation { to: 1.0; duration: root.currentDuration; easing.type: Easing.InSine }
        }
        
        // ERROR: Tension (Slow heavy pulse, constrained)
        SequentialAnimation on modulationScale {
            id: animTension
            running: false
            loops: Animation.Infinite
            NumberAnimation { to: 1.02; duration: root.currentDuration; easing.type: Easing.InOutSine } 
            NumberAnimation { to: 0.98; duration: root.currentDuration; easing.type: Easing.InOutSine }
        }

        // THINKING: Rotation (Targeting parent rotation property directly via state, logic separate)
        RotationAnimation on rotation {
            id: animRotate
            running: false
            loops: Animation.Infinite
            from: 0; to: 360
            duration: root.currentDuration
            easing.type: theme.motion.easingFocus
        }
    }
    
    // State Mappings
    states: [
        State {
            name: "IDLE"
            when: root.assistantState === "IDLE"
            PropertyChanges { target: root; visualColor: theme.secondaryColor; currentDuration: theme.motion.breathe }
            PropertyChanges { target: core; modulationScale: 1.0 }
            PropertyChanges { target: animBreathe; running: true }
            PropertyChanges { target: animAttend; running: false }
            PropertyChanges { target: animRespond; running: false }
            PropertyChanges { target: animTension; running: false }
            PropertyChanges { target: animRotate; running: false }
        },
        State {
            name: "LISTENING"
            when: root.assistantState === "LISTENING"
            PropertyChanges { target: root; visualColor: theme.colorSuccess; currentDuration: theme.motion.attend }
            PropertyChanges { target: animBreathe; running: false }
            PropertyChanges { target: animAttend; running: true }
            PropertyChanges { target: animRespond; running: false }
            PropertyChanges { target: animTension; running: false }
            PropertyChanges { target: animRotate; running: false }
        },
        State {
            name: "THINKING"
            when: root.assistantState === "THINKING"
            PropertyChanges { target: root; visualColor: theme.colorWarning; currentDuration: theme.motion.think }
            PropertyChanges { target: core; modulationScale: 1.0 }
            PropertyChanges { target: animBreathe; running: true } 
            PropertyChanges { target: animAttend; running: false }
            PropertyChanges { target: animRespond; running: false }
            PropertyChanges { target: animTension; running: false }
            PropertyChanges { target: animRotate; running: true }
        },
        State {
            name: "RESPONDING"
            when: root.assistantState === "RESPONDING"
            PropertyChanges { target: root; visualColor: theme.primaryColor; currentDuration: theme.motion.respond }
            PropertyChanges { target: animBreathe; running: false }
            PropertyChanges { target: animAttend; running: false }
            PropertyChanges { target: animRespond; running: true }
            PropertyChanges { target: animTension; running: false }
            PropertyChanges { target: animRotate; running: false }
        },
        State {
            name: "ERROR"
            when: root.assistantState === "ERROR"
            PropertyChanges { target: root; visualColor: theme.colorError; currentDuration: theme.motion.error }
            PropertyChanges { target: animBreathe; running: false }
            PropertyChanges { target: animAttend; running: false }
            PropertyChanges { target: animRespond; running: false }
            PropertyChanges { target: animTension; running: true }
            PropertyChanges { target: animRotate; running: false }
        }
    ]
}
