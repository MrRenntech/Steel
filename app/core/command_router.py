"""
Command Router - Voice Command System with Modes
Steel OS v6.5

Modes:
- COMMAND: Precise, grammar-based (default)
- CONVERSATION: Open language, low stakes (opt-in)

Rules:
- Interrupts bypass everything
- Conversation is opt-in, never chatty
- Initiative is rare, optional, never demanding
"""

import os
import subprocess
import sys
import time
from typing import Callable, Optional, List

from .tts_engine import speak as tts_speak, interrupt_speech
from .speech_recognizer import SpeechRecognizer, CONVERSATION_EXIT
from .memory import get_memory

# ═══════════════════════════════════════════════════════════════════════════
# CONSTANTS
# ═══════════════════════════════════════════════════════════════════════════
PAUSE_BEFORE_SPEAK = 0.25
PAUSE_AFTER_SPEAK = 0.30

# Hard interrupts
INTERRUPTS = ["stop", "cancel", "never mind", "shut up"]

# Suggestion responses
CONFIRMATIONS = ["yes", "sure", "okay", "do it"]
REJECTIONS = ["no", "nah"]

# Mode triggers
CONVERSATION_TRIGGERS = ["let's talk", "talk to me", "conversation mode"]

# Initiative settings
INITIATIVE_IDLE_THRESHOLD = 30.0  # seconds of idle before initiative
INITIATIVE_COOLDOWN = 600.0  # 10 minutes between initiatives


def is_interrupt(text: str) -> bool:
    if not text:
        return False
    return any(phrase in text.lower() for phrase in INTERRUPTS)


def is_conversation_trigger(text: str) -> bool:
    if not text:
        return False
    return any(trigger in text.lower() for trigger in CONVERSATION_TRIGGERS)


def is_conversation_exit(text: str) -> bool:
    if not text:
        return False
    return any(exit_phrase in text.lower() for exit_phrase in CONVERSATION_EXIT)


def split_commands(text: str) -> List[str]:
    return [cmd.strip() for cmd in text.split(" and ") if cmd.strip()]


