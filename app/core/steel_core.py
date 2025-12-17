from PySide6.QtCore import QObject, QTimer, Slot
from .app_state import AppState


class SteelCore(QObject):
    def __init__(self, app_state: AppState):
        super().__init__()
        self.app_state = app_state
        
        # Connect to state changes
        self.app_state.assistantStateChanged.connect(self.on_state_changed)
        
        # Simulation timers
        self.processing_timer = QTimer(self)
        self.processing_timer.setSingleShot(True)
        
    @Slot()
    def on_state_changed(self):
        current_state = self.app_state.assistantState
        
        if current_state == "LISTENING":
            self.start_listening_flow()
        elif current_state == "IDLE":
            # Cancel any pending operations if user reset
            if self.processing_timer.isActive():
                print("[SteelCore] Operation cancelled by user.")
                self.processing_timer.stop()
            
    def start_listening_flow(self):
        try:
            # Simulate listening duration (e.g. user speaking)
            # In real implementation, this would be VAD (Voice Activity Detection)
            print("[SteelCore] Listening...")
            self.processing_timer.timeout.disconnect() if self.processing_timer.isActive() else None
            self.processing_timer.timeout.connect(self.transition_to_thinking)
            self.processing_timer.start(3000) # 3 seconds listen
            
        except Exception as e:
            print(f"[SteelCore] Error in listening: {e}")
            self.app_state.set_state("ERROR")

    def transition_to_thinking(self):
        try:
            print("[SteelCore] Finished listening. Thinking...")
            self.app_state.set_state("THINKING")
            
            # Simulate AI processing time
            self.processing_timer.timeout.disconnect()
            self.processing_timer.timeout.connect(self.transition_to_responding)
            self.processing_timer.start(2000) # 2 seconds think
            
        except Exception as e:
            print(f"[SteelCore] Error in thinking: {e}")
            self.app_state.set_state("ERROR")
            
    def transition_to_responding(self):
        try:
            print("[SteelCore] AI Response Ready. Responding...")
            self.app_state.set_state("RESPONDING")
            
            # Simulate TTS duration
            self.processing_timer.timeout.disconnect()
            self.processing_timer.timeout.connect(self.transition_to_idle)
            self.processing_timer.start(4000) # 4 seconds speak
            
        except Exception as e:
            print(f"[SteelCore] Error in responding: {e}")
            self.app_state.set_state("ERROR")
            
    def transition_to_idle(self):
        print("[SteelCore] Interaction complete. Idle.")
        self.app_state.set_state("IDLE")


