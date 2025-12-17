from enum import Enum
from PySide6.QtCore import QObject, Signal, Property, Slot, QTimer
from .mic_monitor import MicMonitor

class AssistantState(str, Enum):
    IDLE = "IDLE"
    LISTENING = "LISTENING"
    THINKING = "THINKING"
    RESPONDING = "RESPONDING"
    ERROR = "ERROR"

class AppState(QObject):
    def __init__(self):
        super().__init__()
        self._status = "Steel Core Online"
        self._current_theme = "base"
        self._assistant_state = AssistantState.IDLE.value
        self._audio_level = 0.0
        self._partial_transcript = ""
        self._last_intent = ""
        self._confidence = 0.0
        self._current_wallpaper = "ambient_sky.png"  # Default wallpaper
        
        # Mic Monitor
        self.mic = MicMonitor()
        self.mic.start()
        
        self.audio_timer = QTimer()
        self.audio_timer.timeout.connect(self.update_audio)
        self.audio_timer.start(16) # ~60fps
        
        # Clear log file on start
        with open("logs.txt", "w") as f:
            f.write("=== STEEL SESSION STARTED ===\n")

    # Signals
    statusChanged = Signal()
    themeChanged = Signal()
    assistantStateChanged = Signal()
    listeningImminent = Signal()
    audioLevelChanged = Signal()
    transcriptChanged = Signal()
    lastIntentChanged = Signal()
    confidenceChanged = Signal()
    wallpaperChanged = Signal()

    # Properties
    @Property(str, notify=statusChanged)
    def status(self):
        return self._status

    @Property(str, notify=themeChanged)
    def currentTheme(self):
        return self._current_theme

    @Property(str, notify=assistantStateChanged)
    def assistantState(self):
        return self._assistant_state

    @Property(float, notify=audioLevelChanged)
    def audioLevel(self):
        return self._audio_level

    @Property(str, notify=transcriptChanged)
    def partialTranscript(self):
        return self._partial_transcript

    @Property(str, notify=lastIntentChanged)
    def last_intent(self):
        return self._last_intent

    @Property(float, notify=confidenceChanged)
    def confidence(self):
        return self._confidence

    @Property(str, notify=wallpaperChanged)
    def currentWallpaper(self):
        return self._current_wallpaper

    # Slots
    @Slot(float)
    def set_audio_level(self, level):
        if self._audio_level != level:
            self._audio_level = level
            self.audioLevelChanged.emit()

    @Slot()
    def request_listening(self):
        self.listeningImminent.emit()
        QTimer.singleShot(150, lambda: self.set_state("LISTENING"))

    @Slot(str, float)
    def set_intent(self, intent, confidence):
        if self._last_intent != intent or self._confidence != confidence:
            self._last_intent = intent
            self._confidence = confidence
            self.lastIntentChanged.emit()
            self.confidenceChanged.emit()
            self.log(f"Intent detected: {intent} ({confidence:.2f})")

    @Slot(str)
    def set_wallpaper(self, wallpaper):
        if self._current_wallpaper != wallpaper:
            self._current_wallpaper = wallpaper
            self.wallpaperChanged.emit()
            self.log(f"Wallpaper changed to: {wallpaper}")

    @Slot(str)
    def set_state(self, new_state):
        # Validate against Enum
        try:
            # Allow case-insensitive string matching for QML convenience
            valid_state = AssistantState[new_state.upper()].value
            if self._assistant_state != valid_state:
                self._assistant_state = valid_state
                self.assistantStateChanged.emit()
                self.log(f"State changed to: {valid_state}")
        except KeyError:
            self.log(f"Invalid state requested: {new_state}")

    @Slot(str)
    def set_theme(self, theme_name):
        if self._current_theme != theme_name:
            self._current_theme = theme_name
            self.themeChanged.emit()
            self.log(f"Theme switched to: {theme_name}")

    @Slot()
    def cycle_theme(self):
        themes = ["base", "bmw", "mercedes", "audi"]
        try:
            curr_idx = themes.index(self._current_theme)
        except ValueError:
            curr_idx = 0
            
        next_idx = (curr_idx + 1) % len(themes)
        self.set_theme(themes[next_idx])

    @Slot(str)
    def log(self, message):
        print(f"[QML Log]: {message}")
        try:
            with open("logs.txt", "a") as f:
                f.write(f"{message}\n")
        except: pass

    def update_audio(self):
        # Smooth decay
        self._audio_level *= 0.85
        if hasattr(self, 'mic') and self.mic:
            self._audio_level = max(self._audio_level, self.mic.level)

        self.audioLevelChanged.emit()