class CommandRouter:
    """Routes voice commands with mode switching and initiative."""
    
    # Mode constants
    MODE_COMMAND = "COMMAND"
    MODE_CONVERSATION = "CONVERSATION"
    
    def __init__(self, app_state, speech_recognizer: SpeechRecognizer = None):
        self.app_state = app_state
        self.speech = speech_recognizer
        
        # Persistent memory (Tier 1)
        self.persistent = get_memory()
        
        # Current mode - load from persistent memory
        self._mode = self.persistent.last_mode or self.MODE_COMMAND
        
        # Session memory (Tier 0 - dies on exit)
        self.memory = {
            "last_command": None,
            "last_theme": self.persistent.preferred_theme,  # Pre-load from persistent
            "last_transcript": None,
        }
        
        # Apply preferred theme silently on startup
        if self.persistent.preferred_theme:
            print(f"[Memory] Applying preferred theme: {self.persistent.preferred_theme}")
            app_state.set_theme(self.persistent.preferred_theme)
        
        # Initiative tracking
        self._last_user_activity = time.time()
        self._last_initiative = 0.0
        self._initiative_offered = False
        self._pending_suggestion_action = None  # Callable if waiting for confirmation
        
        # Command map
        self.command_actions = {
            "switch to bmw": lambda: self._set_theme("bmw"),
            "switch to audi": lambda: self._set_theme("audi"),
            "switch to bentley": lambda: self._set_theme("bentley"),
            "reload ui": self._reload_ui,
            "restart assistant": self._restart_assistant,
            "open logs": self._open_logs,
            "repeat that": self._repeat_last,
            "help": self._show_help,
        }
    
    @property
    def mode(self) -> str:
        return self._mode
    
    # ═══════════════════════════════════════════════════════════════════════════
    # SPEAK INTENT
    # ═══════════════════════════════════════════════════════════════════════════
    
    def speak_intent(self, text: str):
        """Deliberate speaking with timing discipline."""
        self.app_state.set_transcript(text)
        print(f"[SPEAK] {text}")
        self.app_state.log(f"[SPEAK] {text}")
        time.sleep(PAUSE_BEFORE_SPEAK)
        tts_speak(text)
        time.sleep(PAUSE_AFTER_SPEAK)
    
    # ═══════════════════════════════════════════════════════════════════════════
    # MAIN ENTRY POINT
    # ═══════════════════════════════════════════════════════════════════════════
    
    def handle_command(self, text: str) -> bool:
        """Handle incoming text based on current mode."""
        # Update activity tracker
        self._last_user_activity = time.time()
        
        if not text:
            self.speak_intent("I didn't catch that.")
            return False
        
        text = text.lower().strip()
        
        # ─────────────────────────────────────────────────────────────
        # STEP 1: INTERRUPTS (always first, bypass everything)
        # ─────────────────────────────────────────────────────────────
        if is_interrupt(text):
            self._handle_interrupt()
            return True
        
        # ─────────────────────────────────────────────────────────────
        # STEP 2: MODE SWITCHING
        # ─────────────────────────────────────────────────────────────
        if self._mode == self.MODE_COMMAND and is_conversation_trigger(text):
            self._enter_conversation_mode()
            return True
        
        if self._mode == self.MODE_CONVERSATION and is_conversation_exit(text):
            self._exit_conversation_mode()
            return True
        
        # Save transcript
        self.memory["last_transcript"] = text
        
        # ─────────────────────────────────────────────────────────────
        # STEP 3: ROUTE BASED ON MODE
        # ─────────────────────────────────────────────────────────────
        if self._mode == self.MODE_COMMAND:
            return self._handle_command_mode(text)
        else:
            return self._handle_conversation_mode(text)
    
    def _handle_interrupt(self):
        """Handle hard interrupt."""
        print("[CommandRouter] INTERRUPT")
        interrupt_speech()
        self.app_state.set_transcript("")
        
        # Exit conversation mode if in it
        if self._mode == self.MODE_CONVERSATION:
            self._mode = self.MODE_COMMAND
            self.app_state.set_interaction_mode(self.MODE_COMMAND)
            if self.speech:
                self.speech.set_mode(SpeechRecognizer.MODE_COMMAND)
        
        self.app_state.set_state("IDLE")
    
    def _enter_conversation_mode(self):
        """Enter conversation mode."""
        print("[CommandRouter] Entering CONVERSATION MODE")
        self._mode = self.MODE_CONVERSATION
        self.app_state.set_interaction_mode(self.MODE_CONVERSATION)
        if self.speech:
            self.speech.set_mode(SpeechRecognizer.MODE_CONVERSATION)
        self.speak_intent("I'm listening.")
    
    def _exit_conversation_mode(self):
        """Exit conversation mode."""
        print("[CommandRouter] Exiting CONVERSATION MODE")
        self._mode = self.MODE_COMMAND
        self.app_state.set_interaction_mode(self.MODE_COMMAND)
        if self.speech:
            self.speech.set_mode(SpeechRecognizer.MODE_COMMAND)
        self.speak_intent("Alright.")
    
    # ═══════════════════════════════════════════════════════════════════════════
    # COMMAND MODE HANDLING
    # ═══════════════════════════════════════════════════════════════════════════
    
    def _handle_command_mode(self, text: str) -> bool:
        """Handle command in Command Mode."""
        # 1. Check for pending suggestion response
        if self._pending_suggestion_action:
            if self._handle_suggestion_response(text):
                return True

        parts = split_commands(text)
        
        if len(parts) > 1:
            return self._handle_compound(parts)
        
        return self._handle_single(text)

    def _handle_suggestion_response(self, text: str) -> bool:
        """Handle response to a pending suggestion."""
        # Check for confirmation
        if any(w in text for w in CONFIRMATIONS):
            print("[CommandRouter] Suggestion confirmed.")
            action = self._pending_suggestion_action
            self._pending_suggestion_action = None
            if action:
                action()
            return True
        
        # Check for rejection
        if any(w in text for w in REJECTIONS):
            print("[CommandRouter] Suggestion rejected.")
            self._pending_suggestion_action = None
            # Silence on rejection (as per design)
            return True
            
        # If text is unrelated, we might want to clear pending or keep it?
        # Design says: "Never follow up if ignored."
        # If user says a command "Reload UI", we should probably execute it and drop the suggestion.
        self._pending_suggestion_action = None
        return False
    
    def _handle_compound(self, parts: List[str]) -> bool:
        """Handle compound command."""
        matched_any = False
        
        for part in parts:
            for phrase, action in self.command_actions.items():
                if phrase in part:
                    if phrase != "repeat that":
                        self.memory["last_command"] = phrase
                    action()
                    matched_any = True
                    break
        
        if matched_any:
            self.speak_intent("Done.")
        else:
            self.speak_intent("Command not recognized.")
        
        return matched_any
    
    def _handle_single(self, text: str) -> bool:
        """Handle single command."""
        for phrase, action in self.command_actions.items():
            if phrase in text:
                if phrase != "repeat that":
                    self.memory["last_command"] = phrase
                action()
                return True
        
        self.speak_intent("Command not recognized.")
        return False
    
    # ═══════════════════════════════════════════════════════════════════════════
    # CONVERSATION MODE HANDLING (Limited on purpose)
    # ═══════════════════════════════════════════════════════════════════════════
    
    def _handle_conversation_mode(self, text: str) -> bool:
        """Handle text in Conversation Mode - limited, safe."""
        # Conversation mode is limited for now
        # It can only acknowledge and reflect
        
        # Simple responses for common questions
        if "what are we building" in text or "what is this" in text:
            self.speak_intent("An intelligent assistant with themes and voice control.")
            return True
        
        if "help" in text:
            self.speak_intent("Say 'back to commands' to return to command mode.")
            return True
        
        # Default: reflect or acknowledge
        if len(text) > 5:
            self.speak_intent("I understand.")
        else:
            self.speak_intent("I'm not sure yet.")
        
        return True
    
    # ═══════════════════════════════════════════════════════════════════════════
    # ASSISTANT INITIATIVE (Rare, optional, never demanding)
    # ═══════════════════════════════════════════════════════════════════════════
    
    def maybe_offer_suggestion(self) -> bool:
        """
        Check if we should offer a suggestion.
        Called periodically. Returns True if suggestion was made.
        Very conservative - only under strict conditions.
        """
        now = time.time()
        
        # Check all conditions
        idle_time = now - self._last_user_activity
        time_since_last = now - self._last_initiative
        
        # All must be true:
        # 1. User idle > 30 seconds
        # 2. Not offered recently (10 min cooldown)  
        # 3. In command mode
        # 4. Not already offered this session
        
        if idle_time < INITIATIVE_IDLE_THRESHOLD:
            return False
        
        if time_since_last < INITIATIVE_COOLDOWN:
            return False
        
        if self._mode != self.MODE_COMMAND:
            return False
        
        if self._initiative_offered:
            return False
        
        # Check if we have something useful to suggest
        suggestion = self._get_suggestion()
        if not suggestion:
            return False
        
        # Offer suggestion (phrased as optional)
        self._last_initiative = now
        self._initiative_offered = True
        self.speak_intent(suggestion)
        
        return True
    
    def _get_suggestion(self) -> Optional[str]:
        """Get a relevant suggestion, or None if nothing useful."""
        # Very conservative - only offer if clearly useful
        
        # 1. Theme Default Suggestion
        # If user is on a theme different from preferred, offer to save it
        current_theme = self.memory.get("last_theme")
        preferred = self.persistent.preferred_theme
        
        if current_theme and current_theme != preferred:
            def set_default():
                self.persistent.set_immediate("preferred_theme", current_theme)
                self.speak_intent(f"{current_theme.upper()} saved as default.")
            
            self._pending_suggestion_action = set_default
            return f"Want me to keep {current_theme} as default?"
        
        # 2. Resume Workflow Suggestion
        if self.memory.get("last_command"):
            # Only if NO pending action from above (though unlikely to overlap)
            return "Want to continue where we left off?"
        
        return None  # No suggestion
    
    # ═══════════════════════════════════════════════════════════════════════════
    # COMMAND IMPLEMENTATIONS
    # ═══════════════════════════════════════════════════════════════════════════
    
    def _set_theme(self, theme_name: str):
        if self.memory["last_theme"] == theme_name:
            self.speak_intent(f"{theme_name.upper()} again.")
        else:
            self.speak_intent(f"{theme_name.upper()}.")
        
        # Update session memory
        self.memory["last_theme"] = theme_name
        self.app_state.set_theme(theme_name)
        
        # Persistent memory: confirmation-based (same choice twice = persist)
        self.persistent.set_with_confirmation("preferred_theme", theme_name)
        self.persistent.set_with_confirmation("last_successful_command", f"switch to {theme_name}")
    
    def _reload_ui(self):
        self.speak_intent("Reloading.")
        self.app_state.request_reload_ui()
    
    def _restart_assistant(self):
        self.speak_intent("Restarting.")
        self.app_state.set_state("IDLE")
    
    def _open_logs(self):
        self.speak_intent("Opening logs.")
        logs_path = os.path.join(os.path.dirname(__file__), "..", "logs.txt")
        logs_path = os.path.abspath(logs_path)
        
        try:
            if sys.platform == "win32":
                os.startfile(logs_path)
            elif sys.platform == "darwin":
                subprocess.run(["open", logs_path])
            else:
                subprocess.run(["xdg-open", logs_path])
        except Exception as e:
            print(f"[CommandRouter] Failed to open logs: {e}")
    
    def _repeat_last(self):
        last = self.memory.get("last_command")
        if last and last in self.command_actions:
            self.speak_intent("Repeating.")
            self.command_actions[last]()
        else:
            self.speak_intent("Nothing to repeat.")
    
    def _show_help(self):
        if self._mode == self.MODE_CONVERSATION:
            self.speak_intent("Say 'back to commands' to exit conversation mode.")
        else:
            self.speak_intent("Theme, reload, restart, logs, repeat, 'let's talk', or stop.")
