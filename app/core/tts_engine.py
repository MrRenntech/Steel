"""
TTS Engine - Thread-safe text-to-speech using pyttsx3
Steel OS v6.5

Key Design:
- Engine initialized ONCE globally
- Queue-based thread safety (commands come from background threads)
- Runs TTS in dedicated thread to not block UI
"""

import queue
import threading
import pyttsx3

class TTSEngine:
    """Thread-safe text-to-speech engine."""
    
    _instance = None
    _lock = threading.Lock()
    
    def __new__(cls):
        """Singleton pattern - only one TTS engine."""
        if cls._instance is None:
            with cls._lock:
                if cls._instance is None:
                    cls._instance = super().__new__(cls)
                    cls._instance._initialized = False
        return cls._instance
    
    def __init__(self):
        if self._initialized:
            return
            
        self._initialized = True
        self._queue = queue.Queue()
        self._running = True
        
        # Initialize engine
        try:
            self._engine = pyttsx3.init()
            self._engine.setProperty("rate", 170)  # Words per minute
            self._engine.setProperty("volume", 1.0)
            
            # Try to set a better voice if available
            voices = self._engine.getProperty("voices")
            for voice in voices:
                # Prefer Microsoft voices on Windows
                if "zira" in voice.name.lower() or "david" in voice.name.lower():
                    self._engine.setProperty("voice", voice.id)
                    break
            
            print("[TTSEngine] Initialized successfully")
        except Exception as e:
            print(f"[TTSEngine] Failed to initialize: {e}")
            self._engine = None
            return
        
        # Start TTS thread
        self._thread = threading.Thread(target=self._tts_loop, daemon=True)
        self._thread.start()
    
    def _tts_loop(self):
        """Dedicated thread for TTS playback."""
        print("[TTSEngine] TTS thread started")
        
        while self._running:
            try:
                text = self._queue.get(timeout=0.5)
                if text is None:  # Shutdown signal
                    break
                    
                if self._engine:
                    print(f"[TTSEngine] Speaking: {text}")
                    self._engine.say(text)
                    self._engine.runAndWait()
                    
            except queue.Empty:
                continue
            except Exception as e:
                print(f"[TTSEngine] Error speaking: {e}")
        
        print("[TTSEngine] TTS thread stopped")
    
    def speak(self, text: str):
        """
        Queue text for speech. Thread-safe - can be called from any thread.
        """
        if not text:
            return
            
        print(f"[TTS] Queued: {text}")
        self._queue.put(text)
    
    def stop(self):
        """Stop the TTS engine."""
        self._running = False
        self._queue.put(None)  # Shutdown signal
        if self._engine:
            self._engine.stop()


# Global singleton instance
_tts_engine = None

def get_tts_engine() -> TTSEngine:
    """Get the global TTS engine instance."""
    global _tts_engine
    if _tts_engine is None:
        _tts_engine = TTSEngine()
    return _tts_engine

def speak(text: str):
    """Convenience function - speak text using global engine."""
    get_tts_engine().speak(text)

def interrupt_speech():
    """Immediately stop any speaking. Used for hard interrupts."""
    engine = get_tts_engine()
    # Clear the queue
    while not engine._queue.empty():
        try:
            engine._queue.get_nowait()
        except:
            break
    # Stop current speech
    if engine._engine:
        engine._engine.stop()
    print("[TTS] Speech interrupted")
