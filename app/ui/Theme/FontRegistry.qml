pragma Singleton
import QtQuick 2.15

Item {
    id: root
    
    // Font Loaders - Load Once
    // Using absolute paths for reliability
    FontLoader { id: inter; source: "file:///e:/Steel-main/app/assets/fonts/Inter-Regular.ttf" }
    FontLoader { id: montserrat; source: "file:///e:/Steel-main/app/assets/fonts/Montserrat-Regular.ttf" }
    FontLoader { id: playfair; source: "file:///e:/Steel-main/app/assets/fonts/PlayfairDisplay-Regular.ttf" }

    // Public properties exposing the LOADER OBJECTS (not strings)
    property var bmw: inter
    property var audi: montserrat
    property var bentley: playfair

    // The single source of truth for the CURRENT font loader object
    property var current: inter
}
