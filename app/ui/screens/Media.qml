import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Item {
    id: root
    property var theme

    Rectangle {
        width: 600
        height: 400
        anchors.centerIn: parent
        color: Qt.rgba(0,0,0,0.7)
        radius: 20
        border.color: root.theme.primaryColor
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 30
            
            Text {
                text: "NOW PLAYING"
                color: root.theme.accentColor
                font.family: root.theme.fontFamily
                font.pixelSize: 16
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: "System Audio" 
                color: root.theme.primaryColor
                font.family: root.theme.fontFamily
                font.pixelSize: 32
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }
            
            RowLayout {
                spacing: 40
                Layout.alignment: Qt.AlignHCenter
                
                MediaBtn { text: "|<" }
                MediaBtn { text: "PLAY / PAUSE"; isPrimary: true }
                MediaBtn { text: ">|" }
            }
        }
    }
    
    component MediaBtn: Button {
        property bool isPrimary: false
        
        background: Rectangle {
            implicitWidth: isPrimary ? 160 : 60
            implicitHeight: 60
            color: isPrimary ? root.theme.primaryColor : "transparent"
            radius: 30
            border.color: root.theme.primaryColor
            border.width: 1
        }
        
        contentItem: Text {
            text: parent.text
            color: isPrimary ? root.theme.backgroundColor : root.theme.primaryColor
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
