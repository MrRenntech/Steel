import QtQuick 2.15

// ═══════════════════════════════════════════════════════
// GLASS CONTAINER
// Reusable light frosted glass panel with depth
// ═══════════════════════════════════════════════════════

Rectangle {
    id: glass
    radius: 28
    
    // Light glass, not dark
    color: Qt.rgba(1, 1, 1, 0.06)
    
    border.width: 1
    border.color: Qt.rgba(1, 1, 1, 0.18)
    
    // Manual shadow (no Qt5Compat needed)
    Rectangle {
        id: shadow
        anchors.fill: parent
        anchors.topMargin: 8
        anchors.leftMargin: 4
        anchors.rightMargin: -4
        anchors.bottomMargin: -14
        radius: parent.radius + 6
        color: Qt.rgba(0, 0, 0, 0.35)
        z: -1
    }
}
