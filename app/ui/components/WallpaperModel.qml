import QtQuick 2.15

ListModel {
    id: wallpaperModel
    
    ListElement { 
        name: "Ambient Sky"
        source: "ambient_sky.png"
        description: "Soft blue-cream gradient"
    }
    ListElement { 
        name: "Soft Horizon"
        source: "soft_horizon.png"
        description: "Ocean meets sky"
    }
    ListElement { 
        name: "Glass Fog"
        source: "glass_fog.png"
        description: "Frosted white mist"
    }
    ListElement { 
        name: "Warm Dawn"
        source: "warm_dawn.png"
        description: "Golden pink glow"
    }
}
