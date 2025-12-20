"""
Speech Recognizer - Vosk-based offline speech recognition
Steel OS v6.5

Features:
- Completely offline, no data leaves your PC
- COMMAND MODE: Grammar-constrained for high accuracy
- CONVERSATION MODE: Full language model for open dialogue
- Real-time partial transcripts (subtitles)
"""

import os
import json
import queue
import threading
from typing import Callable, Optional, List

import sounddevice as sd
from vosk import Model, KaldiRecognizer

# ═══════════════════════════════════════════════════════════════════════════
# COMMAND VOCABULARY - Grammar phrases for Command Mode
# ═══════════════════════════════════════════════════════════════════════════
COMMAND_PHRASES = [
    # Theme commands
    "switch to bmw",
    "switch to audi",
    "switch to bentley",
    # System commands
    "reload ui",
    "restart assistant",
    "open logs",
    "repeat that",
    "help",
    # Hard interrupts
    "stop",
    "cancel",
    "never mind",
    "shut up",
    # Mode switching
    "let's talk",
    "talk to me",
    "conversation mode",
]

# Conversation exit phrases (recognized in full model)
CONVERSATION_EXIT = [
    "that's enough",
    "thats enough",
    "stop talking",
    "back to commands",
    "command mode",
]


def normalize_transcript(text: str) -> str:
    """Normalize Vosk output to fix common misrecognitions."""
    if not text:
        return ""
    
    text = text.lower().strip()
    
    # Fix common Vosk quirks
    text = text.replace("bm w", "bmw")
    text = text.replace("b m w", "bmw")
    text = text.replace("be m w", "bmw")
    text = text.replace("be and w", "bmw")
    text = text.replace("reload you i", "reload ui")
    text = text.replace("reload you eye", "reload ui")
    text = text.replace("let us talk", "let's talk")
    
    return text


class SpeechRecognizer:
    """Offline speech recognition with Command and Conversation modes."""
    
    # Mode constants
    MODE_COMMAND = "COMMAND"
    MODE_CONVERSATION = "CONVERSATION"
    
    def __init__(self, 
                 on_partial: Optional[Callable[[str], None]] = None,
                 on_final: Optional[Callable[[str], None]] = None,
                 sample_rate: int = 16000,
                 command_phrases: List[str] = None):
        """Initialize the speech recognizer."""
        self.on_partial = on_partial
        self.on_final = on_final
        self.sample_rate = sample_rate
        self.command_phrases = command_phrases or COMMAND_PHRASES
        
        self._mode = self.MODE_COMMAND  # Start in command mode
        self._running = False
        self._audio_queue = queue.Queue()
        self._thread: Optional[threading.Thread] = None
        
        # Build grammar JSON for Command Mode
        self._grammar = json.dumps(self.command_phrases)
        print(f"[SpeechRecognizer] Command grammar loaded ({len(self.command_phrases)} phrases)")
        
        # Load model
        model_path = os.path.join(
            os.path.dirname(__file__), 
            "..", "models", "vosk-model-small-en-us-0.15"
        )
        model_path = os.path.abspath(model_path)
        
        if not os.path.exists(model_path):
            raise FileNotFoundError(f"Vosk model not found at: {model_path}")
        
        print(f"[SpeechRecognizer] Loading model from: {model_path}")
        self._model = Model(model_path)
        
        # Create initial recognizer (Command Mode)
        self._recognizer = KaldiRecognizer(self._model, sample_rate, self._grammar)
        self._recognizer.SetWords(True)
        print("[SpeechRecognizer] Ready in COMMAND MODE")
    
    @property
    def mode(self) -> str:
        """Current recognition mode."""
        return self._mode
    
    def set_mode(self, mode: str):
        """Switch between COMMAND and CONVERSATION modes."""
        if mode not in [self.MODE_COMMAND, self.MODE_CONVERSATION]:
            return
        
        if mode == self._mode:
            return  # Already in this mode
        
        self._mode = mode
        
        # Recreate recognizer with appropriate settings
        if mode == self.MODE_COMMAND:
            self._recognizer = KaldiRecognizer(self._model, self.sample_rate, self._grammar)
            print("[SpeechRecognizer] Switched to COMMAND MODE (grammar)")
        else:
            # Full language model for conversation
            self._recognizer = KaldiRecognizer(self._model, self.sample_rate)
            print("[SpeechRecognizer] Switched to CONVERSATION MODE (open)")
        
        self._recognizer.SetWords(True)
    
    def _audio_callback(self, indata, frames, time, status):
        """Callback for sounddevice audio stream."""
        if status:
            print(f"[SpeechRecognizer] Audio status: {status}")
        self._audio_queue.put(bytes(indata))
    
    def _recognition_thread(self):
        """Background thread for speech recognition."""
        print(f"[SpeechRecognizer] Recognition thread started ({self._mode})")
        
        while self._running:
            try:
                data = self._audio_queue.get(timeout=0.1)
            except queue.Empty:
                continue
            
            if self._recognizer.AcceptWaveform(data):
                result = json.loads(self._recognizer.Result())
                raw_text = result.get("text", "")
                text = normalize_transcript(raw_text)
                
                if text:
                    print(f"[SpeechRecognizer] [{self._mode}] '{raw_text}' -> '{text}'")
                    if self.on_final:
                        self.on_final(text)
            else:
                partial = json.loads(self._recognizer.PartialResult())
                text = partial.get("partial", "")
                if text and self.on_partial:
                    self.on_partial(normalize_transcript(text))
        
        print("[SpeechRecognizer] Recognition thread stopped")
    
    def start(self):
        """Start listening and recognizing speech."""
        if self._running:
            return
        
        self._running = True
        
        # Clear queue
        while not self._audio_queue.empty():
            self._audio_queue.get()
        
        # Reset recognizer based on mode
        if self._mode == self.MODE_COMMAND:
            self._recognizer = KaldiRecognizer(self._model, self.sample_rate, self._grammar)
        else:
            self._recognizer = KaldiRecognizer(self._model, self.sample_rate)
        self._recognizer.SetWords(True)
        
        # Start recognition thread
        self._thread = threading.Thread(target=self._recognition_thread, daemon=True)
        self._thread.start()
        
        # Start audio stream
        self._stream = sd.RawInputStream(
            samplerate=self.sample_rate,
            blocksize=8000,
            dtype='int16',
            channels=1,
            callback=self._audio_callback
        )
        self._stream.start()
        
        print(f"[SpeechRecognizer] Started listening ({self._mode})")
    
    def stop(self):
        """Stop listening."""
        if not self._running:
            return
        
        self._running = False
        
        if hasattr(self, '_stream'):
            self._stream.stop()
            self._stream.close()
        
        if self._thread:
            self._thread.join(timeout=1.0)
        
        # Get final result
        result = json.loads(self._recognizer.FinalResult())
        raw_text = result.get("text", "")
        text = normalize_transcript(raw_text)
        
        if text and self.on_final:
            print(f"[SpeechRecognizer] Final: '{text}'")
            self.on_final(text)
        
        print("[SpeechRecognizer] Stopped listening")
    
    @property
    def is_running(self) -> bool:
        return self._running
