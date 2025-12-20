"""
Persistent Memory - Lightweight, non-creepy storage
Steel OS v6.6

Philosophy:
- Store only what reduces friction next time
- Never store: raw conversations, audio, timestamps, personal preferences
- Do store: stable system choices, repeated actions, explicit confirmations
- Memory should feel like continuity, not recall
"""

import os
import json
from typing import Optional, Any

# Memory file path
MEMORY_FILE = os.path.join(os.path.dirname(__file__), "..", "data", "memory.json")

# Initial schema - start small, no growth yet
DEFAULT_MEMORY = {
    "preferred_theme": None,
    "last_mode": "COMMAND",
    "last_successful_command": None,
}


class PersistentMemory:
    """
    Tier 1 persistent memory - stored as plain JSON.
    
    Rules:
    - Write only when same choice happens twice (prevents accidental memory)
    - Load silently on startup (no announcements)
    - Memory feels like continuity, not recall
    """
    
    def __init__(self):
        self._data = DEFAULT_MEMORY.copy()
        self._pending = {}  # Tracks choices waiting for confirmation
        self._loaded = False
        
        # Load existing memory silently
        self._load()
    
    def _ensure_dir(self):
        """Ensure data directory exists."""
        data_dir = os.path.dirname(MEMORY_FILE)
        if not os.path.exists(data_dir):
            os.makedirs(data_dir, exist_ok=True)
    
    def _load(self):
        """Load memory from disk - silently."""
        try:
            if os.path.exists(MEMORY_FILE):
                with open(MEMORY_FILE, 'r') as f:
                    stored = json.load(f)
                    # Only load known keys
                    for key in DEFAULT_MEMORY:
                        if key in stored:
                            self._data[key] = stored[key]
                    print(f"[Memory] Loaded: {self._data}")
                    self._loaded = True
            else:
                print("[Memory] No existing memory file")
        except Exception as e:
            print(f"[Memory] Load failed: {e}")
    
    def _save(self):
        """Save memory to disk."""
        try:
            self._ensure_dir()
            with open(MEMORY_FILE, 'w') as f:
                json.dump(self._data, f, indent=2)
            print(f"[Memory] Saved: {self._data}")
        except Exception as e:
            print(f"[Memory] Save failed: {e}")
    
    def get(self, key: str) -> Optional[Any]:
        """Get a memory value."""
        return self._data.get(key)
    
    def set_with_confirmation(self, key: str, value: Any):
        """
        Set a value with confirmation requirement.
        First time: stored as pending
        Second time (same value): persisted to disk
        """
        if key not in DEFAULT_MEMORY:
            return  # Reject unknown keys
        
        # Check if this is a confirmation (same choice twice)
        if self._pending.get(key) == value:
            # Confirmed! Persist to disk
            self._data[key] = value
            self._save()
            del self._pending[key]
            print(f"[Memory] Confirmed and persisted: {key} = {value}")
        else:
            # First time - store as pending
            self._pending[key] = value
            print(f"[Memory] Pending (needs confirmation): {key} = {value}")
    
    def set_immediate(self, key: str, value: Any):
        """Set a value immediately (for explicit confirmations)."""
        if key not in DEFAULT_MEMORY:
            return
        
        self._data[key] = value
        self._save()
    
    @property
    def preferred_theme(self) -> Optional[str]:
        return self._data.get("preferred_theme")
    
    @property
    def last_mode(self) -> str:
        return self._data.get("last_mode", "COMMAND")
    
    @property
    def last_successful_command(self) -> Optional[str]:
        return self._data.get("last_successful_command")


# Global singleton
_memory = None

def get_memory() -> PersistentMemory:
    """Get the global memory instance."""
    global _memory
    if _memory is None:
        _memory = PersistentMemory()
    return _memory
