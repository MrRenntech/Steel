import QtQuick 2.15

Item {
    width: 400
    height: 200

    FontLoader {
        id: testFont
        // Trying absolute path first to rule out relative path issues
        source: "file:///e:/Steel-main/app/assets/fonts/PlayfairDisplay-Regular.ttf"
        onStatusChanged: {
            console.log("FONT STATUS:", status === FontLoader.Ready ? "Ready" : status === FontLoader.Error ? "Error" : "Loading", name)
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Text {
        anchors.centerIn: parent
        text: "FONT TEST: " + testFont.name
        font.family: testFont.name // Binding directly to loader name
        font.pixelSize: 32
        color: "white"
    }
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: console.log("qml: TICK - Font Status:", testFont.status, testFont.name, testFont.source)
    }

    Component.onCompleted: console.log("qml: FontTest Started. Loading:", testFont.source)
}
