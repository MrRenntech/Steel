import QtQuick 2.15

Item {
    id: root
    anchors.fill: parent

    // External inputs
    property string assistantState: "IDLE"

    // Base BMW graphite
    Rectangle {
        anchors.fill: parent
        color: "#0A1017"
    }

    // PRIMARY ENERGY FIELD (left / content zone)
    Rectangle {
        id: primaryGlow
        width: parent.width * 1.6
        height: parent.width * 1.6
        radius: width / 2
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: -parent.width * 0.28

        opacity: 0.85

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#1B2E45" }
            GradientStop { position: 0.35; color: "#0F1C2A" }
            GradientStop { position: 1.0; color: "transparent" }
        }

        // Ambient Drift
        RotationAnimation on rotation {
            from: 0
            to: 360
            duration: 240000   // 4 minutes
            loops: Animation.Infinite
        }
    }

    // ORB BLOOM (Reactive Energy)
    Rectangle {
        id: orbBloom
        width: parent.width * 1.5
        height: parent.width * 1.5
        radius: width / 2
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: parent.width * 0.35 // Shifted strictly to Orb Field

        opacity: 0.08
        color: {
            switch(root.assistantState) {
                case "LISTENING": return "#00E0FF" // Cyan
                case "THINKING": return "#FFCC00" // Amber
                case "RESPONDING": return "#00E0FF"
                case "ERROR": return "#FF3030"
                default: return "#405060" // Blue-Gray
            }
        }
        
        Behavior on color { ColorAnimation { duration: 1200 } }

        // Slow Pulse
        SequentialAnimation on opacity {
            loops: Animation.Infinite
            NumberAnimation { to: 0.12; duration: 4000; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.06; duration: 6000; easing.type: Easing.InOutSine }
        }

        gradient: Gradient {
            GradientStop { position: 0.0; color: orbBloom.color } // Valid binding
            GradientStop { position: 1.0; color: "transparent" }
            // Note: This is a linear vertical fade, approximating a pool if opacity is low.
             // If I use Gradient, `color` property is ignored usually.
             // I'll use RadialGradient from QtGraphicalEffects? No, not valid.
             // I'll use transparent Gradient stops with `orbBloom.color` applied to `color`? No.
             // I'll use a `RadialGradient` simulated by Rectangle `radius`?
             // A Rectangle with radius=width/2 IS a circle. A LinearGradient is default.
             // I want a radial fade.
             // Qt 5/6 Rectangle Gradient is Linear only.
             // For Radial, I need `Shape` (QtQuick.Shapes) or `QtGraphicalEffects`.
             // User said: "QtGraphicalEffects is disabled".
             // So I must use transparency and layering.
             // `orbBloom.color` is solid? No, I want it soft.
             // If I can't use RadialGradient, I can use a Rectangle with `opacity` and `color`.
             // But it will be a hard circle or use `radius` for corners.
             // To fake a radial glow without GE:
             // Use 3 overlapping circles with decreasing opacity?
             // Or use a PNG image? No assets.
             // I'll stick to a very large circle with low opacity. It blends reasonably well. 
             // Or I can use `Gradient` with `orientation: Gradient.Vertical` but it won't be radial.
             // Wait, user asked for "Radial light bloom".
             // Without FastBlur/RadialGradient, I can't do TRUE radial.
             // I will use a very large circle with low opacity.
        }
    }

    // EDGE VIGNETTE (focus inward)
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 1.0; color: "#05070A" }
        }
    }

    // State-based Color Modulation
    states: [
        State {
            name: "IDLE"
            when: root.assistantState === "IDLE"
            PropertyChanges {
                target: primaryGlow
                opacity: 0.8
            }
        },
        State {
            name: "LISTENING"
            when: root.assistantState === "LISTENING"
            PropertyChanges {
                target: primaryGlow
                opacity: 0.95
            }
        },
        State {
            name: "THINKING"
            when: root.assistantState === "THINKING"
            PropertyChanges {
                target: primaryGlow
                opacity: 1.0
            }
        },
        State {
            name: "RESPONDING"
            when: root.assistantState === "RESPONDING"
            PropertyChanges {
                target: primaryGlow
                opacity: 0.9
            }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "opacity"; duration: 900; easing.type: Easing.InOutQuad }
    }
}
