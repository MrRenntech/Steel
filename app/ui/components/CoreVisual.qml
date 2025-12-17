import QtQuick 2.15

Item {
    id: root
    width: 200
    height: 320
    
    // ═══════════════════════════════════════════════════════
    // INPUTS
    // ═══════════════════════════════════════════════════════
    property var theme
    property string assistantState: "IDLE"
    property string activeTab: "CORE"
    property real audioLevel: 0.0
    signal clicked()

    // State helpers
    property bool listening: assistantState === "LISTENING"
    property bool thinking: assistantState === "THINKING"
    property bool responding: assistantState === "RESPONDING"
    property bool idle: assistantState === "IDLE"
    property bool active: !idle

    // Dynamic Opacity
    opacity: activeTab === "CORE" ? 1.0 : 0.35
    Behavior on opacity { NumberAnimation { duration: 600 } }

    // ═══════════════════════════════════════════════════════
    // SUBTLE DRIFT (Only when IDLE - calm floating)
    // ═══════════════════════════════════════════════════════
    property real driftOffset: 0
    SequentialAnimation on driftOffset {
        loops: Animation.Infinite
        running: idle
        NumberAnimation { to: 4; duration: 4500; easing.type: Easing.InOutSine }
        NumberAnimation { to: 0; duration: 4500; easing.type: Easing.InOutSine }
    }

    // ═══════════════════════════════════════════════════════
    // LAYER 1: AMBIENT GLOW (Outermost - state colored)
    // ═══════════════════════════════════════════════════════
    Rectangle {
        id: ambientGlow
        anchors.centerIn: orb
        anchors.verticalCenterOffset: idle ? driftOffset : 0
        width: orb.width + 60
        height: width
        radius: width / 2
        
        color: listening ? Qt.rgba(0.3, 0.9, 1.0, 0.08)
             : thinking ? Qt.rgba(1.0, 0.8, 0.3, 0.08)
             : responding ? Qt.rgba(0.3, 1.0, 0.5, 0.08)
             : Qt.rgba(0.6, 0.8, 1.0, 0.04)
        
        Behavior on color { ColorAnimation { duration: 800 } }
        
        // Breathing (IDLE only)
        SequentialAnimation on scale {
            loops: Animation.Infinite
            running: idle
            NumberAnimation { to: 1.05; duration: 5000; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.95; duration: 5000; easing.type: Easing.InOutSine }
        }
        
        // Pulse outward (RESPONDING)
        SequentialAnimation on scale {
            loops: Animation.Infinite
            running: responding
            NumberAnimation { to: 1.15; duration: 600; easing.type: Easing.OutQuad }
            NumberAnimation { to: 1.0; duration: 1200; easing.type: Easing.InOutSine }
        }
    }

    // ═══════════════════════════════════════════════════════
    // LAYER 2: RESPONSE FIELD (Visible during activity)
    // ═══════════════════════════════════════════════════════
    Rectangle {
        id: responseField
        anchors.centerIn: orb
        anchors.verticalCenterOffset: idle ? driftOffset : 0
        width: orb.width + 30
        height: width
        radius: width / 2
        color: "transparent"
        
        border.width: active ? 1.5 : 0
        border.color: listening ? Qt.rgba(0.4, 0.9, 1.0, 0.5)
                    : thinking ? Qt.rgba(1.0, 0.8, 0.3, 0.5)
                    : responding ? Qt.rgba(0.3, 1.0, 0.5, 0.5)
                    : "transparent"
        
        opacity: active ? 1.0 : 0
        Behavior on opacity { NumberAnimation { duration: 400 } }
        Behavior on border.color { ColorAnimation { duration: 600 } }
        
        // Rotation (THINKING only)
        RotationAnimation on rotation {
            from: 0; to: 360
            duration: 3000
            loops: Animation.Infinite
            running: thinking
        }
    }

    // ═══════════════════════════════════════════════════════
    // LAYER 3: INNER DEPTH RING (Detail layer)
    // ═══════════════════════════════════════════════════════
    Rectangle {
        id: depthRing
        anchors.centerIn: orb
        anchors.verticalCenterOffset: idle ? driftOffset : 0
        width: orb.width - 20
        height: width
        radius: width / 2
        color: "transparent"
        
        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.15)
        
        // Slow rotation (THINKING only)
        rotation: thinking ? depthRing.rotation : 0
        RotationAnimation on rotation {
            from: 0; to: -360
            duration: 8000
            loops: Animation.Infinite
            running: thinking
        }
    }

    // ═══════════════════════════════════════════════════════
    // LAYER 4: THE ORB (Central sphere with 3D illusion)
    // ═══════════════════════════════════════════════════════
    Rectangle {
        id: orb
        width: 130
        height: 130
        radius: width / 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 30
        y: y + (idle ? driftOffset : 0)

        // Base dark core
        color: Qt.rgba(0.05, 0.08, 0.12, 0.95)
        
        // Soft border (state colored)
        border.width: 1.5
        border.color: listening ? Qt.rgba(0.4, 0.9, 1.0, 0.6)
                    : thinking ? Qt.rgba(1.0, 0.8, 0.3, 0.6)
                    : responding ? Qt.rgba(0.3, 1.0, 0.5, 0.6)
                    : Qt.rgba(1, 1, 1, 0.2)

        Behavior on border.color { ColorAnimation { duration: 600 } }
        
        // Highlight layer (top-left lit - moves slowly)
        Rectangle {
            id: highlight
            anchors.fill: parent
            radius: parent.radius
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.3) }
                GradientStop { position: 0.25; color: Qt.rgba(0.6, 0.75, 0.9, 0.15) }
                GradientStop { position: 1.0; color: "transparent" }
            }
            
            // Specular shift left-right
            property real specularOffset: 0
            SequentialAnimation on specularOffset {
                loops: Animation.Infinite
                NumberAnimation { to: 5; duration: 6000; easing.type: Easing.InOutSine }
                NumberAnimation { to: -5; duration: 6000; easing.type: Easing.InOutSine }
            }
            anchors.horizontalCenterOffset: specularOffset
        }
        
        // Specular highlight (glass reflection)
        Rectangle {
            width: 50
            height: 22
            radius: 22
            anchors.top: parent.top
            anchors.topMargin: 12
            anchors.left: parent.left
            anchors.leftMargin: 22
            rotation: -12
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.55) }
                GradientStop { position: 1.0; color: "transparent" }
            }
            opacity: 0.7
        }

        // Inner glow (state color - core of intelligence)
        Rectangle {
            id: innerGlow
            width: 40
            height: 40
            radius: 20
            anchors.centerIn: parent
            color: listening ? "#00D4FF" 
                 : thinking ? "#FFCC00" 
                 : responding ? "#00FF88"
                 : Qt.rgba(0.6, 0.8, 1.0, 0.3)
            
            opacity: idle ? 0.1 : 0.4
            
            Behavior on color { ColorAnimation { duration: 400 } }
            Behavior on opacity { NumberAnimation { duration: 400 } }
            
            // Pulse when active
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                running: active
                NumberAnimation { to: 0.6; duration: 800; easing.type: Easing.InOutSine }
                NumberAnimation { to: 0.25; duration: 800; easing.type: Easing.InOutSine }
            }
        }

        // Audio reactivity (subtle scale - LISTENING only)
        scale: listening ? (1.0 + audioLevel * 0.12) : 1.0
        Behavior on scale { NumberAnimation { duration: 50; easing.type: Easing.OutQuad } }
    }

    // ═══════════════════════════════════════════════════════
    // LAYER 5: AUDIO WAVEFORM (LISTENING state only)
    // ═══════════════════════════════════════════════════════
    Row {
        id: waveform
        anchors.centerIn: orb
        anchors.verticalCenterOffset: idle ? driftOffset : 0
        spacing: 4
        opacity: listening ? 0.8 : 0
        
        Behavior on opacity { NumberAnimation { duration: 300 } }
        
        Repeater {
            model: 5
            Rectangle {
                width: 3
                height: {
                    var base = 12 + Math.abs(2 - index) * 6
                    return listening ? base + (audioLevel * 30 * (1 - Math.abs(2 - index) * 0.2)) : base
                }
                radius: 1.5
                color: Qt.rgba(0.4, 0.9, 1.0, 0.9)
                anchors.verticalCenter: parent.verticalCenter
                
                Behavior on height { NumberAnimation { duration: 60 } }
            }
        }
    }

    // ═══════════════════════════════════════════════════════
    // MICRO-CONTEXT (Status text below orb)
    // ═══════════════════════════════════════════════════════
    Column {
        anchors.top: orb.bottom
        anchors.topMargin: 28
        anchors.horizontalCenter: orb.horizontalCenter
        spacing: 6

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: listening ? "Listening" 
                : thinking ? "Processing" 
                : responding ? "Responding"
                : "Ready"
            font.pixelSize: 14
            font.weight: Font.Medium
            color: active ? Qt.rgba(1, 1, 1, 0.9) : Qt.rgba(1, 1, 1, 0.7)
            font.family: theme ? theme.fontFamily : "Segoe UI"
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: listening ? "Voice input active" 
                : thinking ? "Neural core processing" 
                : responding ? "Generating response"
                : "Click to activate"
            font.pixelSize: 11
            color: Qt.rgba(1, 1, 1, 0.45)
            font.family: theme ? theme.fontFamily : "Segoe UI"
        }
    }

    // ═══════════════════════════════════════════════════════
    // INTERACTION
    // ═══════════════════════════════════════════════════════
    MouseArea {
        anchors.fill: parent
        anchors.margins: -20
        onClicked: root.clicked()
        cursorShape: Qt.PointingHandCursor
    }
}
