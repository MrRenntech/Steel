import QtQuick 2.15

QtObject {
    property int screenWidth
    property int screenHeight
    property bool fullscreen
    property real scale: 1.0

    function update(window) {
        screenWidth = window.width
        screenHeight = window.height
        fullscreen = window.visibility === Window.FullScreen
        // Base scale on 1920x1080 reference
        scale = Math.min(screenWidth / 1920, screenHeight / 1080)
        // Ensure minimum scale to avoid tiny UI on small screens if needed, 
        // but user asked for strict formula.
        // If window is 1280x800, scale = 1280/1920 = 0.66
        // This might make text too small? 
        // User said: "looks correct windowed and fullscreen".
        // I will follow the formula.
    }
}
