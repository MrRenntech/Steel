"""
Speech Recognizer - Vosk-based offline speech recognition
Steel OS v6.5

Features:
- Completely offline, no data leaves your PC
- Real-time partial transcripts (subtitles)
- Final transcript when speech ends
"""

import os
import json
import queue
import threading
from typing import Callable, Optional

import sounddevice as sd
from vosk import Model, KaldiRecognizer

class SpeechRecognizer:
    """Offline speech recognition using Vosk."""
    
    def __init__(self, 
                 on_partial: Optional[Callable[[str], None]] = None,
                 on_final: Optional[Callable[[str], None]] = None,
                 sample_rate: int = 16000):
        """
        Initialize the speech recognizer.
        
        Args:
            on_partial: Callback for partial transcripts (live subtitles)
            on_final: Callback for final transcript when speech ends
            sample_rate: Audio sample rate (16000 recommended for Vosk)
        """
        self.on_partial = on_partial
        self.on_final = on_final
        self.sample_rate = sample_rate
        
        self._running = False
        self._audio_queue = queue.Queue()
        self._thread: Optional[threading.Thread] = None
        
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
        self._recognizer = KaldiRecognizer(self._model, sample_rate)
        self._recognizer.SetWords(True)
        print("[SpeechRecognizer] Model loaded successfully")
    
    def _audio_callback(self, indata, frames, time, status):
        """Callback for sounddevice audio stream."""
        if status:
            print(f"[SpeechRecognizer] Audio status: {status}")
        self._audio_queue.put(bytes(indata))
    
    def _recognition_thread(self):
        """Background thread for speech recognition."""
        print("[SpeechRecognizer] Recognition thread started")
        
        while self._running:
            try:
                data = self._audio_queue.get(timeout=0.1)
            except queue.Empty:
                continue
            
            if self._recognizer.AcceptWaveform(data):
                # Final result
                result = json.loads(self._recognizer.Result())
                text = result.get("text", "")
                if text and self.on_final:
                    print(f"[SpeechRecognizer] Final: {text}")
                    self.on_final(text)
            else:
                # Partial result (live subtitles)
                partial = json.loads(self._recognizer.PartialResult())
                text = partial.get("partial", "")
                if text and self.on_partial:
                    self.on_partial(text)
        
        print("[SpeechRecognizer] Recognition thread stopped")
    
    def start(self):
        """Start listening and recognizing speech."""
        if self._running:
            return
        
        self._running = True
        
        # Clear any old data
        while not self._audio_queue.empty():
            self._audio_queue.get()
        
        # Reset recognizer
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
        
        print("[SpeechRecognizer] Started listening")
    
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
        text = result.get("text", "")
        if text and self.on_final:
            print(f"[SpeechRecognizer] Final (on stop): {text}")
            self.on_final(text)
        
        print("[SpeechRecognizer] Stopped listening")
    
    @property
    def is_running(self) -> bool:
        """Check if recognizer is currently listening."""
        return self._running
