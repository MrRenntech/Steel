"""
Command Router - Hardcoded Voice Command System
Steel OS v6.5

Design Philosophy:
- BMW energy: calm, measured, never rushed
- speak_intent() wrapper: deliberate pause, speak, closure
- Session memory for context-aware responses
- Never chatty, always intentional
"""

import os
import subprocess
import sys
import time
from typing import Callable, Optional

from .tts_engine import speak as tts_speak

# ═══════════════════════════════════════════════════════════════════════════
# TIMING CONSTANTS (BMW-style deliberate pacing)
# ═══════════════════════════════════════════════════════════════════════════
PAUSE_BEFORE_SPEAK = 0.25   # Deliberate pause (thinking, not lag)
PAUSE_AFTER_SPEAK = 0.30    # Closure beat before returning


class CommandRouter:
    """Routes voice commands with BMW-style deliberate pacing and memory."""
    
    def __init__(self, app_state):
        self.app_state = app_state
        
        # ─────────────────────────────────────────────────────────────
        # SESSION MEMORY (RAM only, dies when app closes - that's good)
        # ─────────────────────────────────────────────────────────────
        self.memory = {
            "last_command": None,
            "last_theme": None,
            "last_transcript": None,
        }
        
        # Command map: exact phrases -> actions
        self.commands: dict[str, Callable] = {
            # Theme commands
            "switch to bmw": lambda: self.set_theme("bmw"),
            "switch to audi": lambda: self.set_theme("audi"),
            "switch to bentley": lambda: self.set_theme("bentley"),
            
            # System commands
            "reload ui": self.reload_ui,
            "restart assistant": self.restart_assistant,
            "open logs": self.open_logs,
            
            # Memory commands
            "repeat that": self.repeat_last,
            
            # Help
            "help": self.show_help,
        }
    
    # ═══════════════════════════════════════════════════════════════════════════
    # SPEAK INTENT - THE ONE WRAPPER TO RULE THEM ALL
    # Never call tts_speak directly. Always go through this.
    # ═══════════════════════════════════════════════════════════════════════════
    
    def speak_intent(self, text: str):
        """
        Deliberate speaking with timing discipline.
        All speech must go through this function. No exceptions.
        """
        # Set transcript first (eyes lead)
        self.app_state.set_transcript(text)
        
        # Log
        print(f"[SPEAK] {text}")
        self.app_state.log(f"[SPEAK] {text}")
        
        # Deliberate pause (brain reads this as 'thinking')
        time.sleep(PAUSE_BEFORE_SPEAK)
        
        # Speak (ears follow)
        tts_speak(text)
        
        # Closure beat (moment of stillness)
        time.sleep(PAUSE_AFTER_SPEAK)
    
    def handle_command(self, text: str) -> bool:
        """
        Router function - the heart of the system.
        Returns True if a command was matched, False otherwise.
        """
        if not text:
            self.speak_intent("I didn't catch that.")
            return False
        
        text = text.lower().strip()
        
        # Save transcript to memory (silently, never announce)
        self.memory["last_transcript"] = text
        
        # Check each command phrase
        for phrase, action in self.commands.items():
            if phrase in text:
                # Save command to memory (silently)
                if phrase != "repeat that":  # Don't save "repeat that" as last command
                    self.memory["last_command"] = phrase
                
                # Execute
                action()
                return True
        
        # No match found
        self.speak_intent("Command not recognized.")
        return False
    
    # ═══════════════════════════════════════════════════════════════════════════
    # THEME COMMANDS (Context-aware responses)
    # ═══════════════════════════════════════════════════════════════════════════
    
    def set_theme(self, theme_name: str):
        """Switch to a different theme with contextual response."""
        print(f"[CommandRouter] Switching to {theme_name} theme...")
        
        # Context-aware response
        if self.memory["last_theme"] == theme_name:
            # Same theme twice in a row
            self.speak_intent(f"{theme_name.upper()} again.")
        else:
            # Normal switch
            self.speak_intent(f"{theme_name.upper()}.")
        
        # Update memory and execute
        self.memory["last_theme"] = theme_name
        self.app_state.set_theme(theme_name)
    
    # ═══════════════════════════════════════════════════════════════════════════
    # SYSTEM COMMANDS
    # ═══════════════════════════════════════════════════════════════════════════
    
    def reload_ui(self):
        """Emit signal to reload the QML UI."""
        self.speak_intent("Reloading.")
        print("[CommandRouter] Reloading UI...")
        self.app_state.request_reload_ui()
    
    def restart_assistant(self):
        """Reset assistant state to IDLE."""
        self.speak_intent("Restarting.")
        print("[CommandRouter] Restarting assistant...")
        self.app_state.set_state("IDLE")
    
    def open_logs(self):
        """Open the logs file in the default text editor."""
        self.speak_intent("Opening logs.")
        print("[CommandRouter] Opening logs...")
        
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
    
    # ═══════════════════════════════════════════════════════════════════════════
    # MEMORY COMMANDS
    # ═══════════════════════════════════════════════════════════════════════════
    
    def repeat_last(self):
        """Repeat the last command."""
        last = self.memory.get("last_command")
        if last:
            self.speak_intent("Repeating.")
            # Find and execute the command
            if last in self.commands:
                self.commands[last]()
        else:
            self.speak_intent("Nothing to repeat yet.")
    
    # ═══════════════════════════════════════════════════════════════════════════
    # HELP
    # ═══════════════════════════════════════════════════════════════════════════
    
    def show_help(self):
        """Speak available commands - brief and clear."""
        self.speak_intent("Theme, reload, restart, logs, repeat, or help.")
