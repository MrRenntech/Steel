import QtQuick 2.15

Item {
    id: root
    property int nodes: 12
    property real radius: 110
    property bool active: false
    property color color: "#6FAED9"
    
    width: radius * 2
    height: radius * 2
    visible: true 

    SequentialAnimation on opacity {
        running: true
        loops: Animation.Infinite
        NumberAnimation { to: active ? 0.85 : 0.35; duration: 1800; easing.type: Easing.InOutSine }
        NumberAnimation { to: active ? 0.65 : 0.25; duration: 1800; easing.type: Easing.InOutSine }
    }

    // Slow global rotation (almost imperceptible)
    RotationAnimation on rotation {
        running: active
        loops: Animation.Infinite
        from: 0
        to: 360
        duration: 28000   // VERY slow
    }

    Repeater {
        model: nodes

        Item {
            id: node
            property real angle: index * (360 / root.nodes)
            property real xPos: Math.cos(angle * Math.PI / 180) * root.radius
            property real yPos: Math.sin(angle * Math.PI / 180) * root.radius

            x: root.width / 2 + xPos
            y: root.height / 2 + yPos

            // NODE (Fix 3: Reduce visual dominance)
            Rectangle {
                width: 3
                height: 3
                radius: 1.5
                color: Qt.rgba(root.color.r, root.color.g, root.color.b, 0.35)
                anchors.centerIn: parent
            }

            // CONNECTION LINE (to next node)
            Canvas {
                id: nodeCanvas
                width: root.width
                height: root.height
                anchors.centerIn: parent
                // Fix: Canvas needs to repaint if geometry changes, but here it's static structure mostly.
                // Trigger repaint if color changes
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0,0,width,height)

                    var nextAngle = (index + 1) * (360 / root.nodes)
                    // Calculate next node position relative to center
                    var nx_rel = Math.cos(nextAngle * Math.PI / 180) * root.radius
                    var ny_rel = Math.sin(nextAngle * Math.PI / 180) * root.radius
                    
                    // Coordinates relative to Root Center:
                    // Current Node: xPos, yPos
                    // Next Node: nx_rel, ny_rel
                    
                    // Canvas Center is at (width/2, height/2) which corresponds to Current Node visual center.
                    // We want to draw from Center (Current Node) to Next Node.
                    
                    // Vector from Current to Next:
                    var dx = nx_rel - xPos
                    var dy = ny_rel - yPos
                    
                    // Destination in Canvas coords:
                    var destX = width/2 + dx
                    var destY = height/2 + dy

                    // Fix 3: Cognition whispers (low opacity lines)
                    ctx.strokeStyle = "rgba(111,174,217,0.12)"
                    ctx.lineWidth = 1
                    ctx.beginPath()
                    ctx.moveTo(width/2, height/2)
                    ctx.lineTo(destX, destY)
                    ctx.stroke()
                }
                
                // Redraw if properties change
                Connections {
                    target: root
                    function onColorChanged() { nodeCanvas.requestPaint() }
                    function onRadiusChanged() { nodeCanvas.requestPaint() }
                }

                Component.onCompleted: nodeCanvas.requestPaint()
            }
        }
    }
}
