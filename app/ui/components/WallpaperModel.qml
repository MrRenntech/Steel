import QtQuick 2.15

ListModel {
    id: wallpaperModel
    
    ListElement { 
        name: "Ambient Sky"
        source: "ambient_sky.png"
        description: "Default atmosphere"
    }
    ListElement { 
        name: "Nordic Landscape"
        source: "soft_horizon.png"
        description: "Sharp horizon & water"
    }
    ListElement { 
        name: "Glass City"
        source: "glass_fog.png"
        description: "Modern vertical glass"
    }
    ListElement { 
        name: "City Dawn"
        source: "warm_dawn.png"
        description: "Golden urban light"
    }
    ListElement {
        name: "Midnight City"
        source: "bmw.png"
        description: "Deep dark urban"
    }
    ListElement {
        name: "Royal Estate"
        source: "bentley.png"
        description: "Luxury landscape"
    }
}
