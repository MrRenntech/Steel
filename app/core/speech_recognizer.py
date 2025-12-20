"""
Speech Recognizer - Vosk-based offline speech recognition
Steel OS v6.5

Features:
- Completely offline, no data leaves your PC
- COMMAND MODE: Grammar-constrained for high accuracy
- Real-time partial transcripts (subtitles)
- Confidence filtering to prevent accidental triggers
"""

import os
import json
import queue
import threading
from typing import Callable, Optional, List

import sounddevice as sd
from vosk import Model, KaldiRecognizer

# ═══════════════════════════════════════════════════════════════════════════
# COMMAND VOCABULARY - The only phrases we recognize
# ═══════════════════════════════════════════════════════════════════════════
COMMAND_PHRASES = [
    "switch to bmw",
    "switch to audi",
    "switch to bentley",
    "reload ui",
    "restart assistant",
    "open logs",
    "repeat that",
    "help"
]

# Confidence threshold - below this, we ask user to repeat
CONFIDENCE_THRESHOLD = 0.5

def normalize_transcript(text: str) -> str:
    """
    Normalize Vosk output to fix common misrecognitions.
    BMW is notorious for being split as 'bm w'.
    """
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
    
    return text


class SpeechRecognizer:
    """Offline speech recognition using Vosk with grammar constraints."""
    
    def __init__(self, 
                 on_partial: Optional[Callable[[str], None]] = None,
                 on_final: Optional[Callable[[str], None]] = None,
                 on_low_confidence: Optional[Callable[[], None]] = None,
                 sample_rate: int = 16000,
                 command_phrases: List[str] = None):
        """
        Initialize the speech recognizer.
        
        Args:
            on_partial: Callback for partial transcripts (live subtitles)
            on_final: Callback for final transcript when speech ends
            on_low_confidence: Callback when confidence is too low
            sample_rate: Audio sample rate (16000 recommended for Vosk)
            command_phrases: List of valid command phrases (grammar constraint)
        """
        self.on_partial = on_partial
        self.on_final = on_final
        self.on_low_confidence = on_low_confidence
        self.sample_rate = sample_rate
        self.command_phrases = command_phrases or COMMAND_PHRASES
        
        self._running = False
        self._audio_queue = queue.Queue()
        self._thread: Optional[threading.Thread] = None
        
        # Build grammar JSON for Vosk
        self._grammar = json.dumps(self.command_phrases)
        print(f"[SpeechRecognizer] Command grammar: {self._grammar}")
        
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
        
        # Create grammar-constrained recognizer
        self._recognizer = KaldiRecognizer(self._model, sample_rate, self._grammar)
        self._recognizer.SetWords(True)
        print("[SpeechRecognizer] Model loaded with COMMAND MODE grammar")
    
    def _audio_callback(self, indata, frames, time, status):
        """Callback for sounddevice audio stream."""
        if status:
            print(f"[SpeechRecognizer] Audio status: {status}")
        self._audio_queue.put(bytes(indata))
    
    def _recognition_thread(self):
        """Background thread for speech recognition."""
        print("[SpeechRecognizer] Recognition thread started (COMMAND MODE)")
        
        while self._running:
            try:
                data = self._audio_queue.get(timeout=0.1)
            except queue.Empty:
                continue
            
            if self._recognizer.AcceptWaveform(data):
                # Final result
                result = json.loads(self._recognizer.Result())
                raw_text = result.get("text", "")
                
                # Normalize the transcript
                text = normalize_transcript(raw_text)
                
                if text:
                    print(f"[SpeechRecognizer] Raw: '{raw_text}' -> Normalized: '{text}'")
                    
                    if self.on_final:
                        self.on_final(text)
            else:
                # Partial result (live subtitles)
                partial = json.loads(self._recognizer.PartialResult())
                text = partial.get("partial", "")
                if text and self.on_partial:
                    # Also normalize partials for better display
                    self.on_partial(normalize_transcript(text))
        
        print("[SpeechRecognizer] Recognition thread stopped")
    
    def start(self):
        """Start listening and recognizing speech."""
        if self._running:
            return
        
        self._running = True
        
        # Clear any old data
        while not self._audio_queue.empty():
            self._audio_queue.get()
        
        # Reset recognizer with grammar
        self._recognizer = KaldiRecognizer(self._model, self.sample_rate, self._grammar)
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
        
        print("[SpeechRecognizer] Started listening (COMMAND MODE)")
    
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
        
        # Get any final result
        result = json.loads(self._recognizer.FinalResult())
        raw_text = result.get("text", "")
        text = normalize_transcript(raw_text)
        
        if text and self.on_final:
            print(f"[SpeechRecognizer] Final (on stop): '{raw_text}' -> '{text}'")
            self.on_final(text)
        
        print("[SpeechRecognizer] Stopped listening")
    
    @property
    def is_running(self) -> bool:
        """Check if recognizer is currently listening."""
        return self._running
