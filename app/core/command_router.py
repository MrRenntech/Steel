"""
Command Router - Hardcoded Voice Command System
Steel OS v6.5

Rules:
- Exact phrases only
- No guessing, no AI magic
- Acknowledge first, act second
"""

import os
import subprocess
import sys
from typing import Callable, Optional

from .tts_engine import speak as tts_speak

class CommandRouter:
    """Routes voice commands to actions using exact phrase matching."""
    
    def __init__(self, app_state):
        self.app_state = app_state
        
        # Command map: exact phrases -> actions
        self.commands: dict[str, Callable] = {
            "reload ui": self.reload_ui,
            "restart assistant": self.restart_assistant,
            "switch to bmw": lambda: self.set_theme("bmw"),
            "switch to audi": lambda: self.set_theme("audi"),
            "open logs": self.open_logs,
            "help": self.show_help,
        }
    
    def speak(self, message: str):
        """
        Speech output - acknowledge before acting.
        Uses pyttsx3 for actual audio output.
        """
        print(f"[SPEAK] {message}")
        self.app_state.log(f"[SPEAK] {message}")
        tts_speak(message)  # Real audio!
    
    def handle_command(self, text: str) -> bool:
        """
        Router function - the heart of the system.
        Returns True if a command was matched, False otherwise.
        """
        if not text:
            self.speak("I didn't catch that.")
            return False
            
        text = text.lower().strip()
        
        # Check each command phrase
        for phrase, action in self.commands.items():
            if phrase in text:
                # Acknowledge first
                self.speak(f"{phrase.replace('_', ' ').title()}.")
                # Act second
                action()
                return True
        
        # No match found
        self.speak("I didn't understand that yet.")
        return False
    
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
    
    def show_help(self):
        """Speak the list of available commands."""
        commands_list = ", ".join(self.commands.keys())
        self.speak(f"Available commands: {commands_list}.")
        print(f"[CommandRouter] Available commands: {commands_list}")
