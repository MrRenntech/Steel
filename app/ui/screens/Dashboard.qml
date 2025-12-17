import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Theme 1.0

Item {
    id: root
    property var theme
    
    GridLayout {
        anchors.fill: parent
        anchors.margins: 40
        columns: 3
        columnSpacing: 20
        rowSpacing: 20
        
        // CPU Card
        StatCard { 
            title: "CPU LOAD"
            value: system.cpu + "%"
            icon: "cpu"
        }
        
        // RAM Card
        StatCard { 
            title: "MEMORY"
            value: system.ram + "%"
            icon: "memory"
        }
        
        // Battery Card
        StatCard { 
            title: "BATTERY"
            value: system.battery + "%"
            icon: "battery_full"
        }
        
        // Spacer row
        Item { Layout.fillWidth: true; Layout.fillHeight: true; Layout.columnSpan: 3 }
    }
    
    component StatCard: Rectangle {
        property string title
        property string value
        property string icon
        
        Layout.preferredWidth: 300
        Layout.preferredHeight: 180
        color: Qt.rgba(0,0,0,0.6)
        radius: root.theme.radiusLarge
        border.color: root.theme.primaryColor
        border.width: 1
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 10
            
            Text {
                text: parent.title
                color: root.theme.accentColor
                font.family: FontRegistry.current.name
                font.pixelSize: 14
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: parent.value
                color: root.theme.primaryColor
                font.family: FontRegistry.current.name
                font.pixelSize: 42
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
