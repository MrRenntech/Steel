from enum import Enum
from PySide6.QtCore import QObject, Signal, Property, Slot

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
        
        # Clear log file on start
        with open("logs.txt", "w") as f:
            f.write("=== STEEL SESSION STARTED ===\n")

    # Signals
    statusChanged = Signal()
    themeChanged = Signal()
    assistantStateChanged = Signal()

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

    # Slots
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
