# STEEL OS — Technical & Design Reference v6.5

> **Purpose**: Read before interviews, meetings, or demos. Complete architecture and design philosophy.

---

## 1. PROJECT OVERVIEW

**Steel** is a desktop AI assistant with a premium holographic glass UI. It combines:
- **Voice AI** powered by Google Gemini 1.5 Pro
- **Glass-OS Aesthetic** inspired by VisionOS, BMW iDrive, and Jarvis
- **Living AI Core** with state-driven animations

### Core Philosophy
- **Glass, Not Dark**: Light frosted panels (`rgba(1,1,1,0.08)`) on soft backgrounds
- **Motion = State**: The orb only moves when something is happening
- **System Language**: IT-native terms (Cognitive Core, not "Settings")
- **Depth Layers**: Background → Glass → Interaction planes

---

## 2. TECHNOLOGY STACK

### Backend (Python)
| Component | Technology | Purpose |
|-----------|------------|---------|
| **AI Engine** | Google Gemini 1.5 Pro | NLP, memory, vision |
| **GUI Framework** | PySide6 (Qt 6) | Modern cross-platform |
| **Audio** | SpeechRecognition | Voice input |
| **State** | QObject Signals | Reactive data binding |

### Frontend (QML)
| Component | Technology | Purpose |
|-----------|------------|---------|
| **Layout** | QtQuick Layouts | Responsive grids |
| **Animation** | SequentialAnimation | State transitions |
| **Theming** | ThemeLoader singleton | Color/font system |

### Key Files
```
app/
├── main.py                    # Entry point
├── core/
│   ├── app_state.py           # Reactive state (assistantState, audioLevel, currentWallpaper)
│   └── steel_core.py          # AI engine wrapper
├── ui/
│   ├── main.qml               # 3-zone layout
│   ├── components/
│   │   ├── CoreVisual.qml     # 5-layer AI orb
│   │   ├── GlassTile.qml      # Light glass cards
│   │   ├── BackgroundField.qml # Ambient atmosphere
│   │   ├── WallpaperPanel.qml # Wallpaper selector
│   │   └── WallpaperModel.qml # Curated wallpapers
│   └── panels/
│       └── AssistantPanel.qml # Command center grid
└── themes/
    └── base/Theme.qml         # Color tokens
```

---

## 3. ARCHITECTURE

### 3.1 Three-Zone Layout
```
┌─────────────────────────────────────────────────┐
│ TOP SYSTEM BAR (64px)                           │
│ [STEEL] [CORE] [INPUT] [SYSTEM] [...] [ONLINE]  │
├────────────────────────────┬────────────────────┤
│ LEFT CONTENT (65%)         │ RIGHT CORE (35%)   │
│                            │                    │
│ ┌────────┐ ┌────────┐      │   ╭─────────╮     │
│ │COGNITIVE│ │ VOICE │      │   │ AI ORB │      │
│ │ CORE   │ │INTERFACE│     │   │ ○ ○ ○  │      │
│ └────────┘ └────────┘      │   ╰─────────╯      │
│ ┌────────┐ ┌────────┐      │   "Ready"          │
│ │RUNTIME │ │CONNECT.│      │   Click to activate│
│ └────────┘ └────────┘      │                    │
├────────────────────────────┴────────────────────┤
│ BOTTOM CONTEXT BAR (56px)                       │
│ Ready for input | ▁▂▃▄▅ MIC | v6.5              │
└─────────────────────────────────────────────────┘
```

### 3.2 State Machine
```
Python (AppState) ─── QML Context ───> UI Reactivity
       │
       ├── assistantState: "IDLE" | "LISTENING" | "THINKING" | "RESPONDING"
       ├── audioLevel: 0.0 - 1.0 (real-time mic)
       ├── currentWallpaper: "ambient_sky.png"
       └── last_intent: String (last voice command)
```

### 3.3 Orb Layer Stack (CoreVisual.qml)
| Layer | Purpose |
|-------|---------|
| 5. Audio Waveform | LISTENING state only, audio-reactive bars |
| 4. Orb Sphere | 3D illusion with specular highlights |
| 3. Depth Ring | Rotates during THINKING |
| 2. Response Field | Border ring, rotates during activity |
| 1. Ambient Glow | State-colored background, breathing animation |

---

## 4. DESIGN LANGUAGE

### Glass Panel Pattern
```qml
Rectangle {
    radius: 20
    color: Qt.rgba(1, 1, 1, 0.08)    // LIGHT, not dark
    border.color: Qt.rgba(1, 1, 1, 0.15)
    
    // Shadow for depth
    Rectangle {
        z: -1
        anchors.topMargin: 6
        color: Qt.rgba(0, 0, 0, 0.3)
    }
}
```

### Color Tokens
| Token | Value | Usage |
|-------|-------|-------|
| Panel Background | `rgba(1,1,1,0.08)` | Glass tiles |
| Panel Border | `rgba(1,1,1,0.15)` | Subtle edges |
| Listening | `#00D4FF` | Cyan, active voice |
| Thinking | `#FFCC00` | Amber, processing |
| Responding | `#00FF88` | Green, speaking |
| Success | `#00FF88` | "ONLINE" status |

### Typography
- **Labels**: 11px, Medium, 1.6 letter-spacing, UPPERCASE
- **Values**: 22px, DemiBold
- **Subtitles**: 11px, Regular, 40% opacity

### Motion Rules
- **IDLE**: Slow breathing (5s), subtle 4px drift (9s)
- **Active States**: Motion only, no drift
- **Transitions**: 300-600ms, OutCubic easing

---

## 5. HOW TO RUN

```batch
# Prerequisites
- Python 3.10+
- Google Gemini API key

# Install
pip install -r requirements.txt

# Configure
copy .env.example .env
# Add: GEMINI_API_KEY=your_key

# Run
cd app
python main.py
```

---

## 6. INTERVIEW TALKING POINTS

### "What makes this project unique?"
> "Steel reimagines the AI assistant as a **living glass workspace**. Instead of a chat window, you get a holographic UI where the AI orb breathes when idle, shows audio waveforms when listening, and pulses outward when speaking. Every tile is frosted glass floating on an atmospheric gradient."

### "What technologies did you use?"
> "Python backend with PySide6/Qt6. The frontend is QML, which is like React for native apps. I use **Google Gemini 1.5 Pro** for the AI, with real-time mic levels driving visual feedback. The state flows reactively from Python to QML via Qt signals."

### "What was the hardest part?"
> "Making the UI feel 'alive' without being distracting. The orb only moves when something is happening — it drifts slowly when idle but snaps to attention during voice input. Getting that balance took iterating on the motion timing extensively."

### "How does state management work?"
> "AppState is a Python QObject with Property decorators. When assistantState changes from 'IDLE' to 'LISTENING', it emits a signal. QML binds to that property, so the orb immediately shifts color, the waveform fades in, and the bottom bar updates — all automatically."

### "What's next?"
> "Profile system (Work/Night/Focus themes), blur effects once Qt6 shader support improves, and eventually porting to embedded displays for actual vehicle integration."

---

## 7. VERSION HISTORY

| Version | Changes |
|---------|---------|
| 6.5 | 4-Phase Visual Overhaul: 3-zone layout, bottom bar, system naming, state-driven orb |
| 6.4 | Wallpaper system, true glass panels, command center refactor |
| 5.7 | Initial BMW iDrive theme |

---

*Document last updated: 2024-12-17*
