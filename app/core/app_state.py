from enum import Enum
from PySide6.QtCore import QObject, Signal, Property, Slot, QTimer
from .mic_monitor import MicMonitor
from .speech_recognizer import SpeechRecognizer

class AssistantState(str, Enum):
    IDLE = "IDLE"
    PRE_LISTEN = "PRE_LISTEN"
    LISTENING = "LISTENING"
    HOLDING = "HOLDING"
    PROCESSING = "PROCESSING"  # Added - was missing!
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
        self._interaction_mode = "COMMAND"  # COMMAND, CONVERSATION
        
        # Audio Logic
        self.silence_duration = 0.0
        self.rms_threshold = 0.05
        
        # Mic Monitor
        self.mic = MicMonitor()
        self.mic.start()
        
        self.audio_timer = QTimer()
        self.audio_timer.timeout.connect(self.update_audio)
        self.audio_timer.start(16) # ~60fps
        
        # Clear log file on start
        with open("logs.txt", "w") as f:
            f.write("=== STEEL SESSION STARTED ===\n")
        
        # Speech Recognizer (Vosk - offline)
        self._init_speech_recognizer()
    
    def _init_speech_recognizer(self):
        """Initialize the Vosk speech recognizer."""
        try:
            self.speech = SpeechRecognizer(
                on_partial=self._on_partial_transcript,
                on_final=self._on_final_transcript
            )
            print("[AppState] Speech recognizer initialized")
        except Exception as e:
            print(f"[AppState] Failed to initialize speech recognizer: {e}")
            self.speech = None
    
    def _on_partial_transcript(self, text: str):
        """Called when partial transcript is available (live subtitles)."""
        self._partial_transcript = text
        self.transcriptChanged.emit()
    
    def _on_final_transcript(self, text: str):
        """Called when final transcript is available."""
        self._partial_transcript = text
        self.transcriptChanged.emit()
        self.log(f"Transcript: {text}")

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
    reloadUIRequested = Signal()
    interactionModeChanged = Signal()  # COMMAND/CONVERSATION mode changes

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

    @Property(str, notify=interactionModeChanged)
    def interactionMode(self):
        """Current interaction mode: COMMAND or CONVERSATION"""
        return self._interaction_mode

    # Slots
    @Slot(str)
    def set_interaction_mode(self, mode: str):
        """Set interaction mode (called from command router)."""
        if mode in ["COMMAND", "CONVERSATION"] and self._interaction_mode != mode:
            self._interaction_mode = mode
            self.interactionModeChanged.emit()
            print(f"[AppState] Interaction mode: {mode}")
    @Slot(float)
    def set_audio_level(self, level):
        if self._audio_level != level:
            self._audio_level = level
            self.audioLevelChanged.emit()

    @Slot()
    def request_listening(self):
        self.listeningImminent.emit()
        # Manual trigger jumps to PRE_LISTEN
        self.set_state("PRE_LISTEN")
        self.silence_duration = 0.0

    @Slot(str)
    def set_transcript(self, text):
        """Set the transcript text (from voice recognition or for testing)."""
        if self._partial_transcript != text:
            self._partial_transcript = text
            self.transcriptChanged.emit()
            self.log(f"Transcript: {text}")

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
                old_state = self._assistant_state
                self._assistant_state = valid_state
                self.assistantStateChanged.emit()
                self.log(f"State changed to: {valid_state}")
                
                # Start/stop speech recognition based on state
                self._handle_speech_recognition_state(old_state, valid_state)
        except KeyError:
            self.log(f"Invalid state requested: {new_state}")
    
    def _handle_speech_recognition_state(self, old_state: str, new_state: str):
        """Start/stop speech recognition based on state transitions."""
        if not hasattr(self, 'speech') or not self.speech:
            return
        
        # Start listening when entering PRE_LISTEN or LISTENING
        if new_state in [AssistantState.PRE_LISTEN.value, AssistantState.LISTENING.value]:
            if not self.speech.is_running:
                self._partial_transcript = ""  # Clear old transcript
                self.transcriptChanged.emit()
                self.speech.start()
        
        # Stop listening when entering PROCESSING (get final transcript)
        elif new_state == AssistantState.PROCESSING.value:
            if self.speech.is_running:
                self.speech.stop()
        
        # Also stop when going back to IDLE unexpectedly
        elif new_state == AssistantState.IDLE.value:
            if self.speech.is_running:
                self.speech.stop()

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

    @Slot()
    def request_reload_ui(self):
        """Emit signal to request UI reload."""
        self.log("UI reload requested")
        self.reloadUIRequested.emit()

    @Slot(str)
    def log(self, message):
        print(f"[QML Log]: {message}")
        try:
            with open("logs.txt", "a") as f:
                f.write(f"{message}\n")
        except: pass

    def update_audio(self):
        # Smooth decay
        current_decay = self._audio_level * 0.85
        
        # Get Mic Level
        mic_level = 0.0
        if hasattr(self, 'mic') and self.mic:
            mic_level = self.mic.level
            
        self._audio_level = max(current_decay, mic_level)
        self.audioLevelChanged.emit()

        # ─────────────────────────────────────────────────────────────
        # LISTENING LOGIC (Micro-States)
        # ─────────────────────────────────────────────────────────────
        dt = 0.016 # 16ms
        
        # 1. IDLE -> PRE_LISTEN (Auto-Trigger)
        if self._assistant_state == AssistantState.IDLE.value:
            if mic_level > self.rms_threshold:
                self.set_state("PRE_LISTEN")
                self.silence_duration = 0.0

        # 2. WATCHING (PRE_LISTEN / LISTENING / HOLDING)
        elif self._assistant_state in [
            AssistantState.PRE_LISTEN.value, 
            AssistantState.LISTENING.value, 
            AssistantState.HOLDING.value
        ]:
            if mic_level > self.rms_threshold:
                # User is speaking
                self.silence_duration = 0.0
                if self._assistant_state != AssistantState.LISTENING.value:
                    self.set_state("LISTENING")
            else:
                # Silence detected
                self.silence_duration += dt
                
                # Check Timers
                if self.silence_duration > 0.8 and self.silence_duration < 2.5:
                    if self._assistant_state != AssistantState.HOLDING.value:
                        self.set_state("HOLDING")
                
                elif self.silence_duration > 2.5:
                    # CRITICAL: Stop speech FIRST to get final transcript
                    # THEN transition to PROCESSING
                    if hasattr(self, 'speech') and self.speech and self.speech.is_running:
                        self.speech.stop()  # This updates _partial_transcript with final result
                    self.set_state("PROCESSING")
