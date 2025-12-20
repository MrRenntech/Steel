from PySide6.QtCore import QObject, QTimer, Slot
from .app_state import AppState
from .command_router import CommandRouter


class SteelCore(QObject):
    def __init__(self, app_state: AppState):
        super().__init__()
        self.app_state = app_state
        
        # Initialize command router (pass speech recognizer for mode switching)
        speech = getattr(app_state, 'speech', None)
        self.router = CommandRouter(app_state, speech_recognizer=speech)
        
        # Connect to state changes
        self.app_state.assistantStateChanged.connect(self.on_state_changed)
        
        # Simulation timers
        self.processing_timer = QTimer(self)
        self.processing_timer.setSingleShot(True)
        
        # Initiative timer (checks for suggestions every 5s)
        self.initiative_timer = QTimer(self)
        self.initiative_timer.timeout.connect(self.check_initiative)
        self.initiative_timer.start(5000)

    @Slot()
    def check_initiative(self):
        """Periodically check if assistant should offer a suggestion."""
        if self.app_state.assistantState == "IDLE":
            self.router.maybe_offer_suggestion()
        
    @Slot()
    def on_state_changed(self):
        current_state = self.app_state.assistantState
        
        if current_state == "LISTENING":
            self.start_listening_flow()
        elif current_state == "PROCESSING":
            # Route the command when entering PROCESSING state
            self.process_voice_command()
        elif current_state == "IDLE":
            # Cancel any pending operations if user reset
            if self.processing_timer.isActive():
                print("[SteelCore] Operation cancelled by user.")
                self.processing_timer.stop()
    
    def process_voice_command(self):
        """Process voice command when PROCESSING state is entered."""
        # Get the transcript (from Vosk via app_state)
        transcript = self.app_state.partialTranscript
        
        # DEBUG: Print exactly what we're getting
        print(f"[DEBUG] RAW TRANSCRIPT: '{transcript}'")
        print(f"[SteelCore] Processing command: '{transcript}'")
        
        # Route the command
        matched = self.router.handle_command(transcript)
        
        # Transition to RESPONDING then IDLE
        self.app_state.set_state("RESPONDING")
        try:
            self.processing_timer.timeout.disconnect()
        except RuntimeError:
            pass  # No connections to disconnect
        self.processing_timer.timeout.connect(self.transition_to_idle)
        self.processing_timer.start(1500)  # Brief response state
            
    def start_listening_flow(self):
        """Called when LISTENING state is entered. 
        
        Note: We no longer use a timer here. The natural flow is:
        PRE_LISTEN -> LISTENING -> HOLDING -> PROCESSING
        This is handled by RMS-based silence detection in app_state.py.
        """
        print("[SteelCore] Listening... (waiting for silence to trigger PROCESSING)")

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


