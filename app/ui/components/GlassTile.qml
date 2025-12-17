import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    implicitWidth: 280
    implicitHeight: 140
    
    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight

    property string title: "TITLE"
    property string subtitle: ""
    property string value: ""
    property bool highlighted: false
    property var blurSource: null
    property string icon: ""
    property real uiScale: 1.0
    property string intent: ""
    property string statusHint: ""
    property var theme: null  // Theme reference
    
    signal clicked()
    
    // Theme-aware values
    property int _radius: theme ? theme.tileRadius : 20
    property real _glassOpacity: theme ? theme.glassOpacity : 0.08
    property real _borderOpacity: theme ? theme.tileBorderOpacity : 0.15
    property real _shadowOpacity: theme ? theme.tileShadowOpacity : 0.30
    property int _transition: theme ? theme.transitionNormal : 360

    // ═══════════════════════════════════════════════════════
    // TRUE GLASS PANEL (Theme-reactive)
    // ═══════════════════════════════════════════════════════
    
    // Shadow layer
    Rectangle {
        id: shadowLayer
        anchors.fill: glassPanel
        anchors.topMargin: 4
        anchors.leftMargin: 2
        anchors.rightMargin: -2
        anchors.bottomMargin: -8
        radius: glassPanel.radius + 4
        color: Qt.rgba(0, 0, 0, _shadowOpacity)
        z: -1
    }
    
    Rectangle {
        id: glassPanel
        anchors.fill: parent
        radius: _radius
        
        // Glass color
        color: Qt.rgba(1, 1, 1, highlighted ? _glassOpacity + 0.04 : _glassOpacity)
        
        // Border
        border.width: 1
        border.color: highlighted 
            ? Qt.rgba(1, 1, 1, _borderOpacity + 0.2)
            : Qt.rgba(1, 1, 1, _borderOpacity)
        
        Behavior on color { ColorAnimation { duration: _transition } }
        Behavior on border.color { ColorAnimation { duration: _transition } }
        Behavior on radius { NumberAnimation { duration: _transition } }
        
        // Inner light gradient (top-lit glass effect)
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.12) }
                GradientStop { position: 0.15; color: Qt.rgba(1, 1, 1, 0.04) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }
    }
    
    // Top edge highlight (glass refraction simulation)
    Rectangle {
        width: parent.width - 40
        height: 1
        anchors.horizontalCenter: parent.horizontalCenter
        y: 1
        radius: 1
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.3; color: Qt.rgba(1, 1, 1, 0.4) }
            GradientStop { position: 0.7; color: Qt.rgba(1, 1, 1, 0.4) }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }

    // ═══════════════════════════════════════════════════════
    // CONTENT LAYER (Z-3)
    // ═══════════════════════════════════════════════════════
    
    // Icon (subtle, top-right)
    Image {
        source: root.icon
        width: 20 * root.uiScale
        height: 20 * root.uiScale
        opacity: 0.5
        anchors.top: parent.top
        anchors.topMargin: 16
        anchors.right: parent.right
        anchors.rightMargin: 16
        visible: root.icon !== ""
        mipmap: true
    }
    
    // Status hint (micro-content, top-right below icon)
    Text {
        visible: root.statusHint !== ""
        text: root.statusHint
        font.pixelSize: 9
        font.weight: Font.Medium
        font.letterSpacing: 0.8
        color: theme.colorSuccess
        opacity: 0.8
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.right: parent.right
        anchors.rightMargin: 16
        font.family: theme.fontFamily
    }

    // Main content column
    Column {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 20
        spacing: 6

        // Category/Label (micro text)
        Text {
            text: root.title
            font.pixelSize: 11
            font.weight: Font.Medium
            font.letterSpacing: 1.6
            font.capitalization: Font.AllUppercase
            opacity: 0.5
            color: "white"
            font.family: theme.fontFamily
        }

        // Primary Value (main focus)
        Text {
            text: root.value
            font.pixelSize: 22
            font.weight: Font.DemiBold
            opacity: 0.95
            color: "white"
            font.family: theme.fontFamily
        }

        // Subtitle (contextual info)
        Text {
            text: root.subtitle
            font.pixelSize: 11
            font.weight: Font.Normal
            opacity: 0.4
            color: "white"
            font.family: theme.fontFamily
            visible: root.subtitle !== ""
        }
    }

    // ═══════════════════════════════════════════════════════
    // INTERACTION
    // ═══════════════════════════════════════════════════════
    
    states: State {
        name: "active"
        when: root.highlighted
        PropertyChanges { target: root; scale: 1.015 }
    }

    transitions: Transition {
        NumberAnimation { properties: "scale"; duration: 200; easing.type: Easing.OutCubic }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: {
            root.y -= 4 * root.uiScale
            glassPanel.color = Qt.rgba(1, 1, 1, 0.14)
        }
        onExited: {
            root.y += 4 * root.uiScale
            glassPanel.color = Qt.rgba(1, 1, 1, highlighted ? 0.12 : 0.08)
        }
        onPressed: root.scale = 0.98
        onReleased: root.scale = 1.0
        onClicked: root.clicked()
    }
    
    Behavior on y { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
}
