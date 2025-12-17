import QtQuick 2.15
import QtQuick.Layouts 1.15
import Theme 1.0


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
    
    signal clicked()
    
    // Theme-aware values (Single Source of Truth)
    property int _radius: Theme.tileRadius
    property real _glassOpacity: Theme.glassOpacity * 0.9 // Reduced by 10% for Phase 3 focus
    property real _borderOpacity: Theme.tileBorderOpacity
    property real _shadowOpacity: Theme.tileShadowOpacity
    property int _transition: Theme.transitionNormal
    
    // Text colors (from Theme adaptive system)
    property color _primaryText: Theme.textPrimary
    property color _secondaryText: Theme.textSecondary

    // ═══════════════════════════════════════════════════════
    // GLASS PANEL WITH CONTRAST LAYER
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
        
        // CONTRAST LAYER - dark backing for text readability
        color: Qt.rgba(0, 0, 0, Theme.tileBackingOpacity)
        
        // Glass overlay on top
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: Qt.rgba(1, 1, 1, highlighted ? _glassOpacity + 0.04 : _glassOpacity)
        }
        
        // Border
        border.width: 1
        border.color: highlighted 
            ? Qt.rgba(1, 1, 1, _borderOpacity + 0.2)
            : Qt.rgba(1, 1, 1, _borderOpacity)
        
        Behavior on border.color { ColorAnimation { duration: _transition } }
        Behavior on radius { NumberAnimation { duration: _transition } }
        
        // Inner light gradient (top-lit glass effect)
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.08) }
                GradientStop { position: 0.15; color: Qt.rgba(1, 1, 1, 0.03) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }
    }
    
    // Top edge highlight (glass refraction)
    Rectangle {
        width: parent.width - 40
        height: 1
        anchors.horizontalCenter: parent.horizontalCenter
        y: 1
        radius: 1
        opacity: 0.6
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.3; color: Qt.rgba(1, 1, 1, 0.3) }
            GradientStop { position: 0.7; color: Qt.rgba(1, 1, 1, 0.3) }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }

    // ═══════════════════════════════════════════════════════
    // CONTENT LAYER
    // ═══════════════════════════════════════════════════════
    
    // Icon (subtle, top-right)
    Image {
        source: root.icon
        width: 18 * root.uiScale
        height: 18 * root.uiScale
        opacity: 0.4
        anchors.top: parent.top
        anchors.topMargin: 16
        anchors.right: parent.right
        anchors.rightMargin: 16
        visible: root.icon !== ""
        mipmap: true
    }
    
    // Status hint (micro-content, top-right)
    Text {
        visible: root.statusHint !== ""
        text: root.statusHint
        font.pixelSize: 9
        font.weight: Font.Medium
        font.letterSpacing: 0.8
        color: Theme.colorSuccess
        opacity: 0.9
        anchors.top: parent.top
        anchors.topMargin: 38
        anchors.right: parent.right
        anchors.rightMargin: 16
        font.family: FontRegistry.current.name
    }

    // Main content column with TEXT HIERARCHY
    Column {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 20
        spacing: 4

        // TIER 1: Label (small, subdued)
        Text {
            text: root.title
            font.pixelSize: 11
            font.weight: Font.Medium
            font.letterSpacing: 1.4
            font.capitalization: Font.AllUppercase
            opacity: 0.65
            color: _secondaryText
            font.family: FontRegistry.current.name
        }

        // TIER 2: Primary Value (MUST POP)
        Text {
            text: root.value
            font.pixelSize: 26
            font.weight: Font.DemiBold
            opacity: 1.0
            color: _primaryText
            font.family: FontRegistry.current.name
            
            // Micro shadow for edge definition
            layer.enabled: true
            layer.effect: Item {
                // Simple shadow approximation without QtGraphicalEffects
            }
        }

        // TIER 3: Metadata (quiet, readable)
        Text {
            text: root.subtitle
            font.pixelSize: 12
            font.weight: Font.Normal
            opacity: 0.55
            color: _secondaryText
            font.family: FontRegistry.current.name
            visible: root.subtitle !== ""
        }
    }

    // ═══════════════════════════════════════════════════════
    // INTERACTION (Theme-Aware)
    // ═══════════════════════════════════════════════════════
    
    property real _hoverLift: Theme.themes[Theme.activeThemeId].tileHoverLift !== undefined 
        ? Theme.themes[Theme.activeThemeId].tileHoverLift : 0
    property real _pressScale: Theme.themes[Theme.activeThemeId].tilePressScale !== undefined 
        ? Theme.themes[Theme.activeThemeId].tilePressScale : 0.97
    property int _fastTransition: Theme.transitionFast
    
    property bool _hovered: false
    property bool _pressed: false
    
    transform: Translate {
        y: _hovered ? -_hoverLift : 0
        Behavior on y { 
            NumberAnimation { 
                easing.type: Theme.easingType 
            } 
        }
    }
    
    scale: _pressed ? _pressScale : 1.0
    Behavior on scale { 
        NumberAnimation { 
            duration: _fastTransition * 0.5; 
            easing.type: Easing.OutQuart 
        } 
    }

    states: State {
        name: "active"
        when: root.highlighted
        PropertyChanges { target: root; scale: 1.015 }
    }

    transitions: Transition {
        NumberAnimation { properties: "scale"; duration: _transition; easing.type: Easing.OutCubic }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: {
            _hovered = true
            if (_hoverLift === 0) {
                glassPanel.color = Qt.rgba(0, 0, 0, 0.40)
            } else {
                glassPanel.color = Qt.rgba(0, 0, 0, 0.38)
            }
            glassPanel.border.color = Qt.rgba(1, 1, 1, _borderOpacity + 0.15)
        }
        onExited: {
            _hovered = false
            glassPanel.color = Qt.rgba(0, 0, 0, 0.35)
            glassPanel.border.color = Qt.rgba(1, 1, 1, highlighted ? _borderOpacity + 0.2 : _borderOpacity)
        }
        onPressed: _pressed = true
        onReleased: _pressed = false
        onClicked: root.clicked()
    }
}
