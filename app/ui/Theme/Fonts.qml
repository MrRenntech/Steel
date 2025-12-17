pragma Singleton
import QtQuick 2.15

Item {
    readonly property string inter: interLoader.status === FontLoader.Ready ? interLoader.name : "Segoe UI"
    readonly property string montserrat: montserratLoader.status === FontLoader.Ready ? montserratLoader.name : "Segoe UI"
    readonly property string playfair: playfairLoader.status === FontLoader.Ready ? playfairLoader.name : "Times New Roman"

    FontLoader {
        id: interLoader
        source: "../../assets/fonts/Inter-Regular.ttf"
    }

    FontLoader {
        id: montserratLoader
        source: "../../assets/fonts/Montserrat-Regular.ttf"
    }

    FontLoader {
        id: playfairLoader
        source: "../../assets/fonts/PlayfairDisplay-Regular.ttf"
    }
}
