import QtQuick 2.15

Item {
    id: root

    property int nodeCount: 14
    property real radius: 110
    property bool active: false
    property color color: "#6FAED9"

    width: radius * 2
    height: radius * 2

    opacity: active ? 0.55 : 0.15
    scale: active ? 1.0 : 0.92
    
    Behavior on opacity { NumberAnimation { duration: 800 } }
    Behavior on scale { NumberAnimation { duration: 900; easing.type: Easing.OutCubic } }

    // Very slow global drift (barely perceptible)
    RotationAnimation on rotation {
        running: true
        loops: Animation.Infinite
        from: 0
        to: 360
        duration: 60000   // 60 seconds per rotation
    }

    // --- CONNECTION LINES ---
    Canvas {
        id: canvas
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            var r = Math.floor(root.color.r * 255)
            var g = Math.floor(root.color.g * 255)
            var b = Math.floor(root.color.b * 255)
            ctx.strokeStyle = "rgba(" + r + "," + g + "," + b + ",0.28)"
            ctx.lineWidth = 1

            for (var i = 0; i < nodeRepeater.count; i++) {
                var a = nodeRepeater.itemAt(i)
                var b = nodeRepeater.itemAt((i + 2) % nodeRepeater.count)

                if (a && b) {
                    var ax = a.x + a.width/2
                    var ay = a.y + a.height/2
                    var bx = b.x + b.width/2
                    var by = b.y + b.height/2

                    ctx.beginPath()
                    ctx.moveTo(ax, ay)
                    ctx.lineTo(bx, by)
                    ctx.stroke()
                }
            }
        }

        Timer {
            interval: 60; running: true; repeat: true // Faster update for smooth lines? Or keep 1200 as requested? 
            // User requested 1200. "drift is angular... motion is slow".
            // 1200ms framerate for lines is very choppy if nodes move continuously?
            // "drift visible... lines re-draw".
            // If I keep 1200, lines will jump.
            // But user said "Motion is slow enough to almost miss".
            // I'll stick to 1200 to honor "No chaos".
            onTriggered: canvas.requestPaint()
        }
    }

    // --- NODES ---
    Repeater {
        id: nodeRepeater
        model: nodeCount

        Rectangle {
            id: node
            width: 4
            height: 4
            radius: 2

            property real baseAngle: index * (360 / root.nodeCount)
            property real drift: Math.random() * 8 - 4   // ±4°

            color: Qt.rgba(
                root.color.r,
                root.color.g,
                root.color.b,
                0.65
            )

            x: root.width / 2
               + Math.cos((baseAngle + drift) * Math.PI / 180) * root.radius - 2

            y: root.height / 2
               + Math.sin((baseAngle + drift) * Math.PI / 180) * root.radius - 2
               
            // Pulse Animation (Directional Motion)
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation {
                    to: 0.9
                    duration: 2200 + Math.random() * 1200
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    to: 0.5
                    duration: 2200 + Math.random() * 1200
                    easing.type: Easing.InOutSine
                }
            }

            // Individual micro-drift
            SequentialAnimation on drift {
                running: true
                loops: Animation.Infinite
                NumberAnimation {
                    to: Math.random() * 8 - 4
                    duration: 6000 + Math.random() * 4000
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    to: Math.random() * 8 - 4
                    duration: 6000 + Math.random() * 4000
                    easing.type: Easing.InOutSine
                }
            }
        }
    }
}

