"""
Command Router - Hardcoded Voice Command System
Steel OS v6.5

Design Philosophy:
- BMW energy: calm, measured, never rushed
- Deliberate pause before speaking (250ms)
- Short sentences, no filler words
- Session memory for context
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
PAUSE_BEFORE_SPEAK = 0.25  # 250ms deliberate pause
PAUSE_AFTER_ACTION = 0.15  # 150ms settle after action


class CommandRouter:
    """Routes voice commands with BMW-style deliberate pacing."""
    
    def __init__(self, app_state):
        self.app_state = app_state
        
        # ─────────────────────────────────────────────────────────────
        # SESSION MEMORY (RAM only, not creepy)
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
    
    def speak(self, message: str):
        """
        Speak with BMW-style deliberate pacing.
        Text leads voice: set transcript, pause, then speak.
        """
        # Set the text first (eyes lead)
        self.app_state.set_transcript(message)
        
        # Deliberate pause (brain reads this as 'thinking')
        time.sleep(PAUSE_BEFORE_SPEAK)
        
        # Then speak (ears follow)
        print(f"[SPEAK] {message}")
        self.app_state.log(f"[SPEAK] {message}")
        tts_speak(message)
    
    def handle_command(self, text: str) -> bool:
        """
        Router function - the heart of the system.
        Returns True if a command was matched, False otherwise.
        """
        if not text:
            self.speak("I didn't catch that.")
            return False
        
        text = text.lower().strip()
        
        # Save transcript to memory (silently)
        self.memory["last_transcript"] = text
        
        # Check each command phrase
        for phrase, action in self.commands.items():
            if phrase in text:
                # Save command to memory (silently)
                self.memory["last_command"] = phrase
                
                # Execute with deliberate response
                self._execute_command(phrase, action)
                return True
        
        # No match found
        self.speak("Command not recognized.")
        return False
    
    def _execute_command(self, phrase: str, action: Callable):
        """Execute command with BMW-style delivery."""
        # Short, confident acknowledgment (no filler)
        response = self._get_response(phrase)
        self.speak(response)
        
        # Settle pause
        time.sleep(PAUSE_AFTER_ACTION)
        
        # Execute action
        action()
    
    def _get_response(self, phrase: str) -> str:
        """Get short, confident response for command."""
        responses = {
            "switch to bmw": "BMW.",
            "switch to audi": "Audi.",
            "switch to bentley": "Bentley.",
            "reload ui": "Reloading.",
            "restart assistant": "Restarting.",
            "open logs": "Opening logs.",
            "repeat that": "Repeating.",
            "help": None,  # Help has its own response
        }
        return responses.get(phrase, phrase.title() + ".")
    
    # ─────────────────────────────────────────────────────────────
    # COMMAND IMPLEMENTATIONS
    # ─────────────────────────────────────────────────────────────
    
    def reload_ui(self):
        """Emit signal to reload the QML UI."""
        print("[CommandRouter] Reloading UI...")
        self.app_state.request_reload_ui()
    
    def restart_assistant(self):
        """Reset assistant state to IDLE."""
        print("[CommandRouter] Restarting assistant...")
        self.app_state.set_state("IDLE")
    
    def set_theme(self, theme_name: str):
        """Switch to a different theme."""
        print(f"[CommandRouter] Switching to {theme_name} theme...")
        self.memory["last_theme"] = theme_name
        self.app_state.set_theme(theme_name)
    
    def open_logs(self):
        """Open the logs file in the default text editor."""
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
    
    def repeat_last(self):
        """Repeat the last command."""
        last = self.memory.get("last_command")
        if last and last != "repeat that":
            # Find and execute the command
            if last in self.commands:
                self.commands[last]()
        else:
            self.speak("Nothing to repeat.")
    
    def show_help(self):
        """Speak available commands - brief and clear."""
        self.speak("Theme, reload, restart, open logs, or help.")
