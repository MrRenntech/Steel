"""
Command Router - Hardcoded Voice Command System
Steel OS v6.5

Design Philosophy:
- BMW energy: calm, measured, never rushed
- Interrupts bypass EVERYTHING
- Compound commands: "X and Y"
- speak_intent() wrapper for timing discipline
"""

import os
import subprocess
import sys
import time
from typing import Callable, Optional, List

from .tts_engine import speak as tts_speak, interrupt_speech

# ═══════════════════════════════════════════════════════════════════════════
# TIMING CONSTANTS
# ═══════════════════════════════════════════════════════════════════════════
PAUSE_BEFORE_SPEAK = 0.25   # Deliberate pause
PAUSE_AFTER_SPEAK = 0.30    # Closure beat

# ═══════════════════════════════════════════════════════════════════════════
# HARD INTERRUPTS - These ALWAYS work, regardless of state
# ═══════════════════════════════════════════════════════════════════════════
INTERRUPTS = [
    "stop",
    "cancel", 
    "never mind",
    "shut up"
]


def is_interrupt(text: str) -> bool:
    """Check if text contains any interrupt phrase."""
    if not text:
        return False
    text = text.lower()
    return any(phrase in text for phrase in INTERRUPTS)


def split_commands(text: str) -> List[str]:
    """Split compound commands by 'and'."""
    return [cmd.strip() for cmd in text.split(" and ") if cmd.strip()]


class CommandRouter:
    """Routes voice commands with interrupts, compounds, and memory."""
    
    def __init__(self, app_state):
        self.app_state = app_state
        
        # Session memory (RAM only)
        self.memory = {
            "last_command": None,
            "last_theme": None,
            "last_transcript": None,
        }
        
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
    
    # ═══════════════════════════════════════════════════════════════════════════
    # SPEAK INTENT - All speech goes through this
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
        """
        Main entry point. Handles interrupts, compounds, and single commands.
        Returns True if any command was matched.
        """
        if not text:
            self.speak_intent("I didn't catch that.")
            return False
        
        text = text.lower().strip()
        
        # ─────────────────────────────────────────────────────────────
        # STEP 1: CHECK FOR INTERRUPTS (before ANYTHING else)
        # ─────────────────────────────────────────────────────────────
        if is_interrupt(text):
            self._handle_interrupt()
            return True  # Interrupt handled, no further processing
        
        # Save transcript to memory
        self.memory["last_transcript"] = text
        
        # ─────────────────────────────────────────────────────────────
        # STEP 2: CHECK FOR COMPOUND COMMANDS
        # ─────────────────────────────────────────────────────────────
        parts = split_commands(text)
        
        if len(parts) > 1:
            return self._handle_compound(parts)
        
        # ─────────────────────────────────────────────────────────────
        # STEP 3: SINGLE COMMAND
        # ─────────────────────────────────────────────────────────────
        return self._handle_single(text)
    
    def _handle_interrupt(self):
        """Handle hard interrupt - stop everything immediately."""
        print("[CommandRouter] INTERRUPT detected")
        interrupt_speech()
        self.app_state.set_transcript("")
        # Say nothing, or at most "Okay." (brief acknowledgment)
        # We choose silence for maximum respect
        self.app_state.set_state("IDLE")
    
    def _handle_compound(self, parts: List[str]) -> bool:
        """Handle compound command like 'switch to bmw and reload ui'."""
        matched_any = False
        executed = []
        
        for part in parts:
            for phrase, action in self.command_actions.items():
                if phrase in part:
                    if phrase != "repeat that":
                        self.memory["last_command"] = phrase
                    executed.append(phrase)
                    action()
                    matched_any = True
                    break
        
        if matched_any:
            # Narrate once at the end
            self.speak_intent("Done.")
        else:
            self.speak_intent("Command not recognized.")
        
        return matched_any
    
    def _handle_single(self, text: str) -> bool:
        """Handle a single command."""
        for phrase, action in self.command_actions.items():
            if phrase in text:
                if phrase != "repeat that":
                    self.memory["last_command"] = phrase
                action()
                return True
        
        self.speak_intent("Command not recognized.")
        return False
    
    # ═══════════════════════════════════════════════════════════════════════════
    # COMMAND IMPLEMENTATIONS (These speak, then act)
    # ═══════════════════════════════════════════════════════════════════════════
    
    def _set_theme(self, theme_name: str):
        """Switch theme with contextual response."""
        if self.memory["last_theme"] == theme_name:
            self.speak_intent(f"{theme_name.upper()} again.")
        else:
            self.speak_intent(f"{theme_name.upper()}.")
        
        self.memory["last_theme"] = theme_name
        self.app_state.set_theme(theme_name)
    
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
        self.speak_intent("Theme, reload, restart, logs, repeat, stop, or help.")
